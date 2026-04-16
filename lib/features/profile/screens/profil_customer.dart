import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  int _selectedIndex = 2; // Default di Profil

  // Data Dummy Customer
  final String _namaCustomer = "Budi Santoso";
  final String _usernameCustomer = "budi_k16";
  final int _customerPoints = 1250;

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
                // Icon Peringatan Merah
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
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 15),
                // Judul
                Text(
                  'Konfirmasi Logout',
                  textAlign: TextAlign.center,
                  style: AppStyles.h3Gold,
                ),
                const SizedBox(height: 10),
                // Pesan
                Text(
                  'Apakah anda yakin untuk logout \ndari akun K-16 anda?',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyGrey,
                ),
                const SizedBox(height: 25),
                // Tombol Aksi
                Row(
                  children: [
                    // Tombol Batal
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
                    // Tombol Ya
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Berhasil Logout")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Ya, Keluar',
                            style: AppStyles.buttonTextWhite.copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                        // Avatar Bulat
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                            color: Colors.white12,
                          ),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 35),
                        ),
                        const SizedBox(width: 15),
                        // Nama & Username
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _namaCustomer,
                                style: AppStyles.h3Gold,
                              ),
                              Text(
                                "@$_usernameCustomer",
                                style: AppStyles.bodyGrey.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Edit
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_note_rounded, color: AppColors.textGrey, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bagian Bawah (Customer Points)
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
                            "K-16 Customer Points",
                            style: AppStyles.bodyWhite.copyWith(fontSize: 13),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                "$_customerPoints Pts",
                                style: AppStyles.h3Gold.copyWith(fontSize: 16),
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
              
              // ── 2. DAFTAR MENU PENGATURAN ──
              _buildSettingTile(
                icon: Icons.notifications_none_rounded,
                title: "Notification Settings",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.account_circle_outlined,
                title: "Account & Security",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.color_lens_outlined,
                title: "Theme Mode",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.support_agent_rounded,
                title: "Help & Support",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.assignment_outlined,
                title: "Terms & Conditions",
                onTap: () {},
              ),
              
              // Separator tipis
              const Divider(color: Colors.white10, height: 20),
              
              // Tombol Logout (Warna Merah)
              _buildSettingTile(
                icon: Icons.logout_rounded,
                title: "Logout Account",
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline_rounded), label: ""),
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