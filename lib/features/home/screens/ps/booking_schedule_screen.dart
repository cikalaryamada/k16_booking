import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 
import '../../../../core/network/api_service.dart'; 

import '../home_page_cust.dart'; 
import '../../../profile/screens/profil_customer.dart'; 
import '../Notifikasipage.dart'; 
import '../BookingHistoryPage.dart'; 

class BookingScheduleScreen extends StatefulWidget {
  final String idTarif;
  final String idUnit;
  final String namaTampil;
  final String fisikRuangan;
  final double hargaPerJam;

  const BookingScheduleScreen({
    super.key,
    required this.idTarif,
    required this.idUnit,
    required this.namaTampil,
    required this.fisikRuangan,
    required this.hargaPerJam,
  });

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  int _selectedIndex = 0;
  
  List<DateTime> listHari = [];
  DateTime? _tanggalTerpilih;
  
  List<String> listJam24 = [];
  List<String> jamTerbooking = [];
  String? _jamTerpilih;
  
  int _durasiJam = 1; 

  bool _isLoadingJadwal = true;
  bool _isProsesBooking = false;

  @override
  void initState() {
    super.initState();
    _generateHariDanJam();
    _tarikJadwalDariDatabase();
  }

  void _generateHariDanJam() {
    DateTime hariIni = DateTime.now();
    for (int i = 0; i < 7; i++) {
      listHari.add(hariIni.add(Duration(days: i)));
    }
    _tanggalTerpilih = listHari.first;

    for (int i = 0; i < 24; i++) {
      listJam24.add("${i.toString().padLeft(2, '0')}:00");
    }
  }

  Future<void> _tarikJadwalDariDatabase() async {
    setState(() => _isLoadingJadwal = true);
    String tglFormatSql = DateFormat('yyyy-MM-dd').format(_tanggalTerpilih!);
    
    final booked = await ApiService.fetchJadwal(widget.idUnit, tglFormatSql);
    
    setState(() {
      jamTerbooking = booked;
      _jamTerpilih = null; 
      _durasiJam = 1; 
      _isLoadingJadwal = false;
    });
  }

  bool _isDurasiAman(String jamMulai, int durasiCek) {
    int startInt = int.parse(jamMulai.split(":")[0]);
    for (int i = 0; i < durasiCek; i++) {
      int checkJam = (startInt + i) % 24; 
      String checkJamStr = "${checkJam.toString().padLeft(2, '0')}:00";
      if (jamTerbooking.contains(checkJamStr)) {
        return false; 
      }
    }
    return true;
  }

  bool _isJamMasukDurasi(String jamKotak) {
    if (_jamTerpilih == null) return false;
    int startInt = int.parse(_jamTerpilih!.split(":")[0]);
    int kotakInt = int.parse(jamKotak.split(":")[0]);
    
    if (kotakInt >= startInt && kotakInt < startInt + _durasiJam) {
      return true;
    }
    return false;
  }

