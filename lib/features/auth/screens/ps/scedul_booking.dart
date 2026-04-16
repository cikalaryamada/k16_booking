import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// PASTIKAN PATH IMPORT INI SESUAI DENGAN FOLDER KAMU:
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class BookingScheduleScreen extends StatefulWidget {
  // Variabel penampung data dari halaman Pilih Kursi
  final String playstationName;
  final String seatId;

  // Constructor wajib diisi
  const BookingScheduleScreen({
    super.key,
    required this.playstationName,
    required this.seatId,
  });

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  // Data dummy tanggal
  final List<Map<String, dynamic>> dates = const [
    {'day': 'Minggu', 'date': '01', 'month': 'Mar', 'isSelected': true},
    {'day': 'Senin', 'date': '02', 'month': 'Mar', 'isSelected': false},
    {'day': 'Selasa', 'date': '03', 'month': 'Mar', 'isSelected': false},
  ];

  // Data dummy jam
  final List<Map<String, dynamic>> times = const [
    {'time': '10:00', 'status': 'available'},
    {'time': '11:00', 'status': 'booked'},
    {'time': '12:00', 'status': 'available'},
    {'time': '13:00', 'status': 'available'},
    {'time': '14:00', 'status': 'available'},
    {'time': '15:00', 'status': 'booked'},
    {'time': '16:00', 'status': 'booked'},
    {'time': '17:00', 'status': 'booked'},
    {'time': '18:00', 'status': 'available'},
    {'time': '19:00', 'status': 'available'},
    {'time': '20:00', 'status': 'selected'},
    {'time': '21:00', 'status': 'available'},
  ];

  // ==========================================
  // FUNGSI POP UP SUKSES DI SINI
  // ==========================================
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFFE8E5D7), // Warna beige
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified, 
                  color: AppColors.primary, 
                  size: 60,
                ),
                const SizedBox(height: 12),
                Text(
                  'BOOKING BERHASIL\nDIPESAN',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonBrown, 
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Terima kasih atas pesanan mu!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.buttonBrown,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.primary, thickness: 1.5),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ringkasan Pemesanan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonBrown,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Memanggil data dinamis menggunakan widget.
                _buildDetailRow('Nomor Pesanan', '000002'),
                _buildDetailRow('Pelanggan', 'Aji Dewa Langit'),
                _buildDetailRow('Room', widget.playstationName), 
                _buildDetailRow('Kursi', widget.seatId),
                _buildDetailRow('Jadwal', '02/03/2026\n20.00 - 21.00 WIB'),
                
                const SizedBox(height: 16),
                Text(
                  'Mohon datang 15 menit sebelum waktu booking\nTunjukkan bukti booking & bayar di lokasi untuk mulai.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.buttonBrown,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Tutup dialog dan kembali ke halaman paling awal
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'TUTUP & KEMBALI KE HALAMAN UTAMA',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primaryDark, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'LIHAT RIWAYAT PESANAN',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
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

  // Widget Bantuan Row untuk Teks Dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, 
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.buttonBrown,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.buttonBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ==========================================

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
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildDateSelector(),
                    const SizedBox(height: 20),
                    Container(
                      height: 3,
                      width: double.infinity,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 20),
                    _buildTimeGrid(),
                    const SizedBox(height: 24),
                    _buildSummaryCard(),
                    const SizedBox(height: 24),
                    _buildCheckoutCard(context), 
                    const SizedBox(height: 20),
                  ],
                ),
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
            child: const Icon(
              Icons.arrow_circle_left_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.playstationName} - Kursi ${widget.seatId}', 
              style: AppStyles.h2White,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date['isSelected'] as bool;

          return Container(
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryDark : AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryDark : AppColors.primaryDark,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date['day'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.textGrey,
                  ),
                ),
                Text(
                  date['date'],
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textWhite,
                  ),
                ),
                Text(
                  date['month'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textWhite,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: times.map((t) {
        final status = t['status'];
        final time = t['time'];

        Color bgColor;
        Color borderColor;

        if (status == 'selected') {
          bgColor = AppColors.primaryDark;
          borderColor = AppColors.primaryDark;
        } else if (status == 'booked') {
          bgColor = AppColors.danger; 
          borderColor = AppColors.danger;
        } else {
          bgColor = AppColors.cardDark;
          borderColor = AppColors.primaryDark;
        }

        return Container(
          width: 75, 
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('1 Jam', style: AppStyles.h2White),
          const SizedBox(width: 20),
          Container(
            height: 30,
            width: 2,
            color: AppColors.primary, 
          ),
          const SizedBox(width: 20),
          Text('20:00 - 21:00', style: AppStyles.h2White),
        ],
      ),
    );
  }

  Widget _buildCheckoutCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: AppStyles.h2White),
              Text('Rp. 10.000', style: AppStyles.h2White),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                // MUNCULKAN POP UP SAAT DIKLIK
                _showSuccessDialog(context);
              },
              child: Text(
                'Konfirmasi',
                style: AppStyles.buttonTextWhite.copyWith(fontSize: 18),
              ),
            ),
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