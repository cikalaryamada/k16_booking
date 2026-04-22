import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

// Sesuaikan letak import folder kamu jika ada yang merah
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import 'register_page.dart';

// Import halaman home customer (Agar setelah login bisa langsung pindah ke sini)
import '../../home/screens/home_page_cust.dart'; 

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key}); // Diperbarui agar lebih rapi (super.key)

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  bool _passwordVisible = false;
  bool _isLoading = false; // Variabel untuk mengatur animasi loading

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

  // ── FUNGSI VALIDASI LOGIN DARI DATABASE ──
  Future<void> _validateLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    // 1. Cek form kosong
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(
        "Form Tidak Lengkap",
        "Harap isi username dan password Anda terlebih dahulu.",
      );
      return; 
    }

    // Menyalakan animasi loading
    setState(() {
      _isLoading = true;
    });

    // URL API Login (Ubah localhost menjadi 10.0.2.2 jika di Emulator Android)
    final String url = 'http://localhost/k16_api/login.php';

    try {
      // 2. Mengirim data POST ke API PHP
      final response = await http.post(
        Uri.parse(url),
        body: {
          'username': username,
          'password': password,
        },
      );

      // 3. Membaca balasan dari Server
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          // LOGIN BERHASIL
          debugPrint("Login sukses: ${data['message']}");
          
          if (!mounted) return;
          // Memunculkan pesan sukses kecil di bawah layar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selamat datang, ${data['data']['nama_lengkap']}!'),
              backgroundColor: const Color(0xFF66BB6A),
            ),
          );

          // PENTING: Arahkan Halaman Berdasarkan Role Database
          int roleId = int.parse(data['data']['role'].toString());
          if (roleId == 1) {
            // TODO: Arahkan ke halaman Admin (nanti jika halaman admin sudah ada)
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HalamanAdmin()));
          } else {
            // ARAHKAN KE HALAMAN CUSTOMER (HomePage)
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }

        } else {
          // LOGIN GAGAL (Password Salah / Username tidak ada)
          if (mounted) _showErrorDialog("Login Gagal", data['message']);
        }
      } else {
        if (mounted) _showErrorDialog("Error Server", "Terjadi kesalahan pada server (Error ${response.statusCode})");
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          "Error Koneksi", 
          "Gagal terhubung ke database. Pastikan XAMPP menyala dan URL benar.\n\nDetail: $e"
        );
      }
    } finally {
      // Mematikan animasi loading setelah proses selesai (berhasil/gagal)
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                      color: AppColors.primary.withValues(alpha: 0.2), // Diperbarui agar tidak warning
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
                        hintStyle: const TextStyle(color: AppColors.textGrey),
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
                        hintStyle: const TextStyle(color: AppColors.textGrey),
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

                    // Button Login (Dengan kondisi Loading)
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
                          onPressed: _isLoading ? null : () => _validateLogin(),
                          child: _isLoading 
                            ? const SizedBox(
                                height: 20, 
                                width: 20, 
                                child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3)
                              )
                            : Text('Login', style: AppStyles.buttonTextWhite.copyWith(fontSize: 18)),
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