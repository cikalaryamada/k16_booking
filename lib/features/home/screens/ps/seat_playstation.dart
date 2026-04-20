import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 
// PERBAIKAN: Import file jadwal yang benar
import 'booking_schedule_screen.dart'; 

class SeatSelectionScreen extends StatefulWidget {
  final String namaTampil; 

  const SeatSelectionScreen({super.key, required this.namaTampil});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<dynamic> seats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataKursi(); 
  }

  Future<void> fetchDataKursi() async {
    // Ubah URL ke 10.0.2.2 jika ngetes pakai Emulator Android
    final String url = 'http://localhost/k16_api/get_kursi.php?nama_ps=${widget.namaTampil}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          seats = json.decode(response.body);
          isLoading = false;
        });
      } else {
        debugPrint('Gagal mengambil data'); // Mengganti print agar warning hilang
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('Error sambungan: $e'); // Mengganti print agar warning hilang
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSubHeader(context),
            const SizedBox(height: 20),
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
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.cardLight,
            child: Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('K-16', style: AppStyles.h1Gold),
              Text('Lounge App', style: AppStyles.h3Gold),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_circle_left_outlined, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Text('Pilih ${widget.namaTampil}', style: AppStyles.h2White),
        ],
      ),
    );
  }

  Widget _buildSeatCard(BuildContext context, dynamic item) {
    bool isAvailable = item['status'] == 'Available';

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
                Text(
                  'Rp. ${double.parse(item['harga'].toString()).toInt()}/jam',
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
                  child: Text('Available', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF66BB6A))),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // PERBAIKAN: Ini sudah membawa parameter SQL lengkap yang diminta halaman 3
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
                        Text('BOOK', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Already Full', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.background,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: AppColors.textWhite, size: 28),
          Icon(Icons.access_time, color: AppColors.textGrey, size: 28),
          Icon(Icons.person_outline, color: AppColors.textGrey, size: 28),
        ],
      ),
    );
  }
}