import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // Import warna yang udah kita bikin di atas

class AppStyles {
  // ── HEADINGS (Untuk Judul) ──
  static TextStyle h1Gold = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static TextStyle h2White = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle h3Gold = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // ── BODY (Untuk Teks Biasa / Deskripsi / Field) ──
  static TextStyle bodyWhite = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textWhite,
  );

  static TextStyle bodyGrey = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textGrey,
    height: 1.5, // Biar teks panjang agak renggang bacanya
  );

  static TextStyle labelBold = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  // ── BUTTON TEXT (Untuk Teks di dalam Tombol) ──
  static TextStyle buttonTextWhite = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static TextStyle buttonTextGold = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}