import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';

import '../../home/screens/home_page_admin.dart'; 
import '../../home/screens/admin/reports_page.dart'; 
import '../../auth/screens/login.dart';

//bagian ini adalah untuk menampilkan profil admin dengan data yang diambil dari API. Admin dapat melihat nama lengkap, username, dan password (dengan opsi untuk menampilkan atau menyembunyikan password). Terdapat juga tombol logout yang akan menghapus sesi dan mengarahkan admin kembali ke halaman login. Navigasi bawah memungkinkan admin untuk beralih antara dashboard, laporan, dan profil dengan mudah.
class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  int _selectedIndex = 2; 
//bagian ini untuk menyimpan data profil admin yang diambil dari API. Variabel _isLoading digunakan untuk menampilkan indikator loading saat data sedang diambil, sedangkan _passwordVisible digunakan untuk mengontrol apakah password ditampilkan atau disembunyikan.
  String _namaLengkap = 'Loading...';
  String _username = 'Loading...';
  String _password = '';
  bool _isLoading = true;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _tarikDataProfil();
  }
//untuk mengambil data profil admin dari API.
  Future<void> _tarikDataProfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';
//ini untuk memeriksa apakah username aktif tersedia di SharedPreferences. Jika tidak ada, maka akan menampilkan pesan "Sesi Berakhir" pada nama lengkap dan username, serta menghentikan proses loading. Jika ada, maka akan melanjutkan untuk mengambil data profil dari API menggunakan username tersebut. 
    if (usernameAktif.isEmpty) {
      setState(() {
        _namaLengkap = 'Sesi Berakhir';
        _username = 'Sesi Berakhir';
        _isLoading = false;
      });
      return;
    }

    final result = await ApiService.fetchProfile(usernameAktif); 

    if (result['status'] == 'success') {
      setState(() {
        _namaLengkap = result['data']['nama_lengkap'] ?? '-';
        _username = result['data']['username'] ?? '-';
        _password = result['data']['password_hash'] ?? ''; 
        _isLoading = false;
      });
    } else {
      setState(() { 
        _namaLengkap = 'Gagal memuat data';
        _username = 'Gagal memuat data';
        _isLoading = false; 
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(// untuk menampilkan dialog konfirmasi logout saat admin mengklik tombol logout. Dialog ini memiliki tampilan yang menarik dengan ikon, judul, pesan, dan dua tombol untuk konfirmasi.
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(// mengatur tampilan bg dari popup logout (border melengkung, warna, dan warna border).
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container( //untuk menampilkan ikon logout dengan latar belakang merah muda transparan, bentuk lingkaran, dan border merah. Ikon ini memberikan indikasi visual yang jelas bahwa tindakan yang akan dilakukan adalah logout.
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: AppColors.danger, width: 2)),
                  child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Konfirmasi Logout', style: AppStyles.h2White),
                const SizedBox(height: 10),
                Text('Apakah Admin yakin untuk keluar?', textAlign: TextAlign.center, style: AppStyles.bodyGrey),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(//untuk menampilkan tombol "tidak", jika di tombol akan menutup popup (tetap berada di halmaan profil admin).
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Tidak', style: AppStyles.buttonTextGold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async { //untuk mengeksekusi proses logout saat admin mengkonfirmasi dengan menekan tombol "ya". proses ini akan menghapus semua data yang ada di sharedpreferences, lalu akan mengarahkan admin kembali ke halaman login.
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HalamanLogin()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        //untuk mengatur tampilan tombol "ya" dengan warna latar belakang merah, teks putih, dan border radius yang melengkung untuk memberikan tampilan yang menarik dan konsisten dengan tema aplikasi.
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Ya', style: AppStyles.buttonTextWhite),
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
  }

//untuk membangun tampilan profil admin dengan header yang tetap di atas (sticky) dan konten yang bisa di-scroll. Header menampilkan logo dan nama aplikasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // ── KITA BUNGKUS PAKAI COLUMN BIAR HEADER BISA PISAH SAMA SCROLL ──
        child: Column(
          children: [
            // =================================================================
            // ── HEADER STICKY (DI LUAR SCROLL) ──
            // =================================================================
            Padding(
              // ── PADDINGNYA DISAMAIN KAYA HOME PAGE ADMIN: L=20, T=20, R=20, B=10 ──
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildHeader(),
            ),
            
            // =================================================================
            // ── KONTEN BAWAH (BISA DI-SCROLL KARENA ADA EXPANDED) ──
            // =================================================================
            Expanded(//untuk membuat konten prfil admin bisa di scroll jiak isinya melebihi tinggi layar.
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            width: 90, height: 90,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.background, border: Border.all(color: AppColors.primary, width: 3)),
                            child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 50), 
                          ),
                          const SizedBox(height: 14),
                          Text(_namaLengkap, style: AppStyles.h2White),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Container(//untuk  menampilkan ikon admin disebelah kiri teks "amdinprofile"
                                width: 34, height: 34,
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.admin_panel_settings, color: AppColors.background, size: 22),
                              ),
                              const SizedBox(width: 10),
                              Text('Admin Profile', style: AppStyles.h2White),
                            ],
                          ),
                          const SizedBox(height: 22),
                        // untuk menampilkan data dari profil admin dari API yang tidak bisa diedit (static field).
                          _buildStaticField('Nama Lengkap', _namaLengkap),
                          const SizedBox(height: 18),
                          _buildStaticField('Username', _username),
                          const SizedBox(height: 18),
                          _buildPasswordStaticField(), 
                          const SizedBox(height: 40),
                          
                          SizedBox(//untuk menampilkan tombol logout dengan lebar penuh, warna merah, dan teks putih. Saat tombol ini ditekan, akan memanggil fungsi _showLogoutDialog untuk menampilkan dialog konfirmasi logout.
                            width: double.infinity, height: 56,
                            child: ElevatedButton(
                              onPressed: _showLogoutDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                              ),
                              child: Text('Logout', style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),

      //untuk menampilkan bottom navigation bar dengan dua item: dashboard dan laporan. Item yang aktif ditandai dengan warna yang berbeda. Saat admin mengetuk salah satu item, akan mengarahkan ke halaman yang sesuai (dashboard atau laporan) dengan menggantikan halaman saat ini.
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

//untuk membangun tampilan header pada halaman profil admin. Header ini terdiri dari logo aplikasi (gambar) dan nama aplikasi yang ditampilkan secara horizontal. Logo ditempatkan di sebelah kiri, diikuti oleh nama aplikasi yang terdiri dari dua baris teks: "K-16" dan "Lounge App". Header ini dirancang untuk memberikan identitas visual yang konsisten dengan tema aplikasi.
  Widget _buildHeader() {
    return Row(
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
      ],
    );
  }

//ini untuk membangun tampilan field statis yang menampilkan data profil admin seperti nama lengkap dan username. Setiap field terdiri dari label (misalnya "Nama Lengkap") dan nilai yang diambil dari API. Field ini dirancang dengan latar belakang putih, teks berwarna abu-abu gelap, dan border melengkung untuk memberikan tampilan yang bersih dan mudah dibaca.
  Widget _buildStaticField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.h2White.copyWith(fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Text(value, style: AppStyles.bodyWhite.copyWith(color: const Color(0xFF555555))),
        ),
      ],
    );
  }

//ini untuk bagian mengatur tampilan password dengan password ditampilkan sebagai titik-titik, lalu jika admin menekan ikon mata, maka pw akan menampilkan pw asli.
  Widget _buildPasswordStaticField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: AppStyles.h2White.copyWith(fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Row(
            children: [
              Expanded(
                child: Text(_passwordVisible ? _password : '•' * 8, 
                style: AppStyles.bodyWhite.copyWith(color: const Color(0xFF555555), fontSize: _passwordVisible ? 14 : 18, letterSpacing: _passwordVisible ? 0 : 2)),
              ),
              IconButton(
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                icon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}