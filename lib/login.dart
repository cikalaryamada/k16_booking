import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'RegisterPage.dart';

void main() {
  runApp(const AplikasiRentalPS());
}

class AplikasiRentalPS extends StatelessWidget {
  const AplikasiRentalPS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF000000),
          centerTitle: false,
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFFF2C94C),
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: const HalamanLogin(),
    );
  }
}

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  // State variables
  String _selectedRole = 'customer'; // 'customer' or 'admin'
  bool _passwordVisible = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      // 1. Menggunakan AppBar yang sama persis dengan Register Page
      appBar: AppBar(
        leadingWidth: 10,
        leading: const SizedBox(),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/logo.jpg'), // Pastikan gambar ada
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "K-16",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2C94C),
                    height: 1.1,
                  ),
                ),
                Text(
                  "Lounge App",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2C94C),
                    height: 1.1,
                  ),
                ),
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

              // Hallo juragan!
              const Text(
                "Hallo juragan!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // 2. Card Login dengan gradient dan border (Sama dengan Register)
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF1BC19),
                    width: 1.5,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E1909),
                      Color(0xFF8F700F),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF2C94C).withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 3. Username Field (Label dan Form disamakan dengan Register)
                    const Text(
                      "Username",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan username anda',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 4. Password Field
                    const Text(
                      "Password",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password anda',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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

                    const SizedBox(height: 20),

                    // Radio buttons (Login sebagai customer/admin)
                    Row(
                      children: [
                        // Radio Customer
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'customer';
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _selectedRole == 'customer'
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: _selectedRole == 'customer'
                                    ? const Color(0xFFF2C94C)
                                    : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Login sebagai customer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Radio Admin
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'admin';
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _selectedRole == 'admin'
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: _selectedRole == 'admin'
                                    ? const Color(0xFFF2C94C)
                                    : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Login sebagai admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // 5. Button Login (Ukuran dan desain disamakan)
                    Center(
                      child: SizedBox(
                        width: 200, // Sama dengan Register (200)
                        height: 50, // Sama dengan Register (50)
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF301F0F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25), // Sama dengan Register (25)
                            ),
                            side: const BorderSide(
                              color: Color(0xFFF2C94C),
                              width: 1.5, // Sama dengan Register (1.5)
                            ),
                          ),
                          onPressed: () {
                            debugPrint('Login sebagai: $_selectedRole');
                            // Tambahkan aksi login di sini
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Sama dengan Register (18)
                              fontWeight: FontWeight.bold, // Sama dengan Register
                            ),
                          ),
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
                            backgroundColor: const Color(0xFF301F0F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFF2C94C),
                              width: 1.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HalamanRegistrasi(),
                              ),
                            );
                            debugPrint('Navigasi ke halaman register ditekan');
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0, // Rapatkan teks
                                ),
                              ),
                              Text(
                                '(For new Customer)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
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