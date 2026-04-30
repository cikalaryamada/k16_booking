import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/network/api_service.dart';

import '../home_page_admin.dart';
import '../../../profile/screens/profil_admin.dart';
import 'reports_page.dart'; 

class ManageBooking extends StatefulWidget {
  const ManageBooking({super.key});

  @override
  State<ManageBooking> createState() => _ManageBookingState();
}

class _ManageBookingState extends State<ManageBooking> {
  String _selectedFilter = 'Semua (All)';
  int _selectedIndex = 0; 
  
  List<dynamic> _allBookings = [];
  List<dynamic> _units = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/get_manage_bookings.php'));
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            
            List<dynamic> sortedData = List.from(data['data']);
            sortedData.sort((a, b) {
              int getPriority(String status) {
                if (status == 'BERLANGSUNG' || status == 'DIKONFIRMASI') return 1; 
                if (status == 'MENUNGGU') return 2; 
                if (status == 'OFFLINE') return 3; 
                return 4; 
              }
              
              int pA = getPriority(a['status'].toString().toUpperCase());
              int pB = getPriority(b['status'].toString().toUpperCase());
              
              if (pA != pB) {
                return pA.compareTo(pB); 
              } else {
                return b['id_booking'].toString().compareTo(a['id_booking'].toString());
              }
            });

