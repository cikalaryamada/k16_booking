import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // === VARIABEL REALTIME TANGGAL ===
  DateTime _currentDate = DateTime.now();

  // === VARIABEL DATA (Diisi Data Dummy Dahulu) ===
  int totalBooking = 5;
  int bookingKaraoke = 2;
  int rentalPS = 3;
  
  List<Map<String, dynamic>> daftarBooking = [
    {
      "id": "#00001",
      "waktu": "16.00 - 17.00",
      "ruangan": "PS4 VIP Kursi 1",
      "status": "Selesai",
      "nama": "Alfin Ngakngik",
      "is_checked": true
    },
    {
      "id": "#00002",
      "waktu": "17.00 - 18.00",
      "ruangan": "Luxury Room 1",
      "status": "Telat",
      "nama": "Akfa Jamsut",
      "is_checked": false
    },
    {
      "id": "#00003",
      "waktu": "16.00 - 19.00",
      "ruangan": "VIP Room Karaoke",
      "status": "Selesai",
      "nama": "Arya Epep",
      "is_checked": true
    },
    {
      "id": "#00004",
      "waktu": "20.00 - 21.00",
      "ruangan": "PS4 VIP Kursi 3",
      "status": "Menunggu",
      "nama": "Aji Dewa Langit",
      "is_checked": false
    },
    {
      "id": "#00005",
      "waktu": "21.00 - 22.00",
      "ruangan": "PS3 VIP Kursi 1",
      "status": "Telat",
      "nama": "Wahyu Kolosebo",
      "is_checked": false
    },
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    
    // _fetchDataFromDatabase(); // Nanti aktifkan ini jika database sudah siap
  }

  /* // ===========================================================
  // CONTOH FUNGSI SAMBUNGAN DATABASE (API / FIREBASE)
  // ===========================================================
  
  Future<void> _fetchDataFromDatabase() async {
    try {
      // 1. Panggil API atau Firestore
      // var response = await myDatabaseService.getBookingByDate(_currentDate);
      
      // 2. Map data dari DB ke variabel state
      setState(() {
        // totalBooking = response.total;
        // bookingKaraoke = response.karaokeCount;
        // rentalPS = response.psCount;
        // daftarBooking = response.listItems; // Pastikan format list map sesuai
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  
  // Fungsi update status (Misal ketika checkbox diklik)
  Future<void> _updateBookingStatus(String id, bool status) async {
    // await myDatabaseService.updateStatus(id, status);
    // _fetchDataFromDatabase(); // Refresh data
  }
  */

  void _changeDate(int days) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: days));
      // _fetchDataFromDatabase(); // Refresh data setiap ganti tanggal
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_currentDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admin Dashboard', style: AppStyles.h2White),
                      Text('View Reports', style: AppStyles.bodyGrey),
                    ],
                  ),
                ],
              ),
            ),

            // --- DATE SELECTOR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateNavButton(Icons.chevron_left, () => _changeDate(-1)),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.buttonBrown,
                        border: Border.all(color: AppColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        formattedDate,
                        style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  _buildDateNavButton(Icons.chevron_right, () => _changeDate(1)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SUMMARY CARDS ---
                    _buildSummaryCard(
                      title: 'Total Booking Hari ini',
                      value: totalBooking.toString(),
                      icon: Icons.badge,
                      isLarge: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Booking Karaoke',
                            value: bookingKaraoke.toString(),
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Rental PS',
                            value: rentalPS.toString(),
                            icon: Icons.sports_esports,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- DIVIDER ---
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('Daftar Booking', style: AppStyles.h2White),
                        ),
                        const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- LIST ---
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daftarBooking.length,
                      itemBuilder: (context, index) {
                        return _buildBookingItem(daftarBooking[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // === WIDGET HELPERS (Tetap Sama) ===

  Widget _buildDateNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          border: Border.all(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, IconData? icon, bool isLarge = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cardDark, AppColors.cardLight.withOpacity(0.2)],
        ),
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.labelBold),
              const SizedBox(height: 8),
              Text(value, style: AppStyles.h1Gold.copyWith(fontSize: isLarge ? 32 : 28)),
            ],
          ),
          if (icon != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(icon, color: AppColors.primary.withOpacity(0.5), size: isLarge ? 48 : 36),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(Map<String, dynamic> data) {
    Color statusColor;
    if (data['status'] == 'Selesai') statusColor = Colors.green;
    else if (data['status'] == 'Telat') statusColor = Colors.red;
    else statusColor = Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(data['id'], style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Icon(
                data['is_checked'] ? Icons.check_box : Icons.check_box_outline_blank,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['waktu'], style: AppStyles.bodyWhite),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(data['ruangan'].contains('PS') ? Icons.sports_esports : Icons.mic, color: AppColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(data['ruangan'], style: AppStyles.bodyWhite.copyWith(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor),
                ),
                child: Text(data['status'], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(data['nama'], style: AppStyles.bodyGrey.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: AppColors.cardDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.home, color: Colors.white),
          const Icon(Icons.access_time_filled, color: AppColors.primary),
          const Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}