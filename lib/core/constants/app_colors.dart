import 'package:flutter/material.dart';

class AppColors {
  // ── Warna Utama K-16 ──
  static const Color primary = Color(0xFFF2C94C);     // Kuning Emas utama
  static const Color primaryDark = Color(0xFFF1BC19); // Emas varian (agak pekat)
  static const Color splashGold = Color(0xFFFFCC00);  // Emas khusus Splash Screen
  static const Color background = Color(0xFF000000);  // Hitam pekat background

  // ── Warna Komponen / Card ──
  static const Color cardDark = Color(0xFF1E1909);    // Coklat gelap (buat gradasi)
  static const Color cardLight = Color(0xFF8F700F);   // Coklat terang (buat gradasi)
  static const Color buttonBrown = Color(0xFF301F0F); // Coklat untuk tombol form
  
  // ── Warna Aksi / Status ──
  static const Color danger = Color(0xFF7A0000);      // Merah gelap (Buat tombol Logout)
  static const Color error = Colors.redAccent;        // Merah terang (Buat icon error)

  // ── Warna Teks ──
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.white70;
  static const Color textMuted = Colors.white54;
}