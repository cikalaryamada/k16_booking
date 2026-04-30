import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';

import '../../home/screens/home_page_cust.dart'; 
import '../../profile/screens/profil_customer.dart'; 
import 'notifikasipage.dart'; 

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<dynamic> _bookingHistory = [];
  bool _isLoading = true;
  int _selectedIndex = 1; 

  @override
  void initState() {
    super.initState();
    _tarikDataRiwayat();
  }

  Future<void> _tarikDataRiwayat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';

    if (usernameAktif.isNotEmpty) {
      try {
        final data = await ApiService.fetchNotifikasi(usernameAktif);
        
        if (mounted) {
          // ── JURUS AUTO-SORT (YANG AKTIF/MENUNGGU NAIK KE ATAS) ──
          List<dynamic> sortedData = List.from(data);
          sortedData.sort((a, b) {
            int getPriority(String status) {
              if (status == 'BERLANGSUNG' || status == 'DIKONFIRMASI') return 1; // Paling atas
              if (status == 'MENUNGGU') return 2;
              return 3; // SELESAI, BATAL, DITOLAK di bawah
            }
            
            int pA = getPriority(a['status'].toString().toUpperCase());
            int pB = getPriority(b['status'].toString().toUpperCase());
            
            if (pA != pB) {
              return pA.compareTo(pB); 
            } else {
              String idA = a['id_booking'].toString();
              String idB = b['id_booking'].toString();
              return idB.compareTo(idA);
            }
          });

          setState(() {
            _bookingHistory = sortedData;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat riwayat: $e")));
        }
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDetailDialog(BuildContext context, dynamic data) {
    String statusDb = data['status'].toString().toUpperCase();
    
    String noPesanan = data['id_booking']?.toString() ?? '-';
    String namaPelanggan = data['nama_lengkap']?.toString() ?? '-';
    String namaLayanan = data['nama_tampil']?.toString() ?? 'Layanan';
    
    String kursi = (data['fisik_ruangan']?.toString() ?? '-').replaceAll('Kursi ', '');
    if (kursi.length == 1) kursi = "0$kursi";

    String tanggal = data['tanggal'] ?? '-';
    try {
      DateTime parsedDate = DateTime.parse(tanggal);
      tanggal = DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {}

    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai WIB";

    Color themeColor;
    String statusLabel;
    String pesanBawah;

    // ── LOGIKA DESAIN POP-UP (UDAH DIBENERIN SESUAI FOTO BIRU!) ──
    if (statusDb == "DIKONFIRMASI" || statusDb == "BERLANGSUNG") {
      themeColor = const Color(0xFF339CBE); // Biru Muda khas desain lu!
      statusLabel = "Sedang Berlangsung";
      pesanBawah = "Sesi Anda sedang berlangsung. Selamat\nmenikmati layanan kami!";
    } else if (statusDb == "MENUNGGU") {
      themeColor = const Color(0xFFFACC15); // Kuning
      statusLabel = "Menunggu Konfirmasi";
      pesanBawah = "Mohon datang 15 menit sebelum waktu booking\nTunjukkan bukti booking & bayar di lokasi untuk mulai.";
    } else if (statusDb == "SELESAI") {
      themeColor = const Color(0xFF388E3C); // Hijau
      statusLabel = "Selesai";
      pesanBawah = "Sesi Anda telah berakhir. Terima kasih telah berkunjung!";
    } else {
      themeColor = const Color(0xFFE53935); // Merah
      statusLabel = "Dibatalkan";
      pesanBawah = "Mohon maaf proses ini gagal/dibatalkan\nkarena telah melewati dari jadwal";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: themeColor, width: 4)),
          backgroundColor: const Color(0xFFDDDBCB), // Warna krem keabuan
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('RINGKASAN PEMESANAN', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF3E371C))),
                const SizedBox(height: 12),
                Divider(color: themeColor, thickness: 3),
                const SizedBox(height: 16),
                
                _buildDetailRow('Nomor Pesanan', noPesanan.padLeft(6, '0')), 
                _buildDetailRow('Pelanggan', namaPelanggan),  
                _buildDetailRow('Room', namaLayanan), 
                _buildDetailRow('Kursi', kursi),
                _buildDetailRow('Jadwal', '$tanggal\n$waktu'),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 130, child: Text('Status', style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF3E371C), fontWeight: FontWeight.w600))),
                      Expanded(child: Text(statusLabel, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: themeColor))),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                Text(pesanBawah, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF3E371C), fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 3),
                    onPressed: () => Navigator.pop(context),
                    child: Text('TUTUP & KEMBALI', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
          SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF3E371C), fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF3E371C)))),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/logo_ksixteen.jpeg')),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)),
                          Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage())),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2.0)),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 18),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("Booking History", style: AppStyles.h2White.copyWith(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _bookingHistory.isEmpty
                      ? Center(child: Text("Belum ada riwayat booking", style: AppStyles.bodyGrey))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: _bookingHistory.length,
                          itemBuilder: (context, index) {
                            var data = _bookingHistory[index];
                            return GestureDetector(
                              onTap: () => _showDetailDialog(context, data),
                              child: _buildHistoryCard(data),
                            );
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
      ),
    );
  }

  Widget _buildHistoryCard(dynamic data) {
    String namaLayanan = data['nama_tampil'] ?? 'Layanan';
    String tanggal = data['tanggal'] ?? '-';
    
    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai";
    String statusDb = data['status'].toString().toUpperCase();

    IconData iconLayanan = (namaLayanan.toLowerCase().contains('ps') || namaLayanan.toLowerCase().contains('playstation')) 
        ? Icons.sports_esports : Icons.mic_external_on;
        
    Color statusColor;
    Color statusBgColor;
    Color cardBorderColor;
    String statusLabel;

    if (statusDb == "MENUNGGU") {
      statusLabel = "Dipesan"; statusColor = Colors.amber; statusBgColor = Colors.amber.withOpacity(0.1); cardBorderColor = Colors.amber.withOpacity(0.5);
    } else if (statusDb == "BERLANGSUNG" || statusDb == "DIKONFIRMASI") {
      // ── WARNA BIRU MUDA + TEKS 'AKTIF' ──
      statusLabel = "Aktif"; statusColor = const Color(0xFF339CBE); statusBgColor = const Color(0xFF339CBE).withOpacity(0.1); cardBorderColor = const Color(0xFF339CBE).withOpacity(0.5);
    } else if (statusDb == "BATAL" || statusDb == "DITOLAK" || statusDb == "TELAT") {
      statusLabel = "Batal"; statusColor = const Color(0xFFFF5252); statusBgColor = const Color(0xFFFF5252).withOpacity(0.1); cardBorderColor = Colors.red.withOpacity(0.3);
    } else { 
      statusLabel = "Selesai"; statusColor = const Color(0xFF64DD17); statusBgColor = const Color(0xFF64DD17).withOpacity(0.1); cardBorderColor = Colors.green.withOpacity(0.3);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: cardBorderColor, width: 1)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(iconLayanan, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namaLayanan, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text("$tanggal   $waktu", style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor, width: 1)),
            child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}