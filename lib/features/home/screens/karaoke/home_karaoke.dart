import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart';

class RoomSelectionScreen extends StatelessWidget {
  const RoomSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- HEADER SECTION (Logo & Title) ---
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/logo_ksixteen.jpeg'), // Ganti dengan path logo kamu
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('K-16', style: AppStyles.h1Gold),
                      Text('Lounge App', style: AppStyles.h1Gold),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- SUB-HEADER (Back Button & Room Name) ---
              Row(
                children: [
                  Icon(Icons.arrow_circle_left_outlined, 
                       color: AppColors.primary, size: 32),
                  const SizedBox(width: 10),
                  Text('Luxury Room 1', style: AppStyles.h2White),
                ],
              ),
              const SizedBox(height: 25),

              // --- LIST ROOM OPTIONS ---
              _buildRoomCard(
                title: 'Netflix + Karaoke',
                price: 'Rp 12.000',
              ),
              const SizedBox(height: 15),
              _buildRoomCard(
                title: 'PS4 Only',
                price: 'Rp 15.000',
              ),
            ],
          ),
        ),
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: AppColors.textWhite),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: AppColors.primary),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: AppColors.textGrey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // --- REUSABLE WIDGET: ROOM CARD ---
  Widget _buildRoomCard({required String title, required String price}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Row(
        children: [
          // Icon Microphone Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            ),
            child: const Icon(Icons.mic_none, color: AppColors.textWhite, size: 30),
          ),
          const SizedBox(width: 15),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.labelBold.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.people_outline, color: AppColors.textWhite, size: 16),
                    const SizedBox(width: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: price, 
                            style: AppStyles.h3Gold.copyWith(fontSize: 14)
                          ),
                          TextSpan(
                            text: '/jam', 
                            style: AppStyles.bodyGrey.copyWith(fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Book Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_border, color: AppColors.textWhite, size: 16),
                const SizedBox(width: 4),
                Text('BOOK', style: AppStyles.buttonTextWhite.copyWith(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}