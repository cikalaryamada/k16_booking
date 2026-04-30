import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/network/api_service.dart';

// ── IMPORT HALAMAN LAIN BIAR NAVBAR & LONCENG BERFUNGSI ──
import '../home_page_cust.dart'; 
import '../../../profile/screens/profil_customer.dart'; 
import '../Notifikasipage.dart'; 
import '../BookingHistoryPage.dart'; 
import '../ps/seat_playstation.dart'; 

class KaraokeRoomScreen extends StatefulWidget {
  const KaraokeRoomScreen({super.key});

  @override
  State<KaraokeRoomScreen> createState() => _KaraokeRoomScreenState();
}

class _KaraokeRoomScreenState extends State<KaraokeRoomScreen> {
  List<dynamic> karaokeRooms = [];
  bool isLoading = true;
  int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    _tarikDataKaraoke();
  }

  Future<void> _tarikDataKaraoke() async {
    try {
      final data = await ApiService.fetchKatalog('karaoke');
      setState(() {
        karaokeRooms = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildHeader(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTitleBar(context),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : karaokeRooms.isEmpty
                      ? Center(child: Text("Data Karaoke Kosong", style: AppStyles.bodyWhite))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: karaokeRooms.length,
                          itemBuilder: (context, index) {
                            return _buildRoomItem(context, karaokeRooms[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── DESAIN KEMBALI KE AWAL (KONSISTEN DENGAN HALAMAN PS) ──
  Widget _buildRoomItem(BuildContext context, dynamic item) {
    bool isPremiere = item['name'].toString().toLowerCase().contains('premiere');
    bool isLuxuryPlus = item['name'].toString().toLowerCase().contains('luxury+');
    
    int jumlahKursi = int.tryParse(item['jumlah_kursi'].toString()) ?? 0;
    bool isAvailable = jumlahKursi > 0;

    String kapasitas = isPremiere ? "Maks. 8 Orang" : isLuxuryPlus ? "Maks. 6 Orang" : "Maks. 4 Orang";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon Mic Box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryDark),
                ),
                child: const Icon(Icons.mic_external_on_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              
              // Detail Teks Utama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: AppStyles.labelBold),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        text: item['price'],
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                        children: [
                          TextSpan(text: '/jam', style: AppStyles.bodyGrey.copyWith(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // LABEL KETERSEDIAAN
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isAvailable ? const Color(0xFF66BB6A) : AppColors.error),
                ),
                child: Text(
                  isAvailable ? 'Tersedia $jumlahKursi Ruang' : 'Penuh',
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    fontWeight: FontWeight.w600, 
                    color: isAvailable ? const Color(0xFF66BB6A) : AppColors.error
                  ),
                ),
              ),
            ],
          ),

          // ── TAGS FASILITAS (DIPOLES DIKIT BIAR RAPI) ──
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMiniTag(kapasitas, Icons.groups_rounded),
              _buildMiniTag("Smart TV", Icons.tv_rounded),
              if (isPremiere || isLuxuryPlus) _buildMiniTag("Neon Light", Icons.lightbulb_outline),
              if (isPremiere) _buildMiniTag("VIP Sound", Icons.speaker_rounded),
            ],
          ),
          
          // ── TOMBOL BOOK NOW FULL WIDTH KAYA DI PS ──
          if (isAvailable) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(namaTampil: item['name']),
                    ),
                  );
                },
                child: Text('BOOK NOW', style: AppStyles.buttonTextWhite),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildMiniTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primaryDark.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textGrey, size: 12),
          const SizedBox(width: 4),
          Text(text, style: AppStyles.bodyGrey.copyWith(fontSize: 10, color: AppColors.textWhite)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/logo_ksixteen.jpeg')),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("K-16", style: AppStyles.h1Gold.copyWith(height: 1.1)), Text("Lounge App", style: AppStyles.h3Gold.copyWith(fontSize: 14, height: 1.1))],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage()))
          ),
        ),
      ],
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2.0)), child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 16))),
        const SizedBox(width: 15),
        Expanded(child: Text('Karaoke Room', style: AppStyles.h2White.copyWith(fontSize: 18), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textWhite,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        if (index == 0) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
        else if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BookingHistoryPage()));
        else if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CustProfilAccount()));
      },
      showSelectedLabels: false, showUnselectedLabels: false, type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ""),
      ],
    );
  }
}