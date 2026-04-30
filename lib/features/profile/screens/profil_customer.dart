import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/network/api_service.dart';
import '../../home/screens/bookinghistorypage.dart'; 
import '../../home/screens/home_page_cust.dart';
import '../../home/screens/notifikasipage.dart'; // ── WAJIB DIIMPORT BUAT TOMBOL LONCENG ──
import '../../auth/screens/login.dart';

// ============================================================================
// ── 1. HALAMAN UTAMA: PROFIL CUSTOMER ──
// ============================================================================
class CustProfilAccount extends StatefulWidget {
  const CustProfilAccount({super.key});

  @override
  State<CustProfilAccount> createState() => _CustProfilAccountState();
}

class _CustProfilAccountState extends State<CustProfilAccount> {
  int _selectedIndex = 2; 

  String _namaLengkap = 'Loading...';
  String _username = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tarikDataProfil();
  }

  Future<void> _tarikDataProfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usernameAktif = prefs.getString('username_aktif') ?? '';

    if (usernameAktif.isEmpty) {
      setState(() {
        _namaLengkap = 'Sesi Berakhir';
        _username = 'Sesi Berakhir';
        _isLoading = false;
      });
      return;
    }

    final result = await ApiService.fetchProfile(usernameAktif); 

    if (result['status'] == 'success') {
      setState(() {
        _namaLengkap = result['data']['nama_lengkap'];
        _username = result['data']['username'];
        _isLoading = false;
      });
    } else {
      setState(() { 
        _namaLengkap = 'Gagal memuat data';
        _username = 'Gagal memuat data';
        _isLoading = false; 
      });
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
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: AppColors.danger, width: 2)),
                  child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Konfirmasi Logout', style: AppStyles.h2White),
                const SizedBox(height: 10),
                Text('Apakah anda yakin untuk logout dari akun ini?', textAlign: TextAlign.center, style: AppStyles.bodyGrey),
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
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          if (!context.mounted) return;
                          
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil logout')));
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
      
      // =======================================================================
      // ── INI APP BAR RESMI NYA BOSKUU! UDAH JADI STICKY HEADER JUGA! ──
      // =======================================================================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, 
        toolbarHeight: 90, 
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)),
                      Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage())),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.background, border: Border.all(color: AppColors.primary, width: 3)),
                child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 50),
              ),
              const SizedBox(height: 14),
              Text(_namaLengkap, style: AppStyles.h2White),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.person, color: AppColors.background, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text('Profil', style: AppStyles.h2White),
                ],
              ),
              const SizedBox(height: 22),

              _buildStaticField(label: 'Nama Lengkap', value: _namaLengkap),
              const SizedBox(height: 18),
              _buildStaticField(label: 'Username', value: _username),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final bool? isUpdated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditCustomerProfile()),
                    );
                    
                    if (isUpdated == true) {
                      setState(() { _isLoading = true; });
                      _tarikDataProfil();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit_document, color: AppColors.background, size: 24),
                      const SizedBox(width: 12),
                      Text('Edit Profile', style: AppStyles.buttonTextWhite.copyWith(color: AppColors.background, fontSize: 18)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.primary, width: 1.5), borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.logout_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('Logout', style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BookingHistoryPage()));
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
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Text(value, style: AppStyles.bodyWhite.copyWith(color: const Color(0xFF555555))),
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
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _oldUsername = '';
  bool _isLoading = true;
  bool _isSaving = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _oldUsername = prefs.getString('username_aktif') ?? '';

    if (_oldUsername.isNotEmpty) {
      final result = await ApiService.fetchProfile(_oldUsername);
      if (result['status'] == 'success') {
        setState(() {
          _namaController.text = result['data']['nama_lengkap'];
          _usernameController.text = result['data']['username'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _prosesUpdate() async {
    String nama = _namaController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (nama.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama dan Username tidak boleh kosong!')));
      return;
    }
    if (username.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username tidak boleh mengandung spasi!')));
      return;
    }

    if (password.isNotEmpty || confirmPassword.isNotEmpty) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi password tidak cocok!')));
        return;
      }
      if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password baru minimal 8 karakter!')));
        return;
      }
    }

    setState(() => _isSaving = true);

    final result = await ApiService.updateProfile(_oldUsername, nama, username, password);

    setState(() => _isSaving = false);

    if (result['status'] == 'success') {
      if (_oldUsername != username) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username_aktif', username);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Color(0xFF4CAF50)));
      
      Navigator.pop(context, true); 
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // =======================================================================
      // ── APP BAR BUAT HALAMAN EDIT JUGA! ──
      // =======================================================================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, 
        toolbarHeight: 90, 
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)),
                      Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage())),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.background, border: Border.all(color: AppColors.primary, width: 3)),
                      child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 50),
                    ),
                    const SizedBox(height: 14),

                    Text('Edit Profile', style: AppStyles.h2White),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)),
                            child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Text('Kembali ke Halaman Profil', style: AppStyles.h2White.copyWith(fontSize: 16)),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 22),

                    _buildEditTextField("Nama Lengkap", "Masukkan nama lengkap", controller: _namaController),
                    const SizedBox(height: 18),
                    _buildEditTextField("Username", "Masukkan username anda", controller: _usernameController),
                    const SizedBox(height: 18),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Password Baru (Opsional)", style: AppStyles.h2White.copyWith(fontSize: 15)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Kosongkan jika tidak ingin mengubah sandi",
                            hintStyle: AppStyles.bodyGrey.copyWith(color: Colors.grey),
                            filled: true, fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32), borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Konfirmasi Password Baru", style: AppStyles.h2White.copyWith(fontSize: 15)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Ketik ulang sandi baru",
                            hintStyle: AppStyles.bodyGrey.copyWith(color: Colors.grey),
                            filled: true, fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32), borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                              onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        ),
                        onPressed: _isSaving ? null : () => _prosesUpdate(),
                        child: _isSaving 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Simpan", style: AppStyles.buttonTextWhite.copyWith(fontSize: 18, letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEditTextField(String label, String hint, {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.h2White.copyWith(fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyles.bodyGrey.copyWith(color: Colors.grey),
            filled: true, fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}