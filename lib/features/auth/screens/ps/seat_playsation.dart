import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// PASTIKAN PATH IMPORT INI SESUAI DENGAN FOLDER KAMU:
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
// Import file jadwal booking (sesuaikan namanya jika kamu pakai nama file lain)
import 'scedul_booking.dart'; 

class SeatSelectionScreen extends StatelessWidget {
  // Variabel untuk menerima data dari halaman sebelumnya
  final String playstationName; 

  const SeatSelectionScreen({super.key, required this.playstationName});

  // Data dummy kursi 
  final List<Map<String, dynamic>> seats = const [
    {'id': '01', 'status': 'Available'},
    {'id': '02', 'status': 'Already Full'},
    {'id': '03', 'status': 'Available'},
    {'id': '04', 'status': 'Available'},
    {'id': '05', 'status': 'Already Full'},
    {'id': '06', 'status': 'Available'},
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
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  return _buildSeatCard(context, seats[index]);
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
          // Judul akan berubah sesuai nama PS yang diklik sebelumnya
          Text('Kursi $playstationName', style: AppStyles.h2White),
        ],
      ),
    );
  }

  Widget _buildSeatCard(BuildContext context, Map<String, dynamic> item) {
    bool isAvailable = item['status'] == 'Available';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Sofa
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryDark),
            ),
            child: const Icon(
              Icons.weekend,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          // Info Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kursi', style: AppStyles.labelBold),
                Text(
                  'nomor ${item['id']}',
                  style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Bagian Kanan (Status & Tombol)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isAvailable) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF66BB6A)),
                  ),
                  child: Text(
                    'Available',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF66BB6A),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Tombol BOOK
                GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman Jadwal DAN membawa data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScheduleScreen(
                          playstationName: playstationName, 
                          seatId: item['id'],               
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_border, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'BOOK',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Already Full',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ]
            ],
          ),
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