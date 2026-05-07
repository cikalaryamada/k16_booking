import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 
import '../../../../core/network/api_service.dart'; 
import '../home_page_admin.dart'; 
import '../../../profile/screens/profil_admin.dart'; 

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

//untuk menampilkan halaman dashboard admin (view reports) yang berisi total bboking, booking karaoke, rental ps, dan daftar booking.
class _ReportPageState extends State<ReportPage> {
  int _selectedIndex = 1; 
  DateTime _currentDate = DateTime.now();//tanggal dibawah yang bisa diubah" sesuai kebutuhan admin untuk melihat laporan. dan diambil dari API

  bool _isLoading = true;
  int totalBooking = 0;
  int bookingKaraoke = 0;
  int rentalPS = 0;
  List<Map<String, dynamic>> daftarBooking = []; 

//mengambil fungsi initstate untuk memanggil fungsi tarik data report saat halaman pertama kali dibuka. 
//Fungsi ini akan mengambil data dari API dan memperbarui state dengan informasi total booking, booking karaoke, rental PS, dan daftar booking, serta mengubah status loading menjadi false setelah data berhasil diambil atau jika terjadi kesalahan.
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _tarikDataReport(); 
  }

  Future<void> _tarikDataReport() async {
    setState(() => _isLoading = true);
  //memformat tanggal saat ini menjadi format yang sesuai untuk API, yaitu "yyyy-MM-dd". Format ini digunakan untuk mengirimkan tanggal yang dipilih oleh admin ke API agar dapat mengambil laporan yang sesuai dengan tanggal tersebut.  
    String tglSql = DateFormat('yyyy-MM-dd').format(_currentDate);
    
    try {
      final result = await ApiService.fetchReports(tglSql);
      if (result['status'] == 'success') {
        setState(() {
          totalBooking = result['total'] ?? 0;
          bookingKaraoke = result['karaoke'] ?? 0;
          rentalPS = result['ps'] ?? 0;
          
          if (result['data'] != null) {
            daftarBooking = List<Map<String, dynamic>>.from(result['data']);
          } else {
            daftarBooking = [];
          }
          
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

//untuk membangun tampilan halaman laporan admin yang menampilkan informasi total booking, booking karaoke, rental PS, dan daftar booking 
//berdasarkan tanggal yang dipilih. Halaman ini juga menyediakan navigasi untuk berpindah ke halaman dashboard dan profil admin melalui bottom navigation bar.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double uniformPadding = size.width * 0.05;
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_currentDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      
      // =======================================================================
      // ── INI APP BAR RESMI NYA BOSKUU! SAMA KAYA ADMIN HOME ──
      // =======================================================================

      //untuk menampilkan app bar yang memeiliki bg sesuai tema aplikasi, dengan logo aplikasi dan nama apliaksi disebelah kiri.
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, 
        toolbarHeight: 90, 
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)),
                      Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
                    ],
                  ),
                ],
              ),
              // Ngga ada lonceng karena ini Admin
            ],
          ),
        ),
      ),

      //untuk menampilkan konten utama halaman laporan admin yang terdiri dari judul halaman, selector tanggal, summary cards untuk total booking, booking karaoke, dan rental PS, serta daftar booking berdasarkan tanggal yang dipilih. 
      //Konten ini dibungkus dalam SingleChildScrollView agar dapat di-scroll jika kontennya melebihi tinggi layar.
      body: SafeArea(
        child: Column(
          children: [
            // ── SISA HALAMAN DIBUNGKUS EXPANDED BIAR BISA DI-SCROLL ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: uniformPadding, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // JUDUL HALAMAN 
                    // bagian untuk menampilkan judul halaman yang terdiri dari teks "admin dashboard" dan "view reports"
                    Center(
                      child: Column(
                        children: [
                          Text('Admin Dashboard', style: AppStyles.h2White.copyWith(fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('View Reports', style: AppStyles.bodyGrey.copyWith(fontSize: 16)),
                        ],
                      ),
                    ),
                    // jarak vertikal antara judul halaman dan selector tanggal untuk memberikan ruang visual yang cukup dan membuat tampilan lebih rapi.
                    const SizedBox(height: 24),
                    
                    // DATE SELECTOR
                    // bagian untuk menampilkan selector tanggal yang memungkinkan admin untuk memilih tanggal yang ingin dilihat laporannya. 
                    //Selector ini terdiri dari tombol navigasi kiri dan kanan untuk mengubah tanggal, serta tampilan tanggal yang dipilih di tengah. 
                    //Ketika tombol navigasi ditekan, tanggal akan berubah sesuai dengan arah yang dipilih (kiri untuk tanggal sebelumnya, kanan untuk tanggal berikutnya) dan laporan akan diperbarui berdasarkan tanggal yang dipilih.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateNavButton(Icons.chevron_left, () {
                          setState(() {
                            _currentDate = _currentDate.subtract(const Duration(days: 1));
                          });
                          _tarikDataReport(); 
                        }),
                        Expanded(
                          child: Container( // bagian untuk mengatur tampilan tanggal (margin, padding, dekoration)
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.buttonBrown,
                              border: Border.all(color: AppColors.primary, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // bagian untuk menampilkan tanggal yang dipilih dengan format yang sesuai misal "Kamis, 12 Oktober 2023"
                            alignment: Alignment.center,
                            child: Text(formattedDate, style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        // bagian untuk menampilkan tombol navigasi kanan dengan ikon panah kanan. 
                        // Ketika tombol ini ditekan, tanggal akan berubah ke tanggal berikutnya dan laporan akan diperbarui sesuai dengan tanggal yang dipilih.
                        _buildDateNavButton(Icons.chevron_right, () {
                          setState(() {
                            _currentDate = _currentDate.add(const Duration(days: 1));
                          });
                          _tarikDataReport(); 
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // SUMMARY CARDS
                    // bagian untuk menampilkan kartu ringkasan yang memberikan informasi tentang total booking, booking karaoke, dan rental PS berdasarkan tanggal yang dipilih. 
                    // dan jika data masih dalam proses pemuatan, akan ditampilkan indikator loading.
                    _isLoading 
                        ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primary)))
                        : Column(
                            children: [
                              _buildSummaryCard(title: 'Total Booking Hari ini', value: totalBooking.toString(), icon: Icons.badge, isLarge: true, isFullWidth: true),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildSummaryCard(title: 'Booking Karaoke', value: bookingKaraoke.toString())),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildSummaryCard(title: 'Rental PS', value: rentalPS.toString(), icon: Icons.sports_esports)),
                                ],
                              ),
                            ],
                          ),
                    
                    const SizedBox(height: 32),

                    // DAFTAR BOOKING SECTION
                    // bagian untuk menampilkan daftar booking berdasarkan tanggal yang dipilih.
                    // bagian ini terdiri dari judul "Daftar Booking" dan daftar booking yang ditampilkan dalam bentuk kartu laporan.
                    Center(child: Text('Daftar Booking', style: AppStyles.h2White)),
                    const SizedBox(height: 16),
                    // jika data "daftar booking" masih dalam proses pemuatan, maka akan ditampilkan indikator loading.
                    if (_isLoading)
                       const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    else if (daftarBooking.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 50),
                              const SizedBox(height: 12),
                              Text("Belum ada data booking di tanggal ini", style: AppStyles.bodyGrey),
                            ],
                          ),
                        ),
                      )
                      // jika data "daftar booking" sudah berhasil dimuat dan tidak kosong, maka akan ditampilkan daftar booking dalam bentuk kartu laporan yang menampilkan informasi tentang setiap booking, termasuk nama lengkap pengguna, nama tampil, fisik ruangan, waktu booking, dan status booking.
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: daftarBooking.length,
                        itemBuilder: (context, index) {
                          return _buildReportCard(daftarBooking[index]);
                        }, 
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      //untuk menampilkan bottom navigation bar yang memungkinkan admin untuk berpindah antara halaman dashboard, laporan, dan profil dengan mudah. Navigation bar ini memiliki ikon yang sesuai untuk setiap halaman dan menyoroti halaman yang sedang aktif.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminProfileScreen()));
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

  //ini untuk membangun tampilan kartu laporan yang menampilkan informasi tentang setiap booking, termasuk nama lengkap pengguna, nama tampil, fisik ruangan, waktu booking, dan status booking. 
  //Kartu ini dibuat dengan warna latar belakang yang sesuai dengan status booking (misalnya hijau untuk booking yang sedang berlangsung atau dikonfirmasi, merah untuk booking yang dibatalkan atau ditolak) dan menampilkan ikon yang relevan.
  Widget _buildReportCard(Map<String, dynamic> data) {
    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai WIB";
    String status = data['status'].toString().toUpperCase();
    
    // Menentukan warna berdasarkan status booking
    Color statusColor = (status == "BERLANGSUNG" || status == "DIKONFIRMASI") ? const Color(0xFF34C759) : AppColors.primary;
    if (status == "BATAL" || status == "DITOLAK") statusColor = AppColors.danger;

    // Membangun tampilan kartu laporan dengan informasi booking dan status yang sesuai.
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.receipt_long_rounded, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ // Menampilkan nama lengkap pengguna, nama tampil, fisik ruangan, dan waktu booking dengan gaya teks yang sesuai. (di daftar booking view reports)
                Text(data['nama_lengkap'] ?? 'User', style: AppStyles.labelBold.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text('${data['nama_tampil']} - ${data['fisik_ruangan'].toString().replaceAll('Kursi ', '')}', style: AppStyles.bodyGrey.copyWith(fontSize: 12)),
                const SizedBox(height: 2),
                Text(waktu, style: AppStyles.bodyGrey.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Container( // Menampilkan status booking dengan warna latar belakang yang sesuai dan teks yang menonjol untuk menunjukkan status booking dengan jelas. (di daftar booking view reports) 
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: statusColor), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  //ini untuk membangun tombol navigasi tanggal yang digunakan untuk mengubah tanggal yang ditampilkan dalam laporan (ikon panah kiri atau kanan) dan ketika ditekan, 
  // akan memanggil fungsi yang sesuai untuk mengubah tanggal dan memperbarui laporan berdasarkan tanggal yang dipilih.
  Widget _buildDateNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.cardDark, border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }

  //untuk menampilkan kartu ringkasan yang digunakan untuk menampilkan informasi penting seperti total booking, booking karaoke, dan rental PS. Kartu ini memiliki desain yang menarik dengan latar belakang gradien, border, dan ikon yang relevan untuk memberikan tampilan yang informatif dan estetis. Kartu ini juga dapat disesuaikan ukurannya (besar atau kecil) dan lebar penuh sesuai kebutuhan tampilan.
  Widget _buildSummaryCard({required String title, required String value, IconData? icon, bool isLarge = false, bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cardDark, AppColors.cardLight.withOpacity(0.2)]),
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row( // Mengatur tata letak konten dalam kartu dengan jarak antara teks dan ikon, serta memastikan teks tetap terbaca dengan baik. (di summary card view reports)
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Menampilkan judul dan nilai dalam kartu dengan gaya teks yang sesuai, serta memastikan teks tetap terbaca dengan baik meskipun ada ikon di sebelahnya. (di summary card view reports) 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: AppStyles.labelBold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, 
                ),
                // Memberikan jarak vertikal antara judul dan nilai untuk meningkatkan keterbacaan dan estetika tampilan kartu. (di summary card view reports)
                const SizedBox(height: 8),
                Text(value, style: AppStyles.h1Gold.copyWith(fontSize: isLarge ? 32 : 28)),
              ],
            ),
          ),
          // Menampilkan ikon yang relevan di sebelah kanan kartu untuk memberikan konteks visual tentang informasi yang ditampilkan, serta memastikan ikon tidak mengganggu keterbacaan teks. (di summary card view reports)
          if (icon != null) ...[
            const SizedBox(width: 8), 
            Icon(icon, color: AppColors.primary.withOpacity(0.5), size: isLarge ? 48 : 36)
          ]
        ],
      ),
    );
  }
}