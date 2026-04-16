import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
// Import halaman home customer & login
import '../../home/screens/home_page_cust.dart';
import '../../auth/screens/login.dart';

// ============================================================================
// ── 1. HALAMAN UTAMA: PROFIL CUSTOMER (DESAIN ADMIN, ISI CUSTOMER) ──
// ============================================================================
class CustProfilAccount extends StatefulWidget {
  const CustProfilAccount({super.key});

  @override
  State<CustProfilAccount> createState() => _CustProfilAccountState();
}

class _CustProfilAccountState extends State<CustProfilAccount> {
  int _selectedIndex = 2; // Default di Profil

  // Data statis profil customer
  final String _namaLengkap = 'Nama admin Ex. Budi';
  final String _username = 'Username Ex. Admin1';

  // ── Dialog Logout ──
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
              color: AppColors.cardDark,
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
                  child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Konfirmasi Logout', style: AppStyles.h2White),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text('Tidak', style: AppStyles.buttonTextGold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Tutup pop-up dialog dulu
                          Navigator.of(context).pop();
                          
                          // 2. Munculin notifikasi sukses
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Berhasil logout')),
                          );
                          
                          // 3. Pindah ke HalamanLogin & HAPUS semua riwayat halaman biar ga bisa di-back
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HalamanLogin()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          elevation: 3,
                        ),
                        child: Text('Ya', style: AppStyles.buttonTextWhite),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Avatar Gede
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 50),
              ),
              const SizedBox(height: 14),

              // Title Name
              Text('Customer name', style: AppStyles.h2White),
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
                    child: const Icon(Icons.person, color: AppColors.background, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text('Profil', style: AppStyles.h2White),
                ],
              ),
              const SizedBox(height: 22),

              // ── Field Murni Punya Customer ──
              _buildStaticField(label: 'Nama Lengkap', value: _namaLengkap),
              const SizedBox(height: 18),
              _buildStaticField(label: 'Username', value: _username),
              const SizedBox(height: 32),

              // ── Tombol Edit Profile ──
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditCustomerProfile()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit_document, color: AppColors.background, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Edit Profile',
                        style: AppStyles.buttonTextWhite.copyWith(color: AppColors.background, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 15),

              // ── Tombol Logout ──
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
                        child: const Icon(Icons.logout_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: AppStyles.buttonTextWhite.copyWith(fontSize: 18),
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

      // ── BOTTOM NAVIGATION BAR ──
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            setState(() => _selectedIndex = index);
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
      ),
    );
  }

  Widget _buildStaticField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.h2White.copyWith(fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
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
}


// ============================================================================
// ── 2. HALAMAN EDIT PROFIL CUSTOMER ──
// ============================================================================
class EditCustomerProfile extends StatefulWidget {
  const EditCustomerProfile({super.key});

  @override
  State<EditCustomerProfile> createState() => _EditCustomerProfileState();
}

class _EditCustomerProfileState extends State<EditCustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              // Avatar Gede
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 50),
              ),
              const SizedBox(height: 14),

              Text('Customer name', style: AppStyles.h2White),
              const SizedBox(height: 24),

              // Tombol Kembali
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text('Kembali ke Halaman Profil', style: AppStyles.h2White.copyWith(fontSize: 16)),
                  ],
                ),
              ),
              
              const SizedBox(height: 22),

              // ── Field Murni Punya Edit Customer ──
              _buildEditTextField("Nama", "Masukkan nama anda"),
              const SizedBox(height: 18),
              _buildEditTextField("Username", "Masukkan username anda"),
              const SizedBox(height: 18),
              _buildEditTextField("Konfirmasi Password", "Masukkan password anda", isPassword: true),
              const SizedBox(height: 18),
              _buildEditTextField("Password", "Masukkan ulang password anda", isPassword: true),
              
              const SizedBox(height: 32),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Hijau
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil berhasil diperbarui!")),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Simpan",
                    style: AppStyles.buttonTextWhite.copyWith(fontSize: 18, letterSpacing: 1.2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Edit Field (Radius 32)
  Widget _buildEditTextField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.h2White.copyWith(fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyles.bodyGrey.copyWith(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}