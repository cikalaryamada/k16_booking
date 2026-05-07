import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';

import '../../profile/screens/profil_admin.dart'; 
import '../screens/admin/reports_page.dart'; 
import '../screens/admin/manage_booking_page.dart'; 

class AdminDashboard extends StatefulWidget { //untuk membuat halaman dashboard admin yang merupakan halaman utama bagi admin untuk melihat informasi penting dan mengakses fitur-fitur utama dalam aplikasi.
  const AdminDashboard({super.key});

  @override //mengambil fungsi createState untuk membuat state dari widget AdminDashboard, yang akan mengelola tampilan dan logika interaktif dari halaman dashboard admin.
  State<AdminDashboard> createState() => _AdminDashboardState();
}

//ini itu untuk membuat tampilan utama dashboard admin
class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;//menandai navigasi bawah yang aktif (dashboard admin) dengan warna yang berebda.

  double _dailyIncome = 0;//untuk menyimpan nilai pendapatan harian yang akan ditampilkan di dashboard admin.
  List<dynamic> _todaySchedule = [];//untuk menyimpan daftar jadwal hari ini yang akan ditampilkan di dashboard admin.
  bool _isLoading = true;//untuk menandakan apakah data masih dalam proses dimuat. jika masih dimuat, maka akan menampilkan proses loading.

//mengambil fungsi initstate untuk memanggil fungsi_tarikdatadashboard saat halaman pertama kali dibuka. 
//Fungsi ini akan mengambil data dari API dan memperbarui state dengan informasi pendapatan harian dan jadwal hari ini, serta mengubah status loading menjadi false setelah data berhasil diambil atau jika terjadi kesalahan.
  @override
  void initState() {
    super.initState();
    _tarikDataDashboard();
  }

