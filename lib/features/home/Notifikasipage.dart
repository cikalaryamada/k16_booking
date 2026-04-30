import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildPageTitle(),
            const SizedBox(height: 16),
            _buildFilterTabs(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildNotificationCard(
                    icon: Icons.access_time_filled,
                    iconColor: const Color(0xFFFFCC00),
                    title: "Menunggu Konfirmasi",
                    message: "Pesanan untuk Luxury Room anda pukul 19.00 - 20.00 WIB sedang dikonfirmasi",
                    cardColor: const Color(0xFF635626),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.cancel,
                    iconColor: const Color(0xFFFF3B30),
                    title: "Booking Ditolak",
                    message: "Pesanan untuk Luxury Room anda pukul 19.00 - 20.00 WIB melewati batas waktu 15 menit dari jadwal",
                    cardColor: const Color(0xFF622926),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.check_circle,
                    iconColor: const Color(0xFF34C759),
                    title: "Booking Dikonfirmasi",
                    message: "Pesanan untuk Luxury Room anda pukul 19.00 - 20.00 WIB Silahkan datang 10 menit sebelum waktu dimulai",
                    cardColor: const Color(0xFF2F6335),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

  Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
  shape: BoxShape.circle,
),
          child: ClipOval(
            child: Image.asset(
              'assets/logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("K-16", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Lounge App", style: TextStyle(color: Color(0xFFFFCC00), fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildPageTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(Icons.arrow_circle_left_outlined, color: Color(0xFFFFCC00), size: 36),
          SizedBox(width: 12),
          Text("Notifikasi", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          _buildChip("Semua", true),
          _buildChip("Ditolak", false),
          _buildChip("Menunggu", false),
          _buildChip("Berhasil", false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFCC00) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCC00)),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.black : const Color(0xFFFFCC00), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNotificationCard({required IconData icon, required Color iconColor, required String title, required String message, required Color cardColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: iconColor, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(message, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavbar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: Color(0xFF111111), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.history, color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}