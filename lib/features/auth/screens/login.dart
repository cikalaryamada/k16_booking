import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import 'register_page.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  bool _passwordVisible = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── FUNGSI POP-UP ERROR ──
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.background, 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(15), 
            side: const BorderSide( 
              color: AppColors.primary, 
              width: 1.5, 
            ),
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
                      width: 28, 
                      height: 28,
                      decoration: const BoxDecoration( 
                        color: AppColors.error, 
                        shape: BoxShape.circle, 
                      ),
                      alignment: Alignment.center, 
                      child: Text( 
                        "!",
                        style: AppStyles.h3Gold.copyWith(color: AppColors.background), 
                      ),
                    ),
                    const SizedBox(width: 12), 
                    Expanded( 
                      child: Text( 
                        title, 
                        style: AppStyles.h1Gold, 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), 
                Text( 
                  message,
                  style: AppStyles.bodyWhite, 
                ),
                const SizedBox(height: 25), 
                SizedBox(
                  width: double.infinity, 
                  height: 45, 
                  child: ElevatedButton( 
                    style: ElevatedButton.styleFrom( 
                      backgroundColor: AppColors.cardDark, 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(10), 
                      ),
                      side: const BorderSide( 
                        color: AppColors.primary, 
                        width: 1.5, 
                      ),
                    ),
                    onPressed: () { 
                      Navigator.of(context).pop(); 
                    },
                    child: Text( 
                      "OKE", 
                      style: AppStyles.buttonTextGold.copyWith(fontSize: 18), 
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

  // ── FUNGSI VALIDASI LOGIN ──
  void _validateLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(
        "Form Tidak Lengkap",
        "Harap isi username dan password Anda terlebih dahulu.",
      );
      return; 
    }

    if (username != "juragan" || password != "12345678") {
      _showErrorDialog(
        "Login Gagal",
        "Username belum terdaftar atau password yang Anda masukkan salah.",
      );
      return;
    }

    debugPrint("Validasi sukses! Lanjut masuk ke aplikasi.");
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text("Hallo juragan!", style: AppStyles.h1Gold.copyWith(color: AppColors.textWhite)),
              const SizedBox(height: 25),

              // Card Login
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
                    Text("Username", style: AppStyles.labelBold),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan username anda',
                        hintStyle: TextStyle(color: AppColors.textGrey),
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
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password anda',
                        hintStyle: TextStyle(color: AppColors.textGrey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Button Login 
                    Center(
                      child: SizedBox(
                        width: 200, 
                        height: 50, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBrown,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          onPressed: () => _validateLogin(),
                          child: Text('Login', style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Button Register
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBrown,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HalamanRegistrasi()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Register', style: AppStyles.buttonTextWhite.copyWith(height: 1.0, fontSize: 18)),
                              Text('(For new Customer)', style: AppStyles.bodyWhite.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ),
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