import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── SESUAIKAN IMPORT INI DENGAN STRUKTUR FOLDERMU ──
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<dynamic> _bookingHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tarikDataRiwayat();
  }

  // ── FUNGSI TARIK DATA DARI DATABASE (LEWAT API SERVICE) ──
  Future<void> _tarikDataRiwayat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';

    if (usernameAktif.isNotEmpty) {
      try {
        // Menggunakan fungsi fetchNotifikasi yang sudah ada di api_service.dart
        final data = await ApiService.fetchNotifikasi(usernameAktif);
        if (mounted) {
          setState(() {
            _bookingHistory = data;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal memuat riwayat: $e")),
          );
        }
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background gelap sesuai screenshot
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER K-16 LOUNGE APP ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/logo_ksixteen.jpeg'), // Pastikan aset ini ada
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "K-16",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.2),
                      ),
                      Text(
                        "Lounge App",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── TOMBOL BACK & JUDUL HALAMAN ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 2.0),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.amber, size: 18),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Booking History",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── LIST RIWAYAT BOOKING ──
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                  : _bookingHistory.isEmpty
                      ? const Center(
                          child: Text("Belum ada riwayat booking",
                              style: TextStyle(color: Colors.white54)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: _bookingHistory.length,
                          itemBuilder: (context, index) {
                            var data = _bookingHistory[index];
                            return _buildHistoryCard(data);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // ── WIDGET CARD UNTUK MASING-MASING ITEM ──
  Widget _buildHistoryCard(dynamic data) {
    // Mapping data dari API/Database
    String namaLayanan = data['nama_tampil'] ?? 'Layanan';
    String tanggal = data['tanggal'] ?? '-';
    
    // Potong detik dari jam (misal 13:00:00 jadi 13:00)
    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai";

    // Format Tanggal (Opsional, dari "2026-02-20" ke "20 Feb 2026", di sini kita asumsikan teks langsung ditampilin, atau kamu butuh fungsi formatter)
    // Untuk simpelnya, kita gunakan tanggal asli dari DB dulu.
    
    String statusDb = data['status'].toString().toUpperCase();

    // Penentuan Icon, Warna, dan Label Status berdasarkan desain
    IconData iconLayanan;
    Color statusColor;
    Color statusBgColor;
    Color cardBorderColor;
    String statusLabel;

    // Cek icon berdasarkan nama layanan
    if (namaLayanan.toLowerCase().contains('ps') || namaLayanan.toLowerCase().contains('playstation')) {
      iconLayanan = Icons.sports_esports;
    } else {
      iconLayanan = Icons.mic_external_on; // Untuk Karaoke
    }

    // Mapping Status Database (MENUNGGU, BERLANGSUNG, SELESAI, BATAL) ke UI Screenshot
    if (statusDb == "MENUNGGU") {
      statusLabel = "Dipesan";
      statusColor = Colors.amber;
      statusBgColor = Colors.amber.withOpacity(0.1);
      cardBorderColor = Colors.amber.withOpacity(0.5);
    } else if (statusDb == "BERLANGSUNG") {
      statusLabel = "Aktif";
      statusColor = const Color(0xFF00BFA5); // Teal
      statusBgColor = const Color(0xFF00BFA5).withOpacity(0.1);
      cardBorderColor = Colors.orange.withOpacity(0.5);
    } else if (statusDb == "BATAL" || statusDb == "DITOLAK") {
      statusLabel = "Batal";
      statusColor = const Color(0xFFFF5252); // Red/Coral
      statusBgColor = const Color(0xFFFF5252).withOpacity(0.1);
      cardBorderColor = Colors.amber.withOpacity(0.3);
    } else { // SELESAI
      statusLabel = "Selesai";
      statusColor = const Color(0xFF64DD17); // Light Green
      statusBgColor = const Color(0xFF64DD17).withOpacity(0.1);
      cardBorderColor = Colors.orange.withOpacity(0.5);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A11), // Warna dasar card kecoklatan gelap
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 1),
      ),
      child: Row(
        children: [
          // Icon Layanan
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconLayanan, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          
          // Info Teks (Nama, Tanggal, Jam)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaLayanan,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "$tanggal   $waktu",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Badge Status (Dipesan, Aktif, Batal, Selesai)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor, width: 1),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}