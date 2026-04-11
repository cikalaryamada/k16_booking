import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  int _selectedIndex = 2; // Default di Profil

  // Data Dummy Admin
  final String _namaAdmin = "Andi Prasetyo";
  final String _usernameAdmin = "admin_andi";
  final String _roleAdmin = "Super Admin K-16";

  // ── FUNGSI POP-UP LOGOUT ──
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.danger, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.security_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Logout Sesi Admin',
                  textAlign: TextAlign.center,
                  style: AppStyles.h3Gold,
                ),
                const SizedBox(height: 10),
                Text(
                  'Apakah anda yakin untuk mengakhiri \nsesi administrasi K-16 anda?',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyGrey,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: AppStyles.buttonTextGold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Sesi Admin Berakhir")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Ya, Selesai',
                            style: AppStyles.buttonTextWhite.copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
              const SizedBox(height: 10),
              
              // ── 1. KARTU PROFIL HEADER ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  gradient: const LinearGradient(
                    colors: [AppColors.cardDark, AppColors.cardLight],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Bagian Atas
                    Row(
                      children: [
                        // Avatar Admin
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                            color: Colors.white12,
                          ),
                          child: const Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 35),
                        ),
                        const SizedBox(width: 15),
                        // Nama & Username
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _namaAdmin,
                                style: AppStyles.h3Gold,
                              ),
                              Text(
                                "@$_usernameAdmin",
                                style: AppStyles.bodyGrey.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Settings Admin
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings_suggest_rounded, color: AppColors.textGrey, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bagian Bawah (Status Admin)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status Administrasi",
                            style: AppStyles.bodyWhite.copyWith(fontSize: 13),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                _roleAdmin,
                                style: AppStyles.h3Gold.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 35),
              
              // ── 2. DAFTAR MENU PENGATURAN ADMIN ──
              _buildSettingTile(
                icon: Icons.dashboard_customize_outlined,
                title: "Lounge Dashboard Management",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.supervised_user_circle_outlined,
                title: "Customer Database",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.history_edu_rounded,
                title: "Booking Logs & Report",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.admin_panel_settings_outlined,
                title: "Admin Security Settings",
                onTap: () {},
              ),
              
              const Divider(color: Colors.white10, height: 20),
              
              _buildSettingTile(
                icon: Icons.logout_rounded,
                title: "End Admin Session",
                iconColor: AppColors.error,
                onTap: () => _showLogoutConfirmation(context),
              ),
            ],
          ),
        ),
      ),
      // ── 3. BOTTOM NAVIGATION BAR ──
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.manage_history_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ""),
        ],
      ),
    );
  }

  // Widget Builder buat Item Menu Pengaturan
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: AppStyles.bodyWhite,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
    );
  }
}