import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── WAJIB IMPORT INI BIAR DESAINNYA KONSISTEN ──
import '../../../core/constants/app_colors.dart'; 
import '../../../core/constants/app_styles.dart'; 
import '../../../core/network/api_service.dart'; 

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  String _filterAktif = "Semua";
  List<dynamic> _semuaNotifikasi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tarikDataNotifikasi();
  }

  // ── FUNGSI NARIK DATABASE NOTIFIKASI ──
  Future<void> _tarikDataNotifikasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';

    if (usernameAktif.isNotEmpty) {
      try {
        final data = await ApiService.fetchNotifikasi(usernameAktif);
        setState(() {
          _semuaNotifikasi = data;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat notifikasi: $e")));
        }
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── LOGIKA FILTER DATA ──
    List<dynamic> notifikasiDitampilkan = _semuaNotifikasi.where((notif) {
      String stat = notif['status'].toString().toUpperCase();
      if (_filterAktif == "Semua") return true;
      if (_filterAktif == "Ditolak" && (stat == "BATAL" || stat == "DITOLAK" || stat == "TELAT")) return true;
      if (_filterAktif == "Menunggu" && stat == "MENUNGGU") return true;
      if (_filterAktif == "Berhasil" && (stat == "BERLANGSUNG" || stat == "SELESAI" || stat == "DIKONFIRMASI")) return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background, // Pake AppColors biar hitamnya konsisten
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ATAS (SAMA KAYA HOME, TAPI TANPA LONCENG) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildHeader(),
            ),
            
            // ── TOMBOL BACK & JUDUL KONSISTEN ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildPageTitle(context),
            ),
            
            const SizedBox(height: 16),
            _buildFilterTabs(),
            const SizedBox(height: 24),
            
            // ── LIST NOTIFIKASI DINAMIS ──
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : notifikasiDitampilkan.isEmpty
                      ? Center(child: Text("Tidak ada notifikasi", style: AppStyles.bodyWhite.copyWith(color: Colors.white54)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding disamain jadi 20
                          itemCount: notifikasiDitampilkan.length,
                          itemBuilder: (context, index) {
                            var item = notifikasiDitampilkan[index];
                            return _buildDynamicNotificationCard(item);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER KHUSUS NOTIFIKASI (CUMA LOGO & TEKS, NO LONCENG) ──
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/logo_ksixteen.jpeg'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)),
            Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
          ],
        ),
      ],
    );
  }

  // ── TOMBOL BACK SAMA PERSIS KAYA HALAMAN PILIH KURSI ──
  Widget _buildPageTitle(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.0),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 16),
          ),
        ),
        const SizedBox(width: 15),
        Text("Notifikasi Booking", style: AppStyles.h2White.copyWith(fontSize: 18)),
      ],
    );
  }

  // ── TOMBOL FILTER YANG SUDAH PAKAI APP COLORS ──
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildChip("Semua"),
          _buildChip("Ditolak"),
          _buildChip("Menunggu"),
          _buildChip("Berhasil"),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    bool isSelected = _filterAktif == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterAktif = label; 
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.primary, 
            fontWeight: FontWeight.bold
          )
        ),
      ),
    );
  }

  // ── MESIN PENENTU WARNA & TEKS OTOMATIS ──
  Widget _buildDynamicNotificationCard(dynamic data) {
    String status = data['status'].toString().toUpperCase();
    String namaTampil = data['nama_tampil'];
    String jam = "${data['jam_mulai']} - ${data['jam_selesai']}";
    String tanggal = data['tanggal'];

    IconData icon; Color iconColor; Color cardColor; 
    String judul; String pesan;

    // KONDISI 1: HIJAU (BERHASIL / BERLANGSUNG)
    if (status == "BERLANGSUNG" || status == "SELESAI" || status == "DIKONFIRMASI") {
      icon = Icons.check_circle;
      iconColor = const Color(0xFF34C759);
      cardColor = const Color(0xFF2F6335);
      judul = "Booking Dikonfirmasi";
      pesan = "Pesanan untuk $namaTampil tanggal $tanggal pukul $jam WIB. Silahkan datang 10 menit sebelum waktu dimulai.";
    } 
    // KONDISI 2: MERAH (BATAL / TELAT)
    else if (status == "BATAL" || status == "DITOLAK" || status == "TELAT") {
      icon = Icons.cancel;
      iconColor = const Color(0xFFFF3B30);
      cardColor = const Color(0xFF622926);
      judul = "Booking Batal / Ditolak";
      pesan = "Pesanan untuk $namaTampil tanggal $tanggal pukul $jam WIB telah dibatalkan atau melewati batas waktu kedatangan.";
    } 
    // KONDISI 3: KUNING (MENUNGGU)
    else {
      icon = Icons.access_time_filled;
      iconColor = AppColors.primary; 
      cardColor = const Color(0xFF635626);
      judul = "Menunggu Konfirmasi";
      pesan = "Pesanan untuk $namaTampil tanggal $tanggal pukul $jam WIB sedang menunggu kedatangan anda atau konfirmasi admin.";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(judul, style: TextStyle(color: iconColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(pesan, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}