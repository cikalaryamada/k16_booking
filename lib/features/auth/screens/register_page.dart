import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import 'login.dart'; 
import '../../home/screens/home_page_cust.dart';
import '../../../core/network/api_service.dart'; // <--- Tambahkan baris ini

class HalamanRegistrasi extends StatefulWidget {
  const HalamanRegistrasi({Key? key}) : super(key: key);

  @override
  State<HalamanRegistrasi> createState() => _HalamanRegistrasiState();
}

class _HalamanRegistrasiState extends State<HalamanRegistrasi> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // <--- Tambahkan baris ini

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text("!", style: AppStyles.h3Gold.copyWith(color: AppColors.background)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(title, style: AppStyles.h1Gold)),
                  ],
                ),
                const SizedBox(height: 15),
                Text(message, style: AppStyles.bodyWhite),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity, height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OKE", style: AppStyles.buttonTextGold.copyWith(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _validateRegistration() async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // --- Validasi Lokal ---
    if (name.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog("Form Tidak Lengkap", "Semua kolom wajib diisi. Pastikan tidak ada yang terlewat.");
      return;
    }
    if (username.contains(' ')) {
      _showErrorDialog("Username Tidak Valid", "Username tidak boleh menggunakan spasi.");
      return;
    }
    if (password.length < 8) {
      _showErrorDialog("Password Terlalu Pendek", "Password yang anda masukkan kurang dari 8 karakter.");
      return;
    }
    if (password != confirmPassword) {
      _showErrorDialog("Password Tidak Sesuai", "Password dan konfirmasi password yang anda masukkan tidak sesuai.");
      return;
    }

    // --- Mengirim ke Server (Database) ---
    setState(() { _isLoading = true; }); // Munculkan efek loading

    final result = await ApiService.registerUser(name, username, password);

    setState(() { _isLoading = false; }); // Matikan efek loading

    // --- Cek Hasil dari Server ---
    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi Berhasil! Selamat datang di K-16.")),
      );

      // Terbang ke HomePage jika berhasil masuk database
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      // Tampilkan pesan error dari PHP (misal: "Username sudah terdaftar!")
      _showErrorDialog("Registrasi Gagal", result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leadingWidth: 10,
        leading: const SizedBox(),
        title: Row(
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
                Text("Lounge App", style: AppStyles.h3Gold.copyWith(height: 1.1)),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HalamanLogin()),
                      );
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2.0),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 16),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text("Daftar dan Main Sekarang!", style: AppStyles.h2White.copyWith(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              
              // Container Form Register
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppColors.primaryDark, width: 1.5),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Lengkap", style: AppStyles.labelBold),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Budi Santoso',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text("Username", style: AppStyles.labelBold),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Ketik username kamu',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text("Password", style: AppStyles.labelBold),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Minimal 8 karakter',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text("Konfirmasi Password", style: AppStyles.labelBold),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Ketik ulang password',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Button Register
                    Center(
                      child: SizedBox(
                        width: 200, height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBrown,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          // Jika sedang loading, matikan klik
                          onPressed: _isLoading ? null : () => _validateRegistration(),
                          // Jika sedang loading, tampilkan putaran (CircularProgress), jika tidak tampilkan teks
                          child: _isLoading 
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Text("Register Now!", style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}