//fungsi ini untuk mengambil data dashboard admin dari API.
  Future<void> _tarikDataDashboard() async {
    try {
      final result = await ApiService.fetchAdminDashboard();
      if (result['status'] == 'success') {
        setState(() {
          _dailyIncome = double.parse(result['income'].toString());
          _todaySchedule = result['jadwal'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

//ini untuk memformat waktu saat ini (realtime) menjadi format yang lebih mudah dibaca seperti "Senin, 1 jan 2024". dibaqwah tulisan "admin dashboard" di halaman admin.
  String _formatDate(DateTime date) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

//ini untuk membangun tampilan utama dashboard admin dengan menggunakan Scaffold sebagai kerangka utama.
  @override
  Widget build(BuildContext context) {//membuat tampilan utama dashboard admin
    return Scaffold(//mengatur warna latar belakang yang sudah di definisikan di Appcolors, dan menampilkan konten utama dalam SafeArea dengan SingleChildScrollView untuk memastikan tampilan responsif dan dapat digulir jika konten melebihi batas layar. 
      backgroundColor: AppColors.background,
      body: SafeArea(
        // ── KITA BUNGKUS PAKAI COLUMN BIAR HEADER BISA PISAH SAMA SCROLL ──
        child: Column( //mengatur tata letak konten dalam kolom dengan jarak antara header dan konten utama, serta memastikan konten utama dapat digulir jika melebihi batas layar.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================================
            // ── HEADER STICKY (DI LUAR SCROLL) ──
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildCommonHeader(context),
            ),
            
            // =================================================================
            // ── KONTEN BAWAH (BISA DI-SCROLL KARENA ADA EXPANDED) ──
            // =================================================================
            Expanded(//mengatur agar konten utama dapat mengisi ruang yang tersedia di bawah header dan 
            //memungkinkan konten untuk digulir jika melebihi batas layar (menggunakan SingleChildScrollView).
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(//mengatur tata letak konten dalam kolom dengan jarak antara judul dan tanggal, serta memastikan konten tetap terpusat di halaman.
                      child: Column(
                        children: [
                          Text('Admin Dashboard', style: AppStyles.h1Gold.copyWith(fontSize: 26)),
                          const SizedBox(height: 6),
                          Text(_formatDate(DateTime.now()), style: AppStyles.bodyGrey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    //menampilkan kartu pendapatan harian yang menampilkan informasi tentang pendapatan hari ini dengan ikon dan gaya teks yang sesuai, serta menampilkan indikator loading jika data masih dalam proses dimuat.
                    _buildDailyIncomeCard(),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildTodaySchedule(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //menampilkan tombol navigasi bawah yang memungkinkan admin untuk beralih ke halaman yang diinginkan 
      //profil dengan ikon yang sesuai, serta menandai halaman yang sedang aktif dengan warna yang berbeda.
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  //ini itu untuk membuat tampilan header umum yang menampilkan logo aplikasi dan nama aplikasi di sebelah kiri atas
  Widget _buildCommonHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
      ],
    );
  }

  // ini untuk membangun tampilan kartu pendapatan harian yang menampilkan informasi tentang pendapatan hari ini
  Widget _buildDailyIncomeCard() {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0); //format pendapatan harian sesuai dengan mata uang indonesia

    return Container(//mengatur tampilan kartu dengan lebar penuh, padding, warna latar belakang yang sesuai dengan tema aplikasi, serta border dan border radius untuk memberikan efek kartu yang menarik.
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.cardLight, AppColors.cardDark]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      //mengatur tata letak konten dalam baris dengan ikon di sebelah kiri dan teks di sebelah kanan, serta memberikan jarak antara ikon dan teks.
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 35),//menampilkan ikon dompet yang relevan dengan informasi pendapatan harian, serta mengatur warna dan ukuran ikon agar sesuai dengan tema aplikasi.
          const SizedBox(width: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pendapatan Hari Ini', style: AppStyles.bodyWhite),//menampilkan judul "Pendapatan Hari Ini" dengan gaya teks yang sesuai, serta memastikan teks tetap terbaca dengan baik.
              _isLoading //menampilkan indikator loading jika data masih dalam proses dimuat, dan menampilkan pendapatan harian yang sudah diformat jika data sudah berhasil dimuat, serta mengatur gaya teks untuk memastikan informasi pendapatan tetap terbaca dengan baik.
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
                  : Text(formatter.format(_dailyIncome), style: AppStyles.h1Gold.copyWith(fontSize: 26)),
            ],
          ),
        ],
      ),
    );
  }

  // untuk membuat tombol aksi  cepat ke halaman view reports dan manage booking.
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppStyles.labelBold),
        const SizedBox(height: 12),
        _buildActionButton(Icons.access_time, 'Manage Booking', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBooking()));
        }),
        const SizedBox(height: 10),
        _buildActionButton(Icons.list_alt, 'View Reports', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
        }),
      ],
    );
  }

  //ini untuk membangun tampilan tombol aksi yang digunakan dalam bagian "Quick Actions" di dashboard admin. Tombol ini dirancang dengan warna latar belakang yang sesuai dengan tema aplikasi, serta menampilkan ikon dan label yang relevan dengan fungsi tombol. Ketika tombol ditekan, akan memanggil fungsi onTap yang sesuai untuk menavigasi ke halaman yang diinginkan.
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryDark)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 14),
            Text(label, style: AppStyles.buttonTextWhite),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 14),
          ],
        ),
      ),
    );
  }

  //ini untuk menampilkan jadwal hari ini yang sudah diformat dengan informasi tentang nama lengkap pengguna, nama tampil, fisik ruangan, waktu booking, dan status booking. Jika data masih dalam proses dimuat, akan menampilkan indikator loading, dan jika tidak ada jadwal hari ini, akan menampilkan pesan yang sesuai.
  Widget _buildTodaySchedule(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Jadwal Hari Ini", style: AppStyles.labelBold),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
              },
              child: Text('More', style: AppStyles.buttonTextGold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        _isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _todaySchedule.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryDark)),
                    child: Center(child: Text('Belum ada jadwal hari ini', style: AppStyles.bodyGrey)),
                  )
                : Column(
                    children: _todaySchedule.map((jadwal) => _buildScheduleCard(jadwal)).toList(),
                  ),
      ],
    );
  }
  //untuk membangun tampilan kartu jadwal yang menampilkan informasi tentang setiap booking, termasuk nama lengkap pengguna, nama tampil, fisik ruangan, waktu booking, dan status booking. 
  //Kartu ini dibuat dengan warna latar belakang yang sesuai dengan status booking (misalnya hijau untuk booking yang sedang berlangsung atau dikonfirmasi, merah untuk booking yang dibatalkan atau ditolak) dan menampilkan ikon yang relevan.
  Widget _buildScheduleCard(dynamic data) {
    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai WIB";
    String status = data['status'].toString().toUpperCase();
    
    Color statusColor = (status == "BERLANGSUNG" || status == "DIKONFIRMASI") ? const Color(0xFF34C759) : AppColors.primary;

    //mengatur tampilan kartu dengan margin, padding, warna latar belakang yang sesuai dengan status booking, serta border dan border radius untuk memberikan efek kartu yang menarik.
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark),
      ),
      //mengatur tata letak konten dalam baris dengan ikon di sebelah kiri, informasi booking di tengah, dan status booking di sebelah kanan, serta memberikan jarak antara elemen-elemen tersebut untuk memastikan tampilan yang rapi dan mudah dibaca.
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.receipt_long_rounded, color: statusColor),
          ),
          // Memberikan jarak horizontal antara ikon dan informasi booking untuk meningkatkan keterbacaan dan estetika tampilan kartu.
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,//mengatur agar teks dalam kolom rata kiri untuk memastikan informasi booking mudah dibaca dan terstruktur dengan baik.
              children: [ //menampilkan nama lengkap pengguna dengan gaya teks yang sesuai, serta memastikan teks tetap terbaca dengan baik meskipun ada informasi tambahan di bawahnya.
                Text(data['nama_lengkap'] ?? 'User', style: AppStyles.labelBold.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('${data['nama_tampil']} - ${data['fisik_ruangan'].toString().replaceAll('Kursi ', '')}', style: AppStyles.bodyGrey.copyWith(fontSize: 11)),
                Text(waktu, style: AppStyles.bodyGrey.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Container( //mengatur tampilan status booking dengan padding, warna latar belakang yang sesuai dengan status, serta border dan border radius untuk memberikan efek yang menarik dan membedakan status booking dengan jelas.
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: statusColor), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  //ini untuk membangun tampilan tombol navigasi bawah yang memungkinkan admin untuk beralih antara halaman utama, laporan, dan profil dengan ikon yang sesuai, serta menandai halaman yang sedang
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textWhite,
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 1) {
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
    );
  }
}