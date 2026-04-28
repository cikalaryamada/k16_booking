import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../core/constants/app_colors.dart'; 
import '../../../../core/constants/app_styles.dart'; 
import '../../../../core/network/api_service.dart'; 
import '../home_page_admin.dart'; 
import '../../../profile/screens/profil_admin.dart'; 

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _selectedIndex = 1; // ── Karena ini halaman report, indexnya 1 ──
  DateTime _currentDate = DateTime.now();

  bool _isLoading = true;
  int totalBooking = 0;
  int bookingKaraoke = 0;
  int rentalPS = 0;
  List<Map<String, dynamic>> daftarBooking = []; 

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _tarikDataReport(); 
  }

  Future<void> _tarikDataReport() async {
    setState(() => _isLoading = true);
    
    String tglSql = DateFormat('yyyy-MM-dd').format(_currentDate);
    
    try {
      final result = await ApiService.fetchReports(tglSql);
      if (result['status'] == 'success') {
        setState(() {
          totalBooking = result['total'] ?? 0;
          bookingKaraoke = result['karaoke'] ?? 0;
          rentalPS = result['ps'] ?? 0;
          
          if (result['data'] != null) {
            daftarBooking = List<Map<String, dynamic>>.from(result['data']);
          } else {
            daftarBooking = [];
          }
          
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double uniformPadding = size.width * 0.05;
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_currentDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── 1. HEADER DI LUAR SCROLL BIAR DIAM DI ATAS (STICKY) ──
            Padding(
              padding: EdgeInsets.fromLTRB(uniformPadding, uniformPadding, uniformPadding, 10),
              child: _buildCommonHeader(),
            ),
            
            // ── 2. SISA HALAMAN DIBUNGKUS EXPANDED BIAR BISA DI-SCROLL ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: uniformPadding, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // JUDUL HALAMAN
                    Center(
                      child: Column(
                        children: [
                          Text('Admin Dashboard', style: AppStyles.h2White.copyWith(fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('View Reports', style: AppStyles.bodyGrey.copyWith(fontSize: 16)),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // DATE SELECTOR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateNavButton(Icons.chevron_left, () {
                          setState(() {
                            _currentDate = _currentDate.subtract(const Duration(days: 1));
                          });
                          _tarikDataReport(); 
                        }),
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
                            child: Text(formattedDate, style: AppStyles.bodyWhite.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        _buildDateNavButton(Icons.chevron_right, () {
                          setState(() {
                            _currentDate = _currentDate.add(const Duration(days: 1));
                          });
                          _tarikDataReport(); 
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // SUMMARY CARDS
                    _isLoading 
                        ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primary)))
                        : Column(
                            children: [
                              _buildSummaryCard(title: 'Total Booking Hari ini', value: totalBooking.toString(), icon: Icons.badge, isLarge: true, isFullWidth: true),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildSummaryCard(title: 'Booking Karaoke', value: bookingKaraoke.toString())),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildSummaryCard(title: 'Rental PS', value: rentalPS.toString(), icon: Icons.sports_esports)),
                                ],
                              ),
                            ],
                          ),
                    
                    const SizedBox(height: 32),

                    // DAFTAR BOOKING SECTION
                    Center(child: Text('Daftar Booking', style: AppStyles.h2White)),
                    const SizedBox(height: 16),
                    
                    if (_isLoading)
                       const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    else if (daftarBooking.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 50),
                              const SizedBox(height: 12),
                              Text("Belum ada data booking di tanggal ini", style: AppStyles.bodyGrey),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: daftarBooking.length,
                        itemBuilder: (context, index) {
                          return _buildReportCard(daftarBooking[index]);
                        }, 
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // ── BOTTOM NAVIGATION KHUSUS ADMIN ──
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textWhite,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminProfileScreen()));
          }
        },
        showSelectedLabels: false, showUnselectedLabels: false, type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ""),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> data) {
    String jamMulai = (data['jam_mulai'] ?? '').toString().split(':').take(2).join('.');
    String jamSelesai = (data['jam_selesai'] ?? '').toString().split(':').take(2).join('.');
    String waktu = "$jamMulai - $jamSelesai WIB";
    String status = data['status'].toString().toUpperCase();
    
    Color statusColor = (status == "BERLANGSUNG" || status == "DIKONFIRMASI") ? const Color(0xFF34C759) : AppColors.primary;
    if (status == "BATAL" || status == "DITOLAK") statusColor = AppColors.danger;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.receipt_long_rounded, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['nama_lengkap'] ?? 'User', style: AppStyles.labelBold.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text('${data['nama_tampil']} - ${data['fisik_ruangan'].toString().replaceAll('Kursi ', '')}', style: AppStyles.bodyGrey.copyWith(fontSize: 12)),
                const SizedBox(height: 2),
                Text(waktu, style: AppStyles.bodyGrey.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: statusColor), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── HEADER ADMIN SERASI (TANPA LONCENG) ──
  Widget _buildCommonHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/logo_ksixteen.jpeg')),
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
      ],
    );
  }

  Widget _buildDateNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.cardDark, border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, IconData? icon, bool isLarge = false, bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cardDark, AppColors.cardLight.withOpacity(0.2)]),
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.labelBold),
              const SizedBox(height: 8),
              Text(value, style: AppStyles.h1Gold.copyWith(fontSize: isLarge ? 32 : 28)),
            ],
          ),
          if (icon != null) Icon(icon, color: AppColors.primary.withOpacity(0.5), size: isLarge ? 48 : 36),
        ],
      ),
    );
  }
}