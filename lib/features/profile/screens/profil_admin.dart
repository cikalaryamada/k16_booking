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
  bool _passwordVisible = false;
  final String _nama = 'Budi';
  final String _noHp = '08123456789';
  final String _username = 'Admin1';
  final String _password = '123Admin';

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFFE57373), shape: BoxShape.circle),
                      child: const Icon(Icons.priority_high_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Text('Konfirmasi Logout', style: AppStyles.h1Gold.copyWith(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Apakah Anda yakin ingin keluar?', style: AppStyles.bodyWhite.copyWith(fontSize: 16)),
                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('Tidak', style: AppStyles.buttonTextGold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _handleLogout(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('Ya', style: AppStyles.buttonTextWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout Berhasil!', style: AppStyles.bodyWhite), backgroundColor: Colors.green, duration: const Duration(seconds: 1)),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HalamanLogin()), 
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double uniformPadding = size.width * 0.05;

    return SingleChildScrollView(
      padding: EdgeInsets.all(uniformPadding),
      child: Column(
        children: [
          _buildCommonHeader(),
          const SizedBox(height: 35),
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 3)),
            child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 50),
          ),
          const SizedBox(height: 14),
          Text('Admin Profile', style: AppStyles.h2White),
          const SizedBox(height: 30),
          _buildStaticField('Nama Lengkap', _nama),
          const SizedBox(height: 18),
          _buildStaticField('No.hp', _noHp),
          const SizedBox(height: 18),
          _buildStaticField('Username', _username),
          const SizedBox(height: 18),
          _buildPasswordStaticField(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _showLogoutConfirmation(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
              child: Text('Logout', style: AppStyles.buttonTextWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonHeader() {
    return Row(
      children: [
        const CircleAvatar(radius: 26, backgroundImage: AssetImage('assets/logo_ksixteen.jpeg')),
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

  Widget _buildStaticField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.labelBold),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Text(value, style: AppStyles.bodyWhite.copyWith(color: const Color(0xFF555555))),
        ),
      ],
    );
  }

  Widget _buildPasswordStaticField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: AppStyles.labelBold),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Row(
            children: [
              Expanded(
                child: Text(_passwordVisible ? _password : '•' * 8, 
                style: AppStyles.bodyWhite.copyWith(color: const Color(0xFF555555), fontSize: _passwordVisible ? 14 : 18, letterSpacing: _passwordVisible ? 0 : 2)),
              ),
              IconButton(
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                icon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}