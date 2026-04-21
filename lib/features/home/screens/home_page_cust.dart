import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../profile/screens/profil_customer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. HEADER (Logo & Notifikasi) ──
              Row(
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),

              // ── 2. WELCOME TEXT ──
              Text(
                "Welcome K16!",
                style: AppStyles.h2White.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 5),
              Text(
                "Apakah siap main hari ini?",
                style: AppStyles.bodyWhite.copyWith(fontSize: 16),
              ),
              
              const SizedBox(height: 30),

              // ── 3. CARD KATEGORI LAYANAN ──
              Row(
                children: [
                  Expanded(
                    child: _buildServiceCard(
                      title: "Rental PS",
                      subtitle: "PS3, PS4, PS5",
                      icon: Icons.sports_esports_rounded,
                      colorTheme: AppColors.primary,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildServiceCard(
                      title: "Karaoke",
                      subtitle: "Luxury, Premiere, Exclusive",
                      icon: Icons.mic_rounded,
                      colorTheme: const Color(0xFFE88A34), 
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // ── 4. BOOKING TERBARU HEADER ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking Terbaru", style: AppStyles.h2White),
                  TextButton(
                    onPressed: () {},
                    child: Text("Lihat Semua", style: AppStyles.bodyWhite.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),

              // ── 5. AREA KOSONG (Siap buat Database) ──
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.history_rounded, color: AppColors.textMuted, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        "Belum ada booking aktif saat ini",
                        style: AppStyles.bodyGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // ── 6. BOTTOM NAVIGATION BAR ──
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          
          // Navigasi ke Profil Customer jika tombol profil (index 2) diklik
          if (index == 2) {
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustProfilAccount()),
            );
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

  // Widget Helper: Card Layanan
  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color colorTheme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorTheme, width: 1.5),
          gradient: LinearGradient(
            colors: [
              colorTheme.withOpacity(0.1),
              colorTheme.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorTheme,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.background, size: 28),
            ),
            const SizedBox(height: 25),
            Text(title, style: AppStyles.h2White),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subtitle, style: AppStyles.bodyWhite.copyWith(fontSize: 12)),
                Icon(Icons.arrow_forward_ios_rounded, color: colorTheme, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}