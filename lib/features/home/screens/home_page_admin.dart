import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AdminDashboard(),
    );
  }
}

// ─── Admin Dashboard ──────────────────────────────────────────────────────────
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> schedules = [];

  String _formatDate(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(),
                    const SizedBox(height: 28),
                    _buildDailyIncomeCard(),
                    const SizedBox(height: 24),
                    _buildTodaySchedule(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        Center(
          child: Text(
            'Admin Dashboard',
            style: AppStyles.h2White.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            _formatDate(DateTime.now()),
            style: AppStyles.bodyGrey.copyWith(height: 1),
          ),
        ),
      ],
    );
  }

  // ─── Daily Income Card ─────────────────────────────────────
  Widget _buildDailyIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardLight, AppColors.cardDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.credit_card, color: Colors.white, size: 30),
              ),
              Positioned(
                bottom: -6,
                right: -8,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.splashGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.attach_money, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(width: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Income', style: AppStyles.bodyWhite.copyWith(fontSize: 18)),
              const SizedBox(height: 6),
              Text(
                'Rp 0',
                style: AppStyles.h2White.copyWith(fontSize: 30, letterSpacing: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Today's Schedule ──────────────────────────────────────
  Widget _buildTodaySchedule() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today's Schedule", style: AppStyles.labelBold.copyWith(fontSize: 16)),
            GestureDetector(
              onTap: () {},
              child: Text('More', style: AppStyles.buttonTextGold.copyWith(fontSize: 14)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (schedules.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cardLight.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 32),
                const SizedBox(height: 10),
                Text('Belum ada jadwal hari ini', style: AppStyles.bodyGrey.copyWith(color: AppColors.textMuted)),
              ],
            ),
          )
        else
          ...schedules.map((s) => _buildScheduleItem(s)).toList(),
      ],
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              s['time'] as String,
              style: AppStyles.bodyGrey.copyWith(fontSize: 13, height: 1),
            ),
          ),
          Container(
            width: 1,
            height: 36,
            color: AppColors.cardLight.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: s['iconBg'] as Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(s['icon'] as IconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['room'] as String, style: AppStyles.labelBold.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text(s['name'] as String, style: AppStyles.bodyGrey.copyWith(fontSize: 12, height: 1)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: s['statusColor'] as Color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              s['status'] as String,
              style: AppStyles.bodyWhite.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Actions ─────────────────────────────────────────
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppStyles.labelBold.copyWith(fontSize: 16)),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.access_time,
          iconBg: const Color(0xFF5B3FA0),
          label: 'Manage Booking',
          showIcon: true,
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          icon: Icons.list_alt,
          iconBg: Colors.transparent,
          iconColor: AppColors.primary,
          label: 'View Reports',
          showIcon: true,
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          icon: null,
          iconBg: Colors.transparent,
          label: 'Daily Income',
          showIcon: false,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData? icon,
    required Color iconBg,
    required String label,
    Color iconColor = Colors.white,
    required bool showIcon,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.cardLight.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (showIcon && icon != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
            ],
            Text(label, style: AppStyles.buttonTextWhite.copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Nav Bar ────────────────────────────────────────
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.cardLight.withOpacity(0.2),
            width: 1,
          ),
        ),
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
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textMuted,
        size: 28,
      ),
    );
  }
}