import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; // Wajib ada buat font Poppins lu
import 'package:intl/date_symbol_data_local.dart';
import 'features/home/screens/tampilan_awal.dart'; 
import 'features/profile/screens/profil_admin.dart';
import 'features/profile/screens/profil_customer.dart';
import 'features/home/screens/home_page_cust.dart';
import 'features/auth/screens/login.dart';
import 'features/home/screens/ps/playstation_booking.dart';
import 'features/home/screens/home_page_admin.dart';

// Gabungan import dari kamu dan temanmu
import 'features/home/screens/admin/reports_page.dart';
import 'features/home/screens/karaoke/home_karaoke.dart';
import 'features/home/screens/manage_booking_page.dart';

void main() async {
  // Pastikan binding sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi data bahasa sebelum aplikasi dijalankan
  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp()); 
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K-16 Lounge App',
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
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFF000000), 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFCC00)), 
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(), 
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const AdminDashboard(), 
    );
  }
}