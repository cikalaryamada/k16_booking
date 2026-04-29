import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';

import '../../profile/screens/profil_admin.dart'; 
import '../screens/admin/reports_page.dart'; 
import '../screens/admin/manage_booking_page.dart'; 

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  double _dailyIncome = 0;
  List<dynamic> _todaySchedule = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tarikDataDashboard();
  }

  Future<void> _tarikDataDashboard() async {
    try {
      final result = await ApiService.fetchAdminDashboard();
      if (result['status'] == 'success') {
        setState(() {
          _dailyIncome = double.parse(result['income'].toString());
          _todaySchedule = result['jadwal'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // ── KITA BUNGKUS PAKAI COLUMN BIAR HEADER BISA PISAH SAMA SCROLL ──
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================================
            // ── HEADER STICKY (DI LUAR SCROLL) ──
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildCommonHeader(context),
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
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildTodaySchedule(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCommonHeader(BuildContext context) {
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
      ],
    );
  }

  Widget _buildDailyIncomeCard() {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

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
          const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 35),
          const SizedBox(width: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pendapatan Hari Ini', style: AppStyles.bodyWhite),
              _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
                  : Text(formatter.format(_dailyIncome), style: AppStyles.h1Gold.copyWith(fontSize: 26)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppStyles.labelBold),
        const SizedBox(height: 12),
        _buildActionButton(Icons.access_time, 'Manage Booking', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBooking()));
        }),
        const SizedBox(height: 10),
        _buildActionButton(Icons.list_alt, 'View Reports', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
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
        decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryDark)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 14),
            Text(label, style: AppStyles.buttonTextWhite),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Jadwal Hari Ini", style: AppStyles.labelBold),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
              },
              child: Text('More', style: AppStyles.buttonTextGold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        _isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _todaySchedule.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryDark)),
                    child: Center(child: Text('Belum ada jadwal hari ini', style: AppStyles.bodyGrey)),
                  )
                : Column(
                    children: _todaySchedule.map((jadwal) => _buildScheduleCard(jadwal)).toList(),
                  ),
      ],
    );
  }

  Widget _buildScheduleCard(dynamic data) {
    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai WIB";
    String status = data['status'].toString().toUpperCase();
    
    Color statusColor = (status == "BERLANGSUNG" || status == "DIKONFIRMASI") ? const Color(0xFF34C759) : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
            child: Icon(Icons.receipt_long_rounded, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['nama_lengkap'] ?? 'User', style: AppStyles.labelBold.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('${data['nama_tampil']} - ${data['fisik_ruangan'].toString().replaceAll('Kursi ', '')}', style: AppStyles.bodyGrey.copyWith(fontSize: 11)),
                Text(waktu, style: AppStyles.bodyGrey.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: statusColor), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textWhite,
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReportPage()));
        } else if (index == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminProfileScreen()));
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
    );
  }
}