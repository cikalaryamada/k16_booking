import 'package:flutter/material.dart';
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
import 'features/home/screens/admin/manage_booking_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K-16 Lounge App',
      debugShowCheckedModeBanner: false,
      // ── TEMA BUATAN LU YANG HILANG AKU BALIKIN KE SINI ──
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        
        // 1. KUNCI UTAMA BIAR GA KENA FLASHBANG PUTIH
        canvasColor: Colors.black, 
        scaffoldBackgroundColor: const Color(0xFF000000), 
        
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFCC00)), 
        useMaterial3: true,
        
        // 3. ANIMASI TRANSISI PREMIUM (BEBAS PUTIH)
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Pake Zoom / FadeUpwards biar transisinya elegan dan ngga ngegeser kanvas
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(), 
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: const AdminDashboard(), 
    );
  }
}