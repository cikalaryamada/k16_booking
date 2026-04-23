import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class ManageBooking extends StatefulWidget {
  const ManageBooking({super.key});

  @override
  State<ManageBooking> createState() => _ManageBookingState();
}

class _ManageBookingState extends State<ManageBooking> {
  String _selectedFilter = 'Semua (All)';

  // ===========================================================================
  // ── 1. DUMMY DATA (NANTI DIGANTI SAMA DATA DARI DATABASE) ──
  // ===========================================================================
  /*
  // CONTOH KALAU NANTI PAKE FIREBASE:
  // List<BookingModel> listBooking = [];
  // Future<void> fetchBookings() async {
  //   var snapshot = await FirebaseFirestore.instance.collection('bookings').get();
  //   setState(() {
  //     listBooking = snapshot.docs.map((doc) => BookingModel.fromMap(doc.data())).toList();
  //   });
  // }
  */
  final List<Map<String, dynamic>> _dummyBookings = [
    {
      'id': 'BKG-001',
      'customer': "Samuel Ilham Eto'o",
      'room': 'Luxury Room - PS4 Only',
      'slot': '01/03/2026 19.00-20.00',
      'status': 'TELAT',
    },
    {
      'id': 'BKG-002',
      'customer': "Aji Dewa Langit",
      'room': 'PS4 VIP - Kursi 1',
      'slot': '02/03/2026 20.00-21.00',
      'status': 'MENUNGGU',
    },
    {
      'id': 'BKG-003',
      'customer': "Muzza Firdausyi",
      'room': 'PS3 VIP - Kursi 5',
      'slot': '02/03/2026 21.00-22.00',
      'status': 'BERJALAN',
    },
  ];

