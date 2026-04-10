import 'package:flutter/material.dart'; //import material dari flutter (tombol, teks, warna, dll)
import 'package:google_fonts/google_fonts.dart'; //import font yang tersedia dari google
import 'login.dart'; // import biar kesambung sama halaman login

void main() { //fungsi yang ngejalanin aplikasinya (tombol power gitulah)
  runApp(const AplikasiRentalPS()); //perintah buat ngerun/jalanin aplikasinya (si AplikasiRentalPS)
}

class AplikasiRentalPS extends StatelessWidget { //statelessWidget(tampilannya ngga bakal berubah-ubah) dipakai karena ngga ada perubahan data
  const AplikasiRentalPS({Key? key}) : super(key: key); //mastiin state widget ngga hilang pas rebuild

  @override //buat keamanan aplikasi (jadi seumpama salah nulis method, bakal nampilin error dan bukan dianggep sebagai method baru)
  Widget build(BuildContext context) { //petunjuk lokasi posisinya si widget di dalam struktur pohon aplikasi ini
    return MaterialApp( //bungkus isi utama aplikasi
      debugShowCheckedModeBanner: false, //buat ngilangin tulisan "Debug" di pojok atas, makanya dibuat false
      theme: ThemeData( //tema nya si halaman
        textTheme: GoogleFonts.poppinsTextTheme(), //pakai font Poppins
        appBarTheme: AppBarTheme( //app bar/header? di bagian atasnya
          backgroundColor: const Color(0xFF000000), //bg warna hitam
          centerTitle: false, //biar ngga ditengah layar
          titleTextStyle: GoogleFonts.poppins( //style nya poppins
            color: const Color(0xFFF2C94C), //teks nya warna kuning
            fontWeight: FontWeight.bold, //teks dimodif tebal
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: const HalamanRegistrasi(), //buat nentuin halaman apa yang bakal dibuka pertama kali
    );
  }
}

class HalamanRegistrasi extends StatefulWidget { //dibuat statefull karena tampilannya bisa berubah-ubah (ngetik teks, tombol, dll ya gitu)
  const HalamanRegistrasi({Key? key}) : super(key: key); ////mastiin state widget ngga hilang pas rebuild

  @override //buat keamanan aplikasi (jadi seumpama salah nulis method, bakal nampilin error dan bukan dianggep sebagai method baru)
  State<HalamanRegistrasi> createState() => _HalamanRegistrasiState(); //buat ngehubungin si widget StatefulWidget, aitu si HalamanRegistrasi sama objek Statenya(datan, dari kosong ada isinya) yaitu si _HalamanRegistrasi
}

class _HalamanRegistrasiState extends State<HalamanRegistrasi> { //tempat buat nyimpan semua logika di halaman registrasi ini
  final _nameController = TextEditingController(); //gunanya buat ngerekam inputan nama
  final _usernameController = TextEditingController(); //gunanya buat ngerekam inputan username
  final _passwordController = TextEditingController(); //gunanya buat ngerekam inputan password
  final _confirmPasswordController = TextEditingController(); //gunanya buat ngerekam inputan konfirmasi password

  // State untuk melihat/menyembunyikan password
  bool _isPasswordVisible = false; //sakelarnya biar password ngga keliatan pas diinput, makanya kita buat off
  bool _isConfirmPasswordVisible = false; //ini juga buat konfirmasi password

  @override //buat keamanan aplikasi (jadi seumpama salah nulis method, bakal nampilin error dan bukan dianggep sebagai method baru)
  void dispose() { //kalau user udah selesai daftar atau pindah halaman nih, yang diisi2 sebelumnya tadi bakal dihapus(nama, username, dsb) biar ngga lemot hp nya dan nyegah memory leak
    _nameController.dispose(); //ngapus data dari controller nama
    _usernameController.dispose(); //ngapus data dari controller username
    _passwordController.dispose(); //ngapus data dari controller password
    _confirmPasswordController.dispose(); //ngapus data dari controller konfirmasi password
    super.dispose(); //buat ngasih tahu state kalau udah dihapus data data sebelumnya, buat nyegah error juga (dispose harus ada super.dispose())
  }

  void _showErrorDialog(String title, String message) { //buat munculin pop up kalau user bikin salah
    showDialog( //isi dari jendela pop-up nya itu
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black, //warna bgnya
          shape: RoundedRectangleBorder( //bentuknya kotak
            borderRadius: BorderRadius.circular(15), //dikasih border radius biar sudutnya aga melengkung
            side: const BorderSide( //buat netapin bordernya
              color: Color(0xFFF2C94C), //warnanya
              width: 1.5, //ketebalan garisnya
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0), //buat ngasih jarak sama rata di semua sisi sebesar 20
            child: Column(
              mainAxisSize: MainAxisSize.min, //ngambil seluruh tinggi layar yang tersedia
              crossAxisAlignment: CrossAxisAlignment.start, //maksa semua isi buat rata kiri
              children: [
                Row( //vertikal
                  children: [
                    Container( //ini wadahnya
                      width: 28, //lebar 28
                      height: 28,//tinggi 28
                      decoration: const BoxDecoration( //buat ngasih gaya di widget Container
                        color: Colors.red, //warna merah
                        shape: BoxShape.circle, //bentuk lingkaran
                      ),
                      alignment: Alignment.center, //rata tengah
                      child: const Text( //buat teksnya
                        "!",
                        style: TextStyle( //style teksnya
                          color: Colors.black, //warna hitam
                          fontSize: 20, //ukuran 20
                          fontWeight: FontWeight.bold, //tebel
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), //buat ngasih jarak kosong secara horizontal antar widget
                    Expanded( //biar ngisi semua sisa ruang yang tersedia
                      child: Text( //teksnya
                        title, //judulnya
                        style: const TextStyle( //style teksnya
                          color: Color(0xFFF2C94C), //warna emas
                          fontSize: 20, //ukuran 20
                          fontWeight: FontWeight.bold, //tebel
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), //ngasih jarak kosong secara vertikal
                Text( //isi teks pesannya
                  message,
                  style: const TextStyle( //style teksnya
                    color: Colors.white, //warna putih
                    fontSize: 15, //ukuran 15
                    height: 1.4, //tinggi 1,4
                  ),
                ),
                const SizedBox(height: 25), //ngasih jarak kosong secara vertikal
                SizedBox(
                  width: double.infinity, //maksa buat selebar mungkin ngikutin ruang yang tersedia secara horizontal
                  height: 45, //tingginya 45
                  child: ElevatedButton( //buat tombol
                    style: ElevatedButton.styleFrom( //buat ngubah stylenya
                      backgroundColor: const Color(0xFF1E1400), //bg hitam
                      shape: RoundedRectangleBorder( //bentuknya kotak
                        borderRadius: BorderRadius.circular(10), //diborder radius biar aga melengkung
                      ),
                      side: const BorderSide( //buat ngasih border
                        color: Color(0xFFF2C94C), //warna emas
                        width: 1.5, //lebar border
                      ),
                    ),
                    onPressed: () { //fungsi ketika tombol diklik
                      Navigator.of(context).pop(); //buat nutup pop-up nya
                    },
                    child: const Text( //teksnya
                      "OKE", //isinya
                      style: TextStyle( //style teksnya
                        fontSize: 18, //ukuran 18
                        fontWeight: FontWeight.bold, //tebel
                        color: Color(0xFFF2C94C), //warna emas
                      ),
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

  void _validateRegistration() { //wadah ngecek data, pake void karena buat ngecek
    String name = _nameController.text.trim(); //trim buat ngebersihin spasi kosong di awal dan di akhir ketikan
    String username = _usernameController.text.trim(); //trim buat ngebersihin spasi kosong di awal dan di akhir ketikan
    String password = _passwordController.text; //ngambil text dari controller password
    String confirmPassword = _confirmPasswordController.text; //ngambil text dari controller confirm password

    if (name.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) { //kalau isinya kosong
      _showErrorDialog( //tampilin popup errornya
        "Form Tidak Lengkap",
        "Semua kolom wajib diisi. Pastikan tidak ada yang terlewat.",
      );
      return; //buat ngestop biar datanya yang kosong tuh ngga kekirim
    }

    if (username.contains(' ')) { //kalau username ada spasinya
      _showErrorDialog( //tampilin popup errornya
        "Username Tidak Valid",
        "Username tidak boleh menggunakan spasi.",
      );
      return; //buat ngestop biar datanya yang salah tuh ngga kekirim
    }

    if (password.length < 8) { //kalau panjang paswordnya kurang dari 8
      _showErrorDialog( //tampilin popup errornya
        "Password Terlalu Pendek",
        "Password yang anda masukkan kurang dari 8 karakter.",
      );
      return; //buat ngetop biar datanya yang salah tuh ngga kekirim
    }

    if (password != confirmPassword) { //kalau password dan konfirmasi password tidak cocok
      _showErrorDialog( //tampilin popup errornya
        "Password Tidak Sesuai",
        "Password dan konfirmasi password yang anda masukkan tidak sesuai.",
      );
      return; //buat ngestop biar datanya yang salah tuh ngga kekirim
    }

    print("Validasi sukses! Lanjut ke proses pendaftaran."); //tampilin pesan validasi sukses
  }

  @override //buat keamanan aplikasi (jadi seumpama salah nulis method, bakal nampilin error dan bukan dianggep sebagai method baru)
  Widget build(BuildContext context) { //bangun widget di context
    return Scaffold( //kembaliin kerangka/kanvas kosong putihnya biar terlihat secara visual di hp
      appBar: AppBar( //bar diatas (ibarat papan nama toko)
        leadingWidth: 10, //ngatur lebar ruang horizontal
        leading: const SizedBox(), //ngapus tombol back otomatis
        title: Row( //baris untuk menampilkan logo dan nama aplikasi, disusun secara horizontal
          children: [
            const CircleAvatar( //bentuk lingkaran
              radius: 25,
              backgroundImage: AssetImage('assets/logo.jpg'), //gambar logonya
            ),
            const SizedBox(width: 12), //lebar 12
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, //biar rata atas
              children: const [
                Text( //isi teksnya
                  "K-16", //buat tulisan K-16
                  style: TextStyle( //gaya teksnya
                    fontSize: 20, //ukuran 20
                    fontWeight: FontWeight.bold, //tebel
                    color: Color(0xFFF2C94C), //emas
                    height: 1.1, // tinggi 1.1
                  ),
                ),
                Text( //isi teksnya
                  "Lounge App", //buat tulisan Lounge App
                  style: TextStyle( //gaya teksnya
                    fontSize: 18, //ukuran 18
                    fontWeight: FontWeight.bold, //tebel
                    color: Color(0xFFF2C94C), //emas
                    height: 1.1, //tinggi 1.1
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF000000), //bg hitam
      body: SingleChildScrollView( //biar ngga error pas keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(20.0), //jarak semua sisi
          child: Column(
            children: [
              Row( //ngatur secara horizontal bagian daftar dan main sekarang dan kembali ke halaman login
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement( //buat buka kembali ke halaman login
                        context,
                        MaterialPageRoute( //ngasih tahu rutenya
                          builder: (context) => const HalamanLogin(), 
                        ),
                      );
                    },
                    // ===================================
                    borderRadius: BorderRadius.circular(50), //bagian pengaturan bordernya di ikon panah
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF2C94C),
                          width: 2.0,
                        ),
                      ),
                      child: const Icon( //ikon  kembali ke halaman login
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
              const SizedBox(height: 25), //aturan buat isi dari halaman registrasinya
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all( //border nya
                    color: const Color(0xFFF1BC19), 
                    width: 1.5,
                  ),
                  gradient: const LinearGradient( //warna gradasi dari isinya
                    colors: [
                      Color(0xFF1E1909),
                      Color(0xFF8F700F),
                    ],
                    begin: Alignment.topCenter, //titik awal gradasi, dimulai dari atas tengah
                    end: Alignment.bottomCenter, //titik akhir gradasi, dimulai dari akhir tengah
                  ),
                  boxShadow: [ //efek glow si border nya
                    BoxShadow(
                      color: const Color(0xFFF2C94C).withOpacity(0.2),
                      blurRadius: 15, //di blur dan di spread/ratakan
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column( //aturan formnya
                  crossAxisAlignment: CrossAxisAlignment.start, //tatanannya rata kiri
                  children: [ //buat form nama lengkap
                    const Text( 
                      "Nama Lengkap",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField( //aturan teks field/ kalau di html namanya placeholder
                      controller: _nameController, 
                      decoration: InputDecoration(
                        hintText: 'Contoh: Budi Santoso', //ini isinya
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text( //buat form username
                      "Username",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField( //aturan teks field
                      controller: _usernameController, 
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
                      controller: _passwordController, 
                      obscureText: !_isPasswordVisible, // Fitur mata (hide/show)
                      decoration: InputDecoration(
                        hintText: 'Minimal 8 karakter',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon( // Icon untuk menampilkan/menyembunyikan password
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey, //ikon mata kita kasih warna abu
                          ),
                          onPressed: () { //aturan pas dikliknya
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
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
                      controller: _confirmPasswordController, 
                      obscureText: !_isConfirmPasswordVisible, // Fitur mata (hide/show)
                      decoration: InputDecoration(
                        hintText: 'Ketik ulang password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                            _validateRegistration();
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