import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

import '../../../core/constants/app_colors.dart';
import '../../auth/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeText;
  late Animation<double> _scaleLogo;
  late Animation<double> _fadeButton;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _fadeText = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _scaleLogo = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _fadeButton = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          bottom: false, // ── KUNCI 1: MATIIN SAFE AREA BAWAH ──
          child: Column(
            children: [
              // ── Teks SELAMAT DATANG DI K-16 ──
              Expanded(
                flex: 3,
                child: FadeTransition(
                  opacity: _fadeText,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SELAMAT\nDATANG',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textWhite,
                            height: 1.1,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'DI ',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textWhite,
                                  letterSpacing: 2,
                                ),
                              ),
                              TextSpan(
                                text: 'K-16',
                                style: GoogleFonts.poppins(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.splashGold,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Tombol LANJUTKAN ──
                        FadeTransition(
                          opacity: _fadeButton,
                          child: Material(
                            color: Colors.transparent, 
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30), 
                              splashColor: AppColors.splashGold.withOpacity(0.4), 
                              highlightColor: AppColors.splashGold.withOpacity(0.2), 
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HalamanLogin(), 
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.splashGold,
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'LANJUTKAN',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.splashGold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: AppColors.splashGold,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.background,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Logo Gambar ──
              Expanded(
                flex: 4,
                child: ScaleTransition(
                  scale: _scaleLogo,
                  child: Container(
                    color: AppColors.background,
                    alignment: Alignment.bottomCenter, // ── KUNCI 2: RATAKAN KONTENER KE BAWAH ──
                    child: Image.asset(
                      'assets/logo_ksixteen.jpeg',
                      width: double.infinity,
                      fit: BoxFit.cover, // ── KUNCI 3: PAKAI COVER BIAR FULL KIRI KANAN ──
                      alignment: Alignment.bottomCenter, // ── KUNCI 4: GAMBAR FOKUS KE BAWAH ──
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}