import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 
import '../../../../core/network/api_service.dart'; 
import 'booking_schedule_screen.dart'; 

// ── IMPORT HALAMAN LAIN BIAR NAVBAR & LONCENG BERFUNGSI ──
import '../home_page_cust.dart'; 
import '../../../profile/screens/profil_customer.dart'; 
import '../notifikasipage.dart'; 
import '../bookinghistorypage.dart'; // ── WAJIB IMPORT HISTORY DI SINI ──

class SeatSelectionScreen extends StatefulWidget {
  final String namaTampil; 

  const SeatSelectionScreen({super.key, required this.namaTampil});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<dynamic> seats = [];
  bool isLoading = true;
  int _selectedIndex = 0; // Tambahan buat Nav Bar

  @override
  void initState() {
    super.initState();
    fetchDataKursi(); 
  }

  Future<void> fetchDataKursi() async {
    try {
      final data = await ApiService.fetchKursi(widget.namaTampil);
      setState(() {
        seats = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error sambungan: $e'); 
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat kursi: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER SAMA KAYA HOME ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildHeader(context),
            ),
            
            // ── TOMBOL BACK & JUDUL ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSubHeader(context),
            ),
            const SizedBox(height: 20),
            
            // ── LIST KURSI DINAMIS DARI DATABASE ──
            Expanded(
              child: isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : seats.isEmpty 
                      ? Center(child: Text('Tidak ada kursi untuk ${widget.namaTampil}', style: AppStyles.bodyWhite))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: seats.length,
                          itemBuilder: (context, index) {
                            return _buildSeatCard(context, seats[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      
      // ── BOTTOM NAVIGATION BAR KONSISTEN & UDAH DIJAHIT ──
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            // Balik ke Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else if (index == 1) {
            // ── LOMPAT KE HISTORY BOOKING ──
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
            );
          } else if (index == 2) {
            // Pergi ke Profil
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustProfilAccount()),
            );
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ""),
        ],
      ),
    );
  }

  // ── HEADER DENGAN LONCENG NOTIFIKASI ──
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
                Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1)),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotifikasiPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.0),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 16),
          ),
        ),
        const SizedBox(width: 15),
        Text('Pilih Unit ${widget.namaTampil}', style: AppStyles.h2White.copyWith(fontSize: 18)),
      ],
    );
  }

  Widget _buildSeatCard(BuildContext context, dynamic item) {
    bool isAvailable = item['status'] == 'Available';
    int hargaReal = double.tryParse(item['harga'].toString())?.toInt() ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryDark),
            ),
            child: const Icon(Icons.weekend, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['fisik_ruangan'], style: AppStyles.labelBold.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  'Rp. $hargaReal /jam',
                  style: AppStyles.bodyGrey.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isAvailable) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF66BB6A)),
                  ),
                  child: Text('Tersedia', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF66BB6A))),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScheduleScreen(
                          idTarif: item['id_tarif'].toString(),
                          idUnit: item['id_unit'].toString(),
                          namaTampil: widget.namaTampil,
                          fisikRuangan: item['fisik_ruangan'].toString(),
                          hargaPerJam: double.parse(item['harga'].toString()),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Icon(Icons.star_border, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text('PILIH', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Sudah Penuh', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}