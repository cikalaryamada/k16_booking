import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart'; 

import '../../profile/screens/profil_customer.dart';
import 'ps/playstation_booking.dart';
import 'Notifikasipage.dart';
import 'BookingHistoryPage.dart'; 
import '../screens/karaoke/karaoke_room_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  List<dynamic> _recentBookings = [];
  bool _isLoadingBooking = true;

  @override
  void initState() {
    super.initState();
    _tarikBookingTerbaru();
  }

  Future<void> _tarikBookingTerbaru() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';

    if (usernameAktif.isNotEmpty) {
      try {
        final data = await ApiService.fetchNotifikasi(usernameAktif);
        List<dynamic> aktif = data.where((b) {
          String status = b['status'].toString().toUpperCase();
          return status == 'MENUNGGU' || status == 'BERLANGSUNG' || status == 'DIKONFIRMASI';
        }).toList();

        setState(() {
          _recentBookings = aktif.take(2).toList(); 
          _isLoadingBooking = false;
        });
      } catch (e) {
        setState(() => _isLoadingBooking = false);
      }
    } else {
      setState(() => _isLoadingBooking = false);
    }
  }

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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
            
            // =================================================================
            // ── KONTEN BAWAH (BISA DI-SCROLL KARENA ADA EXPANDED) ──
            // =================================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("Welcome K16!", style: AppStyles.h2White.copyWith(fontSize: 28)),
                    const SizedBox(height: 5),
                    Text("Apakah siap main hari ini?", style: AppStyles.bodyWhite.copyWith(fontSize: 16)),
                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: _buildServiceCard(
                            title: "Rental PS", subtitle: "PS3, PS4, PS5", icon: Icons.sports_esports_rounded, colorTheme: AppColors.primary,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RentalPlaystationScreen())),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: _buildServiceCard(
                            title: "Karaoke", subtitle: "Luxury, Luxury+, Premiere", icon: Icons.mic_rounded, colorTheme: const Color(0xFFE88A34), 
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const KaraokeRoomScreen()));
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Booking Terbaru", style: AppStyles.h2White),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingHistoryPage())),
                          child: Text("Lihat Semua", style: AppStyles.bodyWhite.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),

                    _isLoadingBooking
                        ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: AppColors.primary)))
                        : _recentBookings.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.history_rounded, color: AppColors.textMuted, size: 50),
                                      const SizedBox(height: 10),
                                      Text("Belum ada booking aktif saat ini", style: AppStyles.bodyGrey),
                                    ],
                                  ),
                                ),
                              )
                            : Column(children: _recentBookings.map((booking) => _buildBookingCard(booking)).toList()),
                  ],
                ),
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
          setState(() => _selectedIndex = index);
          if (index == 1) {
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
      ),
    );
  }

  Widget _buildBookingCard(dynamic data) {
    String status = data['status'].toString().toUpperCase();
    String namaTampil = data['nama_tampil'];
    String jadwal = "${data['tanggal']} | ${data['jam_mulai']} - ${data['jam_selesai']} WIB";
    Color statusColor = (status == "BERLANGSUNG" || status == "DIKONFIRMASI") ? const Color(0xFF34C759) : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryDark)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(namaTampil.contains("Room") ? Icons.mic : Icons.sports_esports, color: statusColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namaTampil, style: AppStyles.labelBold.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text(jadwal, style: AppStyles.bodyGrey.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: statusColor), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({required String title, required String subtitle, required IconData icon, required Color colorTheme, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), border: Border.all(color: colorTheme, width: 1.5),
          gradient: LinearGradient(colors: [colorTheme.withOpacity(0.1), colorTheme.withOpacity(0.3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: colorTheme, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.background, size: 28)),
            const SizedBox(height: 25),
            Text(title, style: AppStyles.h2White),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Expanded(
                  child: Text(
                    subtitle, 
                    style: AppStyles.bodyWhite.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, 
                  )
                ), 
                const SizedBox(width: 5), 
                Icon(Icons.arrow_forward_ios_rounded, color: colorTheme, size: 14)
              ]
            ),
          ],
        ),
      ),
    );
  }
}