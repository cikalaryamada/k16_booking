import 'package:flutter/material.dart';
import 'package:k16_booking/core/constants/app_colors.dart';
import 'package:k16_booking/core/constants/app_styles.dart';
import 'package:k16_booking/features/profile/screens/profil_admin.dart'; 
import 'package:k16_booking/features/home/screens/admin/reports_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  String _formatDate(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardHome(context), 
      const AdminDashboardPage(), 
      const AdminProfileScreen(), 
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDashboardHome(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double uniformPadding = size.width * 0.05; 

    return SingleChildScrollView(
      padding: EdgeInsets.all(uniformPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommonHeader(),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text('Admin Dashboard', style: AppStyles.h1Gold.copyWith(fontSize: 26)),
                const SizedBox(height: 6),
                Text(_formatDate(DateTime.now()), style: AppStyles.bodyGrey),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildDailyIncomeCard(),
          const SizedBox(height: 24),
          _buildTodaySchedule(),
          const SizedBox(height: 24),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildCommonHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage('assets/logo_ksixteen.jpeg'),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('K-16', style: AppStyles.h3Gold.copyWith(fontSize: 18, height: 1.0)),
            Text('Lounge App', style: AppStyles.h3Gold.copyWith(fontSize: 18, height: 1.2)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppStyles.labelBold),
        const SizedBox(height: 12),
        _buildActionButton(Icons.access_time, 'Manage Booking', () {}),
        const SizedBox(height: 10),
        _buildActionButton(Icons.list_alt, 'View Reports', () {
          setState(() => _selectedIndex = 1);
        }),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 14),
            Text(label, style: AppStyles.buttonTextWhite),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.cardLight.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.timer_outlined, 1),
          _buildNavItem(Icons.person_outline, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Icon(icon, color: _selectedIndex == index ? AppColors.primary : AppColors.textMuted, size: 28),
    );
  }

  Widget _buildDailyIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.cardLight, AppColors.cardDark]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: Colors.white, size: 30),
          const SizedBox(width: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Income', style: AppStyles.bodyWhite),
              Text('Rp 0', style: AppStyles.h1Gold.copyWith(fontSize: 30)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today's Schedule", style: AppStyles.labelBold),
            Text('More', style: AppStyles.buttonTextGold),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text('Belum ada jadwal hari ini', style: AppStyles.bodyGrey)),
        ),
      ],
    );
  }
}