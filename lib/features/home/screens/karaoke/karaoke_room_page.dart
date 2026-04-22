import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import package intl
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/network/api_service.dart';

class KaraokeRoomScreen extends StatefulWidget {
  // PERBAIKAN 1: Menggunakan super.key (use_super_parameters)
  const KaraokeRoomScreen({super.key});

  @override
  State<KaraokeRoomScreen> createState() => _KaraokeRoomScreenState();
}

class _KaraokeRoomScreenState extends State<KaraokeRoomScreen> {
  late Future<List<dynamic>> _katalogFuture;

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi fetchKatalog dari api_service.dart
    _katalogFuture = ApiService.fetchKatalog(jenis),
    }
  /// Fungsi untuk mengubah angka (String/Double) menjadi format Rupiah
  /// Contoh: 30000 -> Rp 30.000
  String formatRupiah(dynamic harga) {
    num nominal = 0;
    if (harga is String) {
      nominal = num.tryParse(harga) ?? 0;
    } else if (harga is num) {
      nominal = harga;
    }

    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(nominal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTitleBar(),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _katalogFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Gagal memuat data', style: AppStyles.bodyWhite),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Ruangan tidak tersedia', style: AppStyles.bodyWhite),
                    );
                  }

                  final dataRuangan = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dataRuangan.length,
                    itemBuilder: (context, index) {
                      final item = dataRuangan[index];
                      return _buildRoomItem(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildRoomItem(Map<String, dynamic> item) {
    // Logika untuk membedakan tampilan Premiere Room vs Luxury Room
    bool isPremiere = item['nama_tampil'].toString().toLowerCase().contains('premiere');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Mic Box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // PERBAIKAN 2: Mengganti withOpacity menjadi withValues
                  color: AppColors.cardLight.withValues(alpha: 0.3), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardLight),
                ),
                child: const Icon(Icons.mic, color: AppColors.primary, size: 30),
              ),
              const SizedBox(width: 15),
              
              // Detail Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['nama_tampil'], style: AppStyles.h2White),
                    if (isPremiere) ...[
                      Row(
                        children: [
                          const Icon(Icons.groups, color: AppColors.textGrey, size: 16),
                          const SizedBox(width: 5),
                          Text('All Include', style: AppStyles.bodyGrey),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 5,
                        children: [
                          _tagMini('Premium Sound'),
                          _tagMini('4 Mic'),
                          _tagMini('Neon Light'),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    // Status Available
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Available', style: AppStyles.labelBold.copyWith(fontSize: 12)),
                    ),
                  ],
                ),
              ),

              // Tombol Book (Untuk Luxury Room posisi di samping)
              if (!isPremiere) _buildBookButton(),
            ],
          ),

          // Baris Harga & Tombol Book khusus Premiere (di bawah)
          if (isPremiere) ...[
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: formatRupiah(item['harga']), // Menggunakan intl
                    style: AppStyles.h3Gold.copyWith(fontSize: 20),
                    children: [
                      TextSpan(
                        text: '/jam',
                        style: AppStyles.bodyGrey,
                      ),
                    ],
                  ),
                ),
                _buildBookButton(),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tagMini(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: AppStyles.bodyGrey.copyWith(fontSize: 10)),
    );
  }

  Widget _buildBookButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_border, color: AppColors.background, size: 18),
          const SizedBox(width: 4),
          Text('BOOK', style: AppStyles.labelBold.copyWith(color: AppColors.background)),
        ],
      ),
    );
  }

  // Header & Title UI (Sesuai Desain)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('K-16', style: AppStyles.h1Gold),
              Text('Lounge App', style: AppStyles.h1Gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_circle_left_outlined, color: AppColors.primary, size: 35),
          const SizedBox(width: 10),
          Text('Karaoke Room', style: AppStyles.h2White.copyWith(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrey,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history, size: 30), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: 'Profile'),
      ],
    );
  } 
}