import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Sesuaikan path import jika error
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import 'seat_playstation.dart'; // Import halaman kursi

class RentalPlaystationScreen extends StatelessWidget {
  const RentalPlaystationScreen({super.key});

  // Data disesuaikan dengan harga di SQL k16_booking
  final List<Map<String, dynamic>> playstations = const [
    {'name': 'PS3', 'price': 'Rp 6.000', 'status': 'Available'},
    {'name': 'PS4', 'price': 'Rp 8.000', 'status': 'Available'},
    {'name': 'PS3 VIP', 'price': 'Rp 8.000', 'status': 'Available'},
    {'name': 'PS4 VIP', 'price': 'Rp 10.000', 'status': 'Available'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSubHeader(context),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: playstations.length,
                itemBuilder: (context, index) {
                  return _buildCard(context, playstations[index]);
                },
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.cardLight,
            child: Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('K-16', style: AppStyles.h1Gold),
              Text('Lounge App', style: AppStyles.h3Gold),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_circle_left_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Text('Rental PlayStation', style: AppStyles.h2White),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> item) {
    bool isAvailable = item['status'] == 'Available';

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
                  color: isAvailable ? Colors.transparent : AppColors.danger.withValues(alpha: 0.3), // Menggunakan withValues
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isAvailable ? const Color(0xFF66BB6A) : Colors.transparent),
                ),
                child: Text(
                  item['status'],
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isAvailable ? const Color(0xFF66BB6A) : Colors.white),
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
                  // PERBAIKAN: Harus menuju SeatSelectionScreen, bukan dirinya sendiri
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(
                        namaTampil: item['name'],
                      ),
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

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.background,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: AppColors.textWhite, size: 28),
          Icon(Icons.access_time, color: AppColors.textGrey, size: 28),
          Icon(Icons.person_outline, color: AppColors.textGrey, size: 28),
        ],
      ),
    );
  }
}