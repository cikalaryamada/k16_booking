import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/network/api_service.dart';
import '../home_page_cust.dart'; 
import '../../../profile/screens/profil_customer.dart'; 
import 'seat_playstation.dart'; 

// ── WAJIB IMPORT HALAMAN NOTIFIKASI & HISTORY ──
import '../notifikasipage.dart'; 
import '../bookinghistorypage.dart'; 

class RentalPlaystationScreen extends StatefulWidget {
  const RentalPlaystationScreen({super.key});

  @override
  State<RentalPlaystationScreen> createState() => _RentalPlaystationScreenState();
}

class _RentalPlaystationScreenState extends State<RentalPlaystationScreen> {
  List<dynamic> playstations = [];
  bool isLoading = true;
  int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    _tarikDataPS();
  }

  Future<void> _tarikDataPS() async {
    try {
      final data = await ApiService.fetchKatalog('ps');
      setState(() {
        playstations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data database: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildHeader(context), // ── CONTEXT DIKIRIM KE HEADER BIAR BISA PINDAH HALAMAN ──
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSubHeader(context),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : playstations.isEmpty
                      ? Center(child: Text("Data PS Kosong", style: AppStyles.bodyWhite))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: playstations.length,
                          itemBuilder: (context, index) {
                            return _buildCard(context, playstations[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      
      // ── BOTTOM NAVIGATION UDAH DIJAHIT KE HISTORY ──
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else if (index == 1) {
            // ── TERBANG KE HISTORY BOOKING ──
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
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

  // ── HEADER SAMA KAYAK HOME (LONCENG UDAH IDUP) ──
  Widget _buildHeader(BuildContext context) {
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
            onPressed: () {
              // ── TERBANG KE HALAMAN NOTIFIKASI ──
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotifikasiPage()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubHeader(BuildContext context) {
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
        Text('Rental PlayStation', style: AppStyles.h2White.copyWith(fontSize: 18)),
      ],
    );
  }

  Widget _buildCard(BuildContext context, dynamic item) {
    int jumlahKursi = int.tryParse(item['jumlah_kursi'].toString()) ?? 0;
    bool isAvailable = jumlahKursi > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryDark),
                ),
                child: const Icon(Icons.sports_esports, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: AppStyles.labelBold),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        text: item['price'],
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                        children: [
                          TextSpan(text: '/jam', style: AppStyles.bodyGrey.copyWith(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isAvailable ? const Color(0xFF66BB6A) : AppColors.error),
                ),
                child: Text(
                  isAvailable ? 'Tersedia $jumlahKursi Kursi' : 'Penuh',
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    fontWeight: FontWeight.w600, 
                    color: isAvailable ? const Color(0xFF66BB6A) : AppColors.error
                  ),
                ),
              ),
            ],
          ),
          
          if (isAvailable) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(namaTampil: item['name']),
                    ),
                  );
                },
                child: Text('BOOK NOW', style: AppStyles.buttonTextWhite),
              ),
            ),
          ]
        ],
      ),
    );
  }
}