  Future<void> _prosesBooking() async {
    if (_jamTerpilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih jam mainnya dulu juragan!")));
      return;
    }

    setState(() => _isProsesBooking = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username_aktif') ?? '';

    String tglFormatSql = DateFormat('yyyy-MM-dd').format(_tanggalTerpilih!);
    
    // ── JURUS ANTI MESIN WAKTU ──
    int jamInt = int.parse(_jamTerpilih!.split(":")[0]);
    int hitungSelesai = jamInt + _durasiJam;
    // Kalau selesainya pas angka 24, kita tulis "24:00" biar logis
    String jamSelesai = hitungSelesai == 24 ? "24:00" : "${(hitungSelesai % 24).toString().padLeft(2, '0')}:00";
    
    double totalHarga = widget.hargaPerJam * _durasiJam; 

    final result = await ApiService.buatBooking(
      username, widget.idTarif, widget.idUnit, tglFormatSql, _jamTerpilih!, jamSelesai, totalHarga
    );

    setState(() => _isProsesBooking = false);

    if (result['status'] == 'success') {
      if (mounted) {
        _showSuccessDialog(
          context, 
          result['no_pesanan'].toString(), 
          result['nama_pelanggan'].toString(),
          "$_jamTerpilih - $jamSelesai"
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${result['message']}")));
      }
    }
  }

  void _showSuccessDialog(BuildContext context, String noPesanan, String namaPelanggan, String jamMain) {
    String tglIndo = DateFormat('dd/MM/yyyy').format(_tanggalTerpilih!);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFE5E2D1), 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFACC15), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                
                Text('BOOKING BERHASIL\nDIPESAN', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF423B21), height: 1.2)),
                const SizedBox(height: 8),
                Text('Terima kasih atas pesanan mu!', style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF423B21), fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                
                const Divider(color: Color(0xFFFACC15), thickness: 2.5),
                const SizedBox(height: 16),
                
                Align(alignment: Alignment.centerLeft, child: Text('Ringkasan Pemesanan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF423B21)))),
                const SizedBox(height: 16),

                _buildDetailRow('Nomor Pesanan', noPesanan), 
                _buildDetailRow('Pelanggan', namaPelanggan),  
                _buildDetailRow('Room', widget.namaTampil), 
                _buildDetailRow('Kursi', widget.fisikRuangan.replaceAll('Kursi ', '')),
                _buildDetailRow('Jadwal', '$tglIndo\n$jamMain WIB'),
                
                const SizedBox(height: 20),
                Text('Mohon datang 15 menit sebelum waktu booking', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF423B21), fontWeight: FontWeight.w500)),
                const SizedBox(height: 28),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text('TUTUP & KEMBALI KE HALAMAN UTAMA', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF423B21), fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF423B21)))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0), child: _buildHeader(context)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0), child: _buildSubHeader(context)),
            const SizedBox(height: 24),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildDateSelector(),
                    const SizedBox(height: 20),
                    Container(height: 3, width: double.infinity, color: AppColors.primary),
                    const SizedBox(height: 20),
                    
                    _buildDurasiSelector(),
                    const SizedBox(height: 20),

                    _isLoadingJadwal 
                        ? const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primary))
                        : _buildTimeGrid(),
                    
                    const SizedBox(height: 24),
                    if (_jamTerpilih != null) _buildSummaryCard(),
                    const SizedBox(height: 24),
                    _buildCheckoutCard(context), 
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDurasiSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Durasi Main', style: AppStyles.h2White),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: _durasiJam > 1 ? AppColors.primary : Colors.grey, size: 28),
              onPressed: _durasiJam > 1 ? () {
                setState(() {
                  _durasiJam--;
                });
              } : null,
            ),
            SizedBox(
              width: 60,
              child: Text('$_durasiJam Jam', textAlign: TextAlign.center, style: AppStyles.h2White),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: _jamTerpilih != null ? AppColors.primary : Colors.grey, size: 28),
              onPressed: () {
                if (_jamTerpilih == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih jadwal jam di bawah terlebih dahulu!")));
                  return;
                }

                int startInt = int.parse(_jamTerpilih!.split(":")[0]);
                int maxDurasiHariIni = 24 - startInt;

                if (_durasiJam >= maxDurasiHariIni) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Maksimal batas booking di hari yang sama adalah jam 00:00!")));
                  return;
                }

                setState(() {
                  _durasiJam++;
                  if (!_isDurasiAman(_jamTerpilih!, _durasiJam)) {
                    _durasiJam--; 
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Durasi nabrak jadwal yang udah di-booking orang!")));
                  }
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/logo_ksixteen.jpeg')),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)), Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1))],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage()))
          ),
        ),
      ],
    );
  }

  Widget _buildSubHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2.0)), child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 16))),
        const SizedBox(width: 15),
        Expanded(child: Text('${widget.namaTampil} - ${widget.fisikRuangan}', style: AppStyles.h2White.copyWith(fontSize: 18), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listHari.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = listHari[index];
          final isSelected = date.day == _tanggalTerpilih?.day;
          return GestureDetector(
            onTap: () {
              setState(() => _tanggalTerpilih = date);
              _tarikJadwalDariDatabase(); 
            },
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryDark : AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryDark),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('EEE', 'id_ID').format(date), style: GoogleFonts.poppins(fontSize: 12, color: isSelected ? Colors.white : AppColors.textGrey)),
                  Text(DateFormat('dd').format(date), style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textWhite)),
                  Text(DateFormat('MMM').format(date), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textWhite)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid() {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: listJam24.map((jam) {
        bool isBooked = jamTerbooking.contains(jam);
        bool isSelected = _isJamMasukDurasi(jam);

        Color bgColor = isSelected ? AppColors.primaryDark : isBooked ? AppColors.danger : AppColors.cardDark;
        Color borderColor = isSelected ? AppColors.primaryDark : isBooked ? AppColors.danger : AppColors.primaryDark;
        Color textColor = isSelected ? Colors.white : isBooked ? Colors.white54 : Colors.white;

        return GestureDetector(
          onTap: isBooked ? null : () {
            setState(() {
              _jamTerpilih = jam;
              _durasiJam = 1; 
            });
          },
          child: Container(
            width: 75, padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
            alignment: Alignment.center,
            child: Text(jam, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard() {
    // ── JURUS ANTI MESIN WAKTU ──
    int jamAwal = int.parse(_jamTerpilih!.split(":")[0]);
    int hitungSelesai = jamAwal + _durasiJam;
    String jamSelesai = hitungSelesai == 24 ? "24:00" : "${(hitungSelesai % 24).toString().padLeft(2, '0')}:00";
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryDark)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$_durasiJam Jam', style: AppStyles.h2White),
          const SizedBox(width: 20),
          Container(height: 30, width: 2, color: AppColors.primary),
          const SizedBox(width: 20),
          Text('$_jamTerpilih - $jamSelesai', style: AppStyles.h2White),
        ],
      ),
    );
  }

  Widget _buildCheckoutCard(BuildContext context) {
    double totalHarga = widget.hargaPerJam * _durasiJam;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryDark)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Harga:', style: AppStyles.bodyWhite),
              Text('Rp. ${totalHarga.toInt()}', style: AppStyles.h1Gold),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _jamTerpilih == null ? Colors.grey : AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _isProsesBooking || _jamTerpilih == null ? null : () => _prosesBooking(),
              child: _isProsesBooking 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('Konfirmasi', style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textWhite,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        if (index == 0) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
        } else if (index == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BookingHistoryPage()));
        } else if (index == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CustProfilAccount()));
        }
      },
      showSelectedLabels: false, showUnselectedLabels: false, type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ""),
      ],
    );
  }
}