  // ── FUNGSI UPDATE STATUS KE DATABASE (DUMMY) ──
  void _updateStatusBooking(String idBooking, String statusBaru) {
    /*
    // CONTOH KALAU PAKE REST API (PHP/XAMPP):
    // await http.post(Uri.parse("http://.../update_status.php"), body: {
    //   "id_booking": idBooking,
    //   "status": statusBaru,
    // });
    
    // CONTOH KALAU PAKE FIREBASE:
    // await FirebaseFirestore.instance.collection('bookings').doc(idBooking).update({
    //   'status': statusBaru
    // });
    */
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Aksi dijalankan untuk ID: $idBooking. Status: $statusBaru")),
    );
  }

  // ===========================================================================
  // ── 2. FUNGSI MUNCULIN POP-UP TUTUP SLOT MANUAL ──
  // ===========================================================================
  void _showTutupSlotDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Pake StatefulBuilder biar dropdown & pilihan jam di dalam pop-up bisa diklik & berubah
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            String? roomDipilih;
            String? kursiDipilih;
            String? tanggalDipilih;
            int? jamDipilihIndex;

            List<String> listJam = [
              "10:00 - 11:00",
              "11:00 - 12:00",
              "12:00 - 13:00",
              "13:00 - 14:00",
              "14:00 - 15:00",
            ];

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Abu gelap sesuai desain
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tutup Slot Online Manual", style: AppStyles.h2White),
                    const SizedBox(height: 20),
                    
                    // Baris 1: Pilih Room & Kursi
                    Row(
                      children: [
                        Expanded(child: _buildPopUpDropdown("Pilih Room", ["Reguler", "VIP"])),
                        const SizedBox(width: 10),
                        Expanded(child: _buildPopUpDropdown("Pilih Kursi", ["Kursi 1", "Kursi 2"])),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Baris 2: Label Pilih Jam & Tanggal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pilih Jam", style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 130,
                          child: _buildPopUpDropdown("Pilih Tanggal", ["Hari Ini", "Besok"]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Container List Jam (Bisa di-scroll kalau banyak)
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        itemCount: listJam.length,
                        itemBuilder: (context, index) {
                          bool isSelected = jamDipilihIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() => jamDipilihIndex = index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withOpacity(0.3) : AppColors.cardDark,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade800),
                              ),
                              alignment: Alignment.center,
                              child: Text(listJam[index], style: AppStyles.bodyWhite),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Baris 3: Tombol Batal & Tutup Slot
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Batal", style: AppStyles.buttonTextWhite),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              /*
                              // ── LOGIKA DATABASE SIMPAN BLOKIR SLOT ──
                              // await http.post(Uri.parse("url_api/tutup_slot.php"), body: {
                              //    'room': roomDipilih,
                              //    'tanggal': tanggalDipilih,
                              //    'jam': listJam[jamDipilihIndex],
                              // });
                              */
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Slot berhasil ditutup manual!")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error, // Merah terang
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Tutup slot", style: AppStyles.buttonTextWhite),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper bikin dropdown pop up (Tampilan doang biar UI nya sama)
  Widget _buildPopUpDropdown(String hint, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardLight, // Warna coklat keemasan
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: AppStyles.bodyWhite.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  // ===========================================================================
  // ── 3. TAMPILAN UTAMA ADMIN DASHBOARD ──
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // Tombol Mengambang (Floating Action Button) buat Tutup Slot
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTutupSlotDialog,
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.white24, width: 1),
        ),
        icon: const Icon(Icons.access_alarms_rounded, color: Colors.white),
        label: const Text("Tutup Slot Manual", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ── APP BAR CUSTOM ──
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textWhite),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin Dashboard", style: AppStyles.h2White.copyWith(fontSize: 22)),
                      Text("Manage Booking", style: AppStyles.bodyGrey),
                    ],
                  ),
                ],
              ),
            ),

            // ── FILTER ROW ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterButton("Semua (All)", isSelected: _selectedFilter == 'Semua (All)'),
                  const SizedBox(width: 10),
                  _buildFilterButton("Playstation", icon: Icons.sports_esports, isSelected: _selectedFilter == 'Playstation'),
                  const SizedBox(width: 10),
                  _buildFilterButton("Karaoke", icon: Icons.mic, isSelected: _selectedFilter == 'Karaoke'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── LIST BOOKING CARDS ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: _dummyBookings.length,
                itemBuilder: (context, index) {
                  final booking = _dummyBookings[index];
                  return _buildBookingCard(booking);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Tombol Filter
  Widget _buildFilterButton(String text, {IconData? icon, required bool isSelected}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 5),
            ],
            Text(text, style: AppStyles.bodyWhite.copyWith(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Card Booking (Warna Border & Tombol Otomatis Ganti Sesuai Status)
  Widget _buildBookingCard(Map<String, dynamic> data) {
    Color borderColor;
    Color statusBadgeColor;
    Widget actionButtons;
    Widget statusWarning = const SizedBox(); // Buat nampilin Icon segitiga merah kalo telat

    // PENGKONDISIAN BERDASARKAN STATUS BOOKING
    if (data['status'] == 'TELAT') {
      borderColor = AppColors.error;
      statusBadgeColor = AppColors.danger;
      statusWarning = const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 60),
      );
      actionButtons = SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null, // Tombol Mati (Disabled)
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.grey.shade800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Otomatis Terbatalkan", style: AppStyles.bodyGrey),
        ),
      );
    } 
    else if (data['status'] == 'MENUNGGU') {
      borderColor = AppColors.primary;
      statusBadgeColor = AppColors.primary;
      actionButtons = Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatusBooking(data['id'], 'DITERIMA'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("TERIMA", style: AppStyles.buttonTextWhite),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatusBooking(data['id'], 'DITOLAK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("TOLAK", style: AppStyles.buttonTextWhite),
            ),
          ),
        ],
      );
    } 
    else { // BERJALAN
      borderColor = Colors.green;
      statusBadgeColor = Colors.teal;
      actionButtons = Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("TERIMA", style: AppStyles.bodyGrey),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("TOLAK", style: AppStyles.bodyGrey),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2), // Warna border ngikut status
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Text (Icon + Text)
              _buildInfoRow(Icons.person, "Customer: ", data['customer']),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.videogame_asset, "Room: ", data['room']),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.mic, "Slot: ", data['slot']),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("Status: ", style: AppStyles.bodyWhite.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(
                    data['status'] == 'TELAT' ? "TELAT (maks 15M)" : 
                    data['status'] == 'MENUNGGU' ? "Menunggu Konfirmasi" : "Sedang Berjalan",
                    style: AppStyles.bodyWhite.copyWith(fontSize: 13, color: borderColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Tombol Aksi Bawah
              actionButtons,
            ],
          ),
          
          // Lencana Status (Pojok Kanan Atas)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusBadgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                data['status'] == 'TELAT' ? "Status: TELAT (15M)" :
                data['status'] == 'MENUNGGU' ? "Menunggu Konfirmasi" : "Sedang Berjalan",
                style: AppStyles.bodyWhite.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: data['status'] == 'MENUNGGU' ? Colors.black : Colors.white),
              ),
            ),
          ),

          // Icon Segitiga Merah Kalo Telat
          if (data['status'] == 'TELAT')
            Positioned(right: 15, top: 40, child: statusWarning),
        ],
      ),
    );
  }

  // WIDGET HELPER: Teks Info dengan Icon
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(label, style: AppStyles.bodyWhite.copyWith(fontSize: 13)),
        Text(value, style: AppStyles.bodyWhite.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}