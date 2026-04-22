import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  DateTime _currentDate = DateTime.now();

  // Data dikosongkan agar siap diisi dari database
  int totalBooking = 0;
  int bookingKaraoke = 0;
  int rentalPS = 0;
  List<Map<String, dynamic>> daftarBooking = []; 

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double uniformPadding = size.width * 0.05;
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_currentDate);

    return SingleChildScrollView(
      padding: EdgeInsets.all(uniformPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER: Logo & Nama Aplikasi di KIRI ATAS
          _buildCommonHeader(),
          
          const SizedBox(height: 32),

          // 2. JUDUL: Admin Dashboard & View Reports di TENGAH
          Center(
            child: Column(
              children: [
                Text(
                  'Admin Dashboard', 
                  style: AppStyles.h2White.copyWith(fontSize: 26, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 4),
                Text(
                  'View Reports', 
                  style: AppStyles.bodyGrey.copyWith(fontSize: 16)
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 3. DATE SELECTOR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateNavButton(Icons.chevron_left, () {
                setState(() => _currentDate = _currentDate.subtract(const Duration(days: 1)));
              }),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.buttonBrown,
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(formattedDate, style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              _buildDateNavButton(Icons.chevron_right, () {
                setState(() => _currentDate = _currentDate.add(const Duration(days: 1)));
              }),
            ],
          ),
          const SizedBox(height: 24),

          // 4. SUMMARY CARDS
          _buildSummaryCard(
            title: 'Total Booking Hari ini', 
            value: totalBooking.toString(), 
            icon: Icons.badge, 
            isLarge: true, 
            isFullWidth: true
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSummaryCard(title: 'Booking Karaoke', value: bookingKaraoke.toString())),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard(title: 'Rental PS', value: rentalPS.toString(), icon: Icons.sports_esports)),
            ],
          ),
          
          const SizedBox(height: 32),

          // 5. DAFTAR BOOKING SECTION
          Center(child: Text('Daftar Booking', style: AppStyles.h2White)),
          const SizedBox(height: 16),
          
          if (daftarBooking.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 50),
                    const SizedBox(height: 12),
                    Text("Belum ada data booking", style: AppStyles.bodyGrey),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daftarBooking.length,
              itemBuilder: (context, index) => const SizedBox(), 
            ),
        ],
      ),
    );
  }

  // Helper Widget untuk Header Logo (Kiri Atas)
  Widget _buildCommonHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage('assets/logo_ksixteen.jpeg'),
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('K-16', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold, height: 1.0)),
            Text('Lounge App', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardDark, 
          border: Border.all(color: AppColors.primary), 
          borderRadius: BorderRadius.circular(6)
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, IconData? icon, bool isLarge = false, bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cardDark, AppColors.cardLight.withOpacity(0.2)]),
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.labelBold),
              const SizedBox(height: 8),
              Text(value, style: AppStyles.h1Gold.copyWith(fontSize: isLarge ? 32 : 28)),
            ],
          ),
          if (icon != null) Icon(icon, color: AppColors.primary.withOpacity(0.5), size: isLarge ? 48 : 36),
        ],
      ),
    );
  }
}