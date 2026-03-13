import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        scaffoldBackgroundColor: Colors.black,
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
  // 'customer' or 'admin'
  String _selectedRole = 'customer';
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Logo dan K-16 Lounge App
                Row(
                  children: [
                    // Logo dari assets
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback jika asset belum tersedia
                            return Container(
                              color: const Color(0xFFF2C94C).withOpacity(0.2),
                              child: const Center(
                                child: Text(
                                  "K-16",
                                  style: TextStyle(
                                    color: Color(0xFFF2C94C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "K-16",
                          style: TextStyle(
                            color: Color(0xFFF2C94C),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Lounge App",
                          style: TextStyle(
                            color: Color(0xFFF2C94C),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Hallo juragan!
                const Text(
                  "Hallo juragan!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),

                // Card Login dengan gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFF1BC19),
                      width: 3,
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color(0xFFF1BC19),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Username field
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 74,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Masukkan username anda',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Password field
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 74,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: 'Masukkan password anda',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Radio buttons yang interaktif
                      Row(
                        children: [
                          // Login sebagai customer
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = 'customer';
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: _selectedRole == 'customer'
                                      ? const Center(
                                          child: Icon(
                                            Icons.circle,
                                            color: Color(0xFFF2C94C),
                                            size: 14,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Login sebagai customer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Login sebagai admin
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = 'admin';
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: _selectedRole == 'admin'
                                      ? const Center(
                                          child: Icon(
                                            Icons.circle,
                                            color: Color(0xFFF2C94C),
                                            size: 14,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Login sebagai admin',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Login button
                      Center(
                        child: SizedBox(
                          width: 237,
                          height: 51,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF301F0F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: const BorderSide(
                                color: Color(0xFFF2C94C),
                                width: 2,
                              ),
                            ),
                            onPressed: () {
                              // Aksi login berdasarkan role: _selectedRole
                              debugPrint('Login sebagai: $_selectedRole');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Register button
                      Center(
                        child: SizedBox(
                          width: 237,
                          height: 51,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF301F0F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: const BorderSide(
                                color: Color(0xFFF2C94C),
                                width: 2,
                              ),
                            ),
                            onPressed: () {
                              // Aksi register
                              debugPrint('Navigasi ke halaman register');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '(For new Customer)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}