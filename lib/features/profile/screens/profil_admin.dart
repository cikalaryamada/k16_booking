import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Wajib Import
import '../../../core/network/api_service.dart'; // Wajib Import API

import '../../auth/screens/login.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  int _selectedIndex = 2;
  bool _passwordVisible = false;

  static const Color _accentColor = Color(0xFFF5A623);
  static const Color _darkRed = Color(0xFF7A0000);

  // ── VARIABEL DINAMIS DARI DATABASE ──
  String _nama = 'Loading...';
  String _username = 'Loading...';
  bool _isLoading = true;

  // Data statis (Karena di tabel users lu belum ada kolom no_hp)
  final String _noHp = '08123456789'; 
  final String _password = '••••••••'; // Password disembunyikan demi keamanan

  @override
  void initState() {
    super.initState();
    _tarikDataProfilAdmin();
  }

  // ── FUNGSI NARIK DATA ADMIN BERDASARKAN SESSION ──
  Future<void> _tarikDataProfilAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ambil username yang disimpen pas Login tadi
    String? usernameAktif = prefs.getString('username_aktif');

    if (usernameAktif != null && usernameAktif.isNotEmpty) {
      final result = await ApiService.fetchProfile(usernameAktif); 
      
      if (result['status'] == 'success') {
        setState(() {
          _nama = result['data']['nama_lengkap'];
          _username = result['data']['username'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _nama = 'Gagal memuat';
          _username = 'Gagal memuat';
          _isLoading = false;
        });
      }
    }
  }

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
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentColor.withOpacity(0.4), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: _darkRed.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: _darkRed, width: 2),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 32),
                ),
                const SizedBox(height: 16),
                const Text('Konfirmasi Logout', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Apakah anda yakin untuk logout dari akun ini?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _accentColor, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Tidak', style: TextStyle(color: _accentColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // ── HAPUS SESSION DARI HP ──
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil logout'), backgroundColor: _darkRed));
                          
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HalamanLogin()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: _darkRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Ya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: _accentColor))
        : Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, border: Border.all(color: _accentColor, width: 3)),
                      child: const Icon(Icons.person_outline_rounded, color: _accentColor, size: 50),
                    ),
                    const SizedBox(height: 14),
                    Text(_nama, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(color: _accentColor, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.person, color: Colors.black, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Text('Profil Admin', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _buildStaticField(label: 'Nama Lengkap', value: _nama),
                    const SizedBox(height: 18),
                    _buildStaticField(label: 'No.hp', value: _noHp),
                    const SizedBox(height: 18),
                    _buildStaticField(label: 'Username', value: _username),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        onPressed: _showLogoutDialog,
                        style: ElevatedButton.styleFrom(backgroundColor: _darkRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(border: Border.all(color: _accentColor, width: 1.5), borderRadius: BorderRadius.circular(6)),
                              child: const Icon(Icons.logout_rounded, color: _accentColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Nav Palsu (Biar UI Konsisten)
            Container(
              decoration: const BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Colors.white12, width: 0.8))),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home_outlined, color: Colors.white54, size: 28),
                  Icon(Icons.history_toggle_off_outlined, color: Colors.white54, size: 28),
                  Icon(Icons.person, color: _accentColor, size: 28),
                ],
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
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Text(value, style: const TextStyle(color: Color(0xFF555555), fontSize: 14)),
        ),
      ],
    );
  }
}