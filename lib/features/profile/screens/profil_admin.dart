import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../auth/screens/login.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  int _selectedIndex = 2;
  bool _passwordVisible = false;

  // Data statis profil admin
  final String _nama = 'Budi';
  final String _noHp = '08123456789';
  final String _username = 'Admin1';
  final String _password = '123Admin';

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A), // Tetap gelap agar kontras dengan emas
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.danger, width: 2),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Konfirmasi Logout',
                  style: AppStyles.h2White,
                ),
                const SizedBox(height: 10),
                Text(
                  'Apakah anda yakin untuk logout dari akun ini?',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyGrey,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(
                          'Tidak',
                          style: AppStyles.buttonTextGold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        // Cari bagian tombol "Ya, Selesai" di dalam _showLogoutConfirmation
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
  
                            // Berpindah ke Halaman Login dan hapus semua halaman sebelumnya
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HalamanLogin()),
                            (route) => false,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Sesi Admin Berakhir")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          elevation: 3,
                        ),
                        child: Text(
                          'Ya',
                          style: AppStyles.buttonTextWhite,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),

                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                        border: Border.all(color: AppColors.primary, width: 3),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.primary,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Admin Name
                    Text(
                      'Admin name',
                      style: AppStyles.h2White,
                    ),
                    const SizedBox(height: 24),

                    // Profil Header
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.background,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Profil',
                          style: AppStyles.h3Gold.copyWith(color: AppColors.textWhite),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    _buildStaticField(label: 'Nama Lengkap', value: _nama),
                    const SizedBox(height: 18),
                    _buildStaticField(label: 'No.hp', value: _noHp),
                    const SizedBox(height: 18),
                    _buildStaticField(label: 'Username', value: _username),
                    const SizedBox(height: 18),
                    _buildPasswordStaticField(),
                    const SizedBox(height: 32),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _showLogoutDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary, width: 1.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Logout',
                              style: AppStyles.buttonTextWhite.copyWith(letterSpacing: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.labelBold),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.textWhite,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Text(
            value,
            style: AppStyles.bodyWhite.copyWith(color: const Color(0xFF555555)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStaticField() {
    final String displayPassword =
        _passwordVisible ? _password : '•' * _password.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: AppStyles.labelBold),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: AppColors.textWhite,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayPassword,
                  style: AppStyles.bodyWhite.copyWith(
                    color: const Color(0xFF555555),
                    fontSize: _passwordVisible ? 14 : 18,
                    letterSpacing: _passwordVisible ? 0 : 2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                icon: Icon(
                  _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
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