            _allBookings = sortedData;

          } else {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("XAMPP nolak: ${data['message']}"), backgroundColor: Colors.orange));
          }
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR PHP: ${response.body}"), backgroundColor: Colors.red, duration: const Duration(seconds: 10)));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("FILE get_manage_bookings.php KAGAK KETEMU (404)!"), backgroundColor: Colors.red));
      }
      _units = await ApiService.fetchAllUnits();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("KONEKSI API PUTUS: $e"), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateStatusBooking(String idBooking, String statusBaru) async {
    showDialog(context: context, builder: (c) => const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/update_status_booking.php'),
        body: {'id_booking': idBooking, 'status': statusBaru},
      );

      if (!mounted) return;
      Navigator.pop(context); 

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Berhasil mengubah status jadi $statusBaru!"), backgroundColor: Colors.green));
            _fetchData(); 
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal dari XAMPP: ${data['message']}"), backgroundColor: Colors.orange));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("BOCORAN ERROR PHP: ${response.body}"), backgroundColor: Colors.red, duration: const Duration(seconds: 10)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("FILE update_status_booking.php NGGA KETEMU (404)!"), backgroundColor: Colors.red, duration: Duration(seconds: 5)));
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("KONEKSI API PUTUS: $e"), backgroundColor: Colors.red));
    }
  }

  void _showTutupSlotDialog() {
    List<String> listRoom = _units.map((u) => u['nama_tampil'].toString()).toSet().toList();
    String? selectedRoom;
    dynamic selectedKursi; 
    String selectedTanggal = "Hari Ini"; 
    List<int> selectedJamIndexes = []; 

    List<String> listJam = List.generate(24, (index) {
      String start = index.toString().padLeft(2, '0') + ":00";
      String end = (index + 1 == 24 ? "24:00" : (index + 1).toString().padLeft(2, '0') + ":00");
      return "$start - $end";
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            List<dynamic> listKursiTersedia = [];
            if (selectedRoom != null) {
              listKursiTersedia = _units.where((u) => u['nama_tampil'] == selectedRoom).toList();
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), 
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 1.5), 
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tutup Slot Manual", style: AppStyles.h1Gold.copyWith(fontSize: 20)),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildRealDropdown(
                            hint: "Pilih Room", value: selectedRoom,
                            items: listRoom.map((r) => DropdownMenuItem(value: r, child: Text(r, style: AppStyles.bodyWhite.copyWith(fontSize: 11, fontWeight: FontWeight.bold)))).toList(),
                            onChanged: (val) {
                              setStateDialog(() { selectedRoom = val as String?; selectedKursi = null; });
                            }
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildRealDropdown(
                            hint: "Pilih Kursi", value: selectedKursi,
                            items: listKursiTersedia.map((k) => DropdownMenuItem(value: k, child: Text(k['fisik_ruangan'].toString().replaceAll('Kursi ', ''), style: AppStyles.bodyWhite.copyWith(fontSize: 11, fontWeight: FontWeight.bold)))).toList(),
                            onChanged: (val) { setStateDialog(() => selectedKursi = val); }
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pilih Jam", style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 130,
                          child: _buildRealDropdown(
                            hint: "Pilih Tanggal", value: selectedTanggal,
                            items: ["Hari Ini", "Besok"].map((t) => DropdownMenuItem(value: t, child: Text(t, style: AppStyles.bodyWhite.copyWith(fontSize: 11, fontWeight: FontWeight.bold)))).toList(),
                            onChanged: (val) { setStateDialog(() => selectedTanggal = val as String); }
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 220,
                      decoration: BoxDecoration(color: AppColors.cardDark, border: Border.all(color: AppColors.primaryDark, width: 1.5), borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        itemCount: listJam.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedJamIndexes.contains(index);
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                if (isSelected) selectedJamIndexes.remove(index);
                                else selectedJamIndexes.add(index);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isSelected ? Colors.white : AppColors.primaryDark),
                              ),
                              alignment: Alignment.center,
                              child: Text(listJam[index], style: isSelected ? AppStyles.labelBold.copyWith(color: AppColors.background) : AppStyles.bodyWhite),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.cardLight, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 12)),
                            child: Text("Batal", style: AppStyles.buttonTextWhite),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (selectedKursi == null || selectedJamIndexes.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih Kursi dan minimal 1 Jam dulu bosku!"))); return;
                              }
                              selectedJamIndexes.sort();
                              String jamMulai = listJam[selectedJamIndexes.first].split(" - ")[0].trim();
                              String jamSelesai = listJam[selectedJamIndexes.last].split(" - ")[1].trim();
                              DateTime tglDate = selectedTanggal == "Hari Ini" ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
                              String tglSql = DateFormat('yyyy-MM-dd').format(tglDate);

                              Navigator.pop(context);
                              showDialog(context: context, builder: (c) => const Center(child: CircularProgressIndicator()), barrierDismissible: false);

                              final res = await ApiService.tutupSlotManual(selectedKursi['id_tarif'].toString(), selectedKursi['id_unit'].toString(), tglSql, jamMulai, jamSelesai);

                              if (!mounted) return;
                              Navigator.pop(context); 

                              if (res['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil! Slot ditutup manual."), backgroundColor: Colors.green));
                                _fetchData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menutup slot!"), backgroundColor: AppColors.error));
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 12)),
                            child: Text("Tutup slot", style: AppStyles.buttonTextWhite),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRealDropdown({required String hint, required dynamic value, required List<DropdownMenuItem<dynamic>> items, required Function(dynamic) onChanged}) {
    return Container(
      height: 40, padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: const Color(0xFF9E7C4A), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          dropdownColor: const Color(0xFF9E7C4A), isExpanded: true,
          hint: Text(hint, style: AppStyles.bodyWhite.copyWith(fontSize: 11, fontWeight: FontWeight.bold)),
          value: value, icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
          items: items, onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredBookings = _allBookings;
    if (_selectedFilter == 'Playstation') {
      filteredBookings = _allBookings.where((b) => b['jenis'] == 'ps').toList();
    } else if (_selectedFilter == 'Karaoke') {
      filteredBookings = _allBookings.where((b) => b['jenis'] == 'karaoke').toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      
      // =======================================================================
      // ── LOGO K-16 KEMBALI MENGUDARA DI APP BAR! ──
      // =======================================================================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0, 
        automaticallyImplyLeading: false, 
        toolbarHeight: 90, 
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5), 
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/logo_ksixteen.jpeg'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)),
                  Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTutupSlotDialog,
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.white24, width: 1)),
        icon: const Icon(Icons.access_alarms_rounded, color: Colors.white),
        label: const Text("Tutup Slot Manual", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      
      body: SafeArea(
        child: Column(
          children: [
            // =================================================================
            // ── TOMBOL BACK & JUDUL HALAMAN (TETEP STICKY DI BAWAH APP BAR) ──
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8), 
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)), 
                      child: const Icon(Icons.arrow_back, color: AppColors.textWhite, size: 20)
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin Dashboard", style: AppStyles.h2White.copyWith(fontSize: 22)),
                      Text("Manage Booking", style: AppStyles.bodyGrey.copyWith(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            
            // =================================================================
            // ── CHIPS FILTER MENU ──
            // =================================================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterButton("Semua (All)", isSelected: _selectedFilter == 'Semua (All)'),
                  const SizedBox(width: 10),
                  _buildFilterButton("Playstation", icon: Icons.sports_esports, isSelected: _selectedFilter == 'Playstation'),
                  const SizedBox(width: 10),
                  _buildFilterButton("Karaoke", icon: Icons.mic, isSelected: _selectedFilter == 'Karaoke'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // =================================================================
            // ── LIST BOOKING ──
            // =================================================================
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : filteredBookings.isEmpty
                  ? Center(child: Text("Belum ada pesanan", style: AppStyles.bodyGrey))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        return _buildBookingCard(filteredBookings[index]);
                      },
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReportPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminProfileScreen()));
          }
        },
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ""),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, {IconData? icon, required bool isSelected}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon, color: Colors.white, size: 16), const SizedBox(width: 5)],
            Text(text, style: AppStyles.bodyWhite.copyWith(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(dynamic data) {
    Color borderColor;
    Color statusBadgeColor;
    Widget actionButtons;
    String statusText;
    Widget statusWarning = const SizedBox(); 

    String status = (data['status'] ?? '').toString().toUpperCase();
    String idBooking = data['id_booking'].toString();

    String namaCustomer = data['nama_lengkap']?.toString() ?? '-';
    String room = "${data['nama_tampil'] ?? ''} - ${data['fisik_ruangan']?.toString().replaceAll('Kursi ', '') ?? ''}";
    
    String jamMulai = data['jam_mulai'] != null && data['jam_mulai'].toString().length >= 5 ? data['jam_mulai'].toString().substring(0, 5) : '00:00';
    String jamSelesai = data['jam_selesai'] != null && data['jam_selesai'].toString().length >= 5 ? data['jam_selesai'].toString().substring(0, 5) : '00:00';
    
    String tanggalAsli = data['tanggal']?.toString() ?? '';
    String tglFormat = tanggalAsli;
    if (tanggalAsli.length >= 10) {
      List<String> parts = tanggalAsli.split('-');
      if(parts.length == 3) tglFormat = "${parts[2]}/${parts[1]}/${parts[0]}";
    }
    String slot = "$tglFormat ${jamMulai.replaceAll(':', '.')}-${jamSelesai.replaceAll(':', '.')}";

    if (status == 'TELAT') {
      borderColor = Colors.red; statusBadgeColor = Colors.red; statusText = "Status: TELAT (15M)";
      statusWarning = const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.only(right: 15.0, top: 10), child: Icon(Icons.warning_rounded, color: Colors.red, size: 60)));
      actionButtons = SizedBox(width: double.infinity, child: ElevatedButton(onPressed: null, style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("Otomatis Terbatalkan", style: AppStyles.bodyWhite.copyWith(color: Colors.white70))));
    } else if (status == 'MENUNGGU') {
      borderColor = Colors.amber; statusBadgeColor = Colors.amber; statusText = "Menunggu Konfirmasi";
      actionButtons = Row(
        children: [
          Expanded(child: ElevatedButton(onPressed: () => _updateStatusBooking(idBooking, 'DIKONFIRMASI'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("TERIMA", style: AppStyles.buttonTextWhite))),
          const SizedBox(width: 15),
          Expanded(child: ElevatedButton(onPressed: () => _updateStatusBooking(idBooking, 'DITOLAK'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("TOLAK", style: AppStyles.buttonTextWhite))),
        ],
      );
    } else if (status == 'DIKONFIRMASI' || status == 'BERLANGSUNG') {
      borderColor = Colors.green; statusBadgeColor = Colors.cyan; statusText = "Sedang Berjalan";
      actionButtons = SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: () => _updateStatusBooking(idBooking, 'SELESAI'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("SELESAI (Konfirmasi Pembayaran)", style: AppStyles.buttonTextWhite)),
      );
    } else if (status == 'OFFLINE') {
       borderColor = Colors.grey; statusBadgeColor = Colors.grey; statusText = "Manual Offline";
       actionButtons = SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _updateStatusBooking(idBooking, 'SELESAI'), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("Buka Slot Kembali", style: AppStyles.buttonTextWhite)));
    } else {
      borderColor = Colors.grey.shade700; statusBadgeColor = Colors.grey.shade700; statusText = status;
      actionButtons = SizedBox(width: double.infinity, child: ElevatedButton(onPressed: null, style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey.shade800, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text(status == 'SELESAI' ? "Penyewaan Selesai" : "Dibatalkan", style: AppStyles.bodyGrey)));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: borderColor, width: 1.5)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.person, "Customer: ", namaCustomer),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.videogame_asset, "Room: ", room),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.mic, "Slot: ", slot),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("Status: ", style: AppStyles.bodyWhite.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(status == 'TELAT' ? 'TELAT (maks 15M)' : statusText, style: AppStyles.bodyWhite.copyWith(fontSize: 13, color: borderColor, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              actionButtons,
            ],
          ),
          Positioned(
            right: 0, top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: statusBadgeColor, borderRadius: BorderRadius.circular(20)),
              child: Text(
                statusText,
                style: AppStyles.bodyWhite.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: (status == 'MENUNGGU' || status == 'BERLANGSUNG' || status == 'DIKONFIRMASI') ? Colors.black : Colors.white),
              ),
            ),
          ),
          if (status == 'TELAT') statusWarning,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(label, style: AppStyles.bodyWhite.copyWith(fontSize: 13)),
        Text(value, style: AppStyles.bodyWhite.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}