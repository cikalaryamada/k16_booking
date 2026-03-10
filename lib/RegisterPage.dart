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
      home: const HalamanRegistrasi(), 
    );
  }
}

class HalamanRegistrasi extends StatelessWidget {
  const HalamanRegistrasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10, 
        leading: const SizedBox(), 
        
        title: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/logo.jpg'),
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
      
      backgroundColor: const Color(0xFF000000), 
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          
          child: Column(
            children: [
              
              Row(
                children: [
                  InkWell(
                    onTap: () {
                    },
                    borderRadius: BorderRadius.circular(50), 
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        border: Border.all(
                          color: const Color(0xFFF2C94C), 
                          width: 2.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back, 
                        color: Color(0xFFF2C94C), 
                        size: 16,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 15), 
                  
                  const Expanded( 
                    child: Text(
                      "Daftar dan Main Sekarang!",
                      style: TextStyle(
                        fontSize: 16, 
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 25), 
              
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
                    
                    const Text(
                      "Nama Lengkap", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8), 
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Contoh: Budi Santoso', 
                        hintStyle: const TextStyle(color: Colors.grey), 
                        filled: true,
                        fillColor: Colors.white, 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), 
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    const Text(
                      "Username", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Ketik username kamu', 
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    const Text(
                      "Password", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true, 
                      decoration: InputDecoration(
                        hintText: 'Minimal 8 karakter', 
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    const Text(
                      "Konfirmasi Password", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Ketik ulang password', 
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
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
                            print("Tombol ditekan!");
                          },
                          child: const Text(
                            "Register Now!",
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white, 
                            ),
                          ),
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