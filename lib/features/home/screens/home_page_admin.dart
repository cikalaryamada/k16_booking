import 'package:flutter/material.dart';
import 'package:k16_booking/core/constants/app_colors.dart';
import 'package:k16_booking/core/constants/app_styles.dart';
import 'package:k16_booking/features/profile/screens/profil_admin.dart'; 

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

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // 2. DAFTAR HALAMAN YANG AKAN DITAMPILKAN
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildDashboardHome(), // Halaman Home (index 0)
      const Center(child: Text("Schedule Page", style: TextStyle(color: Colors.white))), // Placeholder (index 1)
      const AdminProfileScreen(), // Halaman Profil dari file sebelah (index 2)
    ];
  }

  String _formatDate(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // 3. UBAH BODY MENJADI DINAMIS
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // 4. BUNGKUS UI DASHBOARD LAMA KE DALAM FUNGSI (Agar rapi)
  Widget _buildDashboardHome() {
    return SingleChildScrollView(
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
    );
  }

  // --- KODE UI DI BAWAH INI TETAP SAMA SEPERTI SEBELUMNYA ---

  Widget _buildHeader() {
    return Column(
      children: [
        Center(child: Text('Admin Dashboard', style: AppStyles.h2White.copyWith(fontSize: 22))),
        const SizedBox(height: 4),
        Center(child: Text(_formatDate(DateTime.now()), style: AppStyles.bodyGrey)),
      ],
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
              Text('Daily Income', style: AppStyles.bodyWhite.copyWith(fontSize: 18)),
              Text('Rp 0', style: AppStyles.h2White.copyWith(fontSize: 30)),
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
            Text("Today's Schedule", style: AppStyles.labelBold.copyWith(fontSize: 16)),
            Text('More', style: AppStyles.buttonTextGold),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12)),
          child: const Center(child: Text('Belum ada jadwal hari ini')),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppStyles.labelBold.copyWith(fontSize: 16)),
        const SizedBox(height: 12),
        _buildActionButton(Icons.access_time, 'Manage Booking'),
        const SizedBox(height: 10),
        _buildActionButton(Icons.list_alt, 'View Reports'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
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
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 28),
    );
  }
}