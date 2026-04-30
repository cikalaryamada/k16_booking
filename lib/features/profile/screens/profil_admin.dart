import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';

import '../../home/screens/home_page_admin.dart'; 
import '../../home/screens/admin/reports_page.dart'; 
import '../../auth/screens/login.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  int _selectedIndex = 2; 

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

  Future<void> _tarikDataProfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';

    if (usernameAktif.isEmpty) {
      setState(() {
        _namaLengkap = 'Sesi Berakhir';
        _username = 'Sesi Berakhir';
        _isLoading = false;
      });
      return;
    }
// untuk mengambil data dari API Service menggunakan username yang aktif dan menampilkan hasilnya di profil admin. Jika terjadi kesalahan, akan menampilkan pesan gagal memuat data.
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
// Fungsi untuk menampilkan dialog konfirmasi logout. Jika admin memilih "Ya", maka data sesi akan dihapus dan admin akan diarahkan ke halaman login. Jika memilih "Tidak", dialog akan ditutup tanpa melakukan tindakan apa pun.
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
            child: Column(// mengatur tata letak popup logout (judul, pesan, dan tombol)dengan jarak yang cukup dan mudah dibaca.
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: AppColors.danger, width: 2)),
                  child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 32),
                ),
                const SizedBox(height: 16),// memberikan jarak antara ikon dan judul untuk membuat tampilan lebih rapi dan mudah dibaca.
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
                        onPressed: () async {//saat admin klik tombol "ya" konfirmasi logout, maka "prefs.clear()" akan menghapus data yang sudah tersimpan di halman login. dan "pushAndRemoveUntil" akan menutup halaman profil kemudian kembali ke haalman login awal.
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HalamanLogin()),
                            (Route<dynamic> route) => false,
                          );
                        },
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
        child: Column(
          children: [
            // ── 1. HEADER DI LUAR SCROLL BIAR DIAM DI ATAS (STICKY) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: _buildHeader(),
            ),
            
            // ── 2. SISA HALAMAN DIBUNGKUS EXPANDED BIAR BISA DI-SCROLL ──
            // untuk menampilkan konten profil admin yang dapat di-scroll. Jika data masih dimuat, akan menampilkan indikator loading. Setelah data berhasil dimuat, akan menampilkan informasi profil admin seperti nama lengkap, username, dan password (dengan opsi untuk menampilkan atau menyembunyikan password). Di bagian bawah juga terdapat tombol logout yang memicu dialog konfirmasi logout.
            Expanded(
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
                              Container(// ikon untuk menampilkan profil admin dengan latar belakang warna utama dan ikon admin di tengahnya. Ikon ini memberikan identitas visual yang jelas bahwa ini adalah halaman profil admin.
                                width: 34, height: 34,
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.admin_panel_settings, color: AppColors.background, size: 22),
                              ),
                              const SizedBox(width: 10),
                              Text('Admin Profile', style: AppStyles.h2White),
                            ],
                          ),
                          const SizedBox(height: 22),
                        //untuk menampilkan informasi profil admin seperti nama lengkap, username, dan password yang tidak bisa diedit secara manual. 
                          _buildStaticField('Nama Lengkap', _namaLengkap),
                          const SizedBox(height: 18),
                          _buildStaticField('Username', _username),
                          const SizedBox(height: 18),
                          _buildPasswordStaticField(), 
                          const SizedBox(height: 40),
                        // untuk menampilkan tombol logout yang nantinya akan mucul dialog/popup  konfirmasi logout saat di klik.
                          SizedBox(
                            width: double.infinity, height: 56,
                            child: ElevatedButton(
                              onPressed: _showLogoutDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,// warna latar belakang tombol logout.
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                              ),
                              child: Text('Logout', style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),// teks pada tombol logout dengan gaya teks yang sudah didefinisikan di AppStyles.
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
      // untuk menampilkan bottom navigation bar dengan dua item: "Home" dan "History". Saat admin memilih salah satu item, aplikasi akan menavigasi ke halaman yang sesuai (AdminDashboard untuk "Home" dan ReportPage untuk "History"). Item yang dipilih akan ditandai dengan warna yang berbeda untuk memberikan umpan balik visual kepada pengguna.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {// untuk 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReportPage()));
          }
        },
        showSelectedLabels: false, showUnselectedLabels: false, type: BottomNavigationBarType.fixed,// untuk menyembunyikan label pada item yang dipilih dan tidak dipilih, serta mengatur jenis bottom navigation bar menjadi fixed agar semua item tetap terlihat tanpa adanya efek shifting.
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ""),
        ],
      ),
    );
  }

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
//untuk membuat kotak input di porfil admmin yang tidak bisa diedit manual, jadi hanya untuk menampilkan data saja, untuk merubahnya lewat login di halaman login awal.
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
                child: Text(_passwordVisible ? _password : '•' * 8, //pengaturan pasword yang ada tombol mata, untuk menampilkan pasword nya, jika tidak di klik maka akan menampilkan titik".
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