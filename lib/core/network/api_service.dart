import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti dengan IP laptop atau 10.0.2.2 (jika pakai emulator)
  // Pastikan nama folder belakangnya sesuai sama folder XAMPP lu (k16_api atau k16_booking)
  static const String baseUrl = "http://localhost/k16_api";

  // ==========================================================
  // 1. FUNGSI REGISTER
  // ==========================================================
  static Future<Map<String, dynamic>> registerUser(String nama, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        body: {
          'nama_lengkap': nama,
          'username': username,
          'password': password, 
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); 
      } else {
        return {'status': 'error', 'message': 'Gagal terhubung ke server (Error ${response.statusCode})'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Periksa koneksi internet Anda. Detail: $e'};
    }
  }

  // ==========================================================
  // 2. FUNGSI KATALOG (Tarik harga PS / Karaoke)
  // ==========================================================
  static Future<List<dynamic>> fetchKatalog(String jenis) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_katalog.php?jenis=$jenis'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 'success') {
          return responseData['data']; 
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal terhubung ke XAMPP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==========================================================
  // 3. FUNGSI PROFIL (INI DIA OBAT PENYAKIT MERAHNYA!)
  // ==========================================================
  static Future<Map<String, dynamic>> fetchProfile(String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_profil.php?username=$username'));

      if (response.statusCode == 200) {
        return json.decode(response.body); 
      } else {
        return {'status': 'error', 'message': 'Gagal terhubung ke server'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Periksa koneksi internet Anda. Detail: $e'};
    }
  }

  // ==========================================================
  // 4. FUNGSI NARIK NOTIFIKASI BOOKING
  // ==========================================================
  static Future<List<dynamic>> fetchNotifikasi(String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_notifikasi.php?username=$username'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 'success') {
          return responseData['data']; 
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal terhubung ke XAMPP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==========================================================
  // 5. FUNGSI NARIK DAFTAR KURSI FISIK
  // ==========================================================
  static Future<List<dynamic>> fetchKursi(String namaPs) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_kursi.php?nama_ps=$namaPs'));

      if (response.statusCode == 200) {
        return json.decode(response.body); 
      } else {
        throw Exception('Gagal terhubung ke server');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==========================================================
  // 6. FUNGSI CEK JADWAL KOSONG
  // ==========================================================
  static Future<List<String>> fetchJadwal(String idUnit, String tanggal) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_jadwal.php?id_unit=$idUnit&tanggal=$tanggal'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return List<String>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ==========================================================
  // 7. FUNGSI SIMPAN BOOKING BARU
  // ==========================================================
  static Future<Map<String, dynamic>> buatBooking(String username, String idTarif, String idUnit, String tanggal, String jamMulai, String jamSelesai, double totalHarga) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/insert_booking.php'),
        body: {
          'username': username,
          'id_tarif': idTarif,
          'id_unit': idUnit,
          'tanggal': tanggal,
          'jam_mulai': jamMulai,
          'jam_selesai': jamSelesai,
          'total_harga': totalHarga.toString(),
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Gagal terhubung ke server'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // ==========================================================
  // 8. FUNGSI UPDATE PROFIL CUSTOMER
  // ==========================================================
  static Future<Map<String, dynamic>> updateProfile(String oldUsername, String nama, String newUsername, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_profil.php'),
        body: {
          'old_username': oldUsername,
          'nama_lengkap': nama,
          'new_username': newUsername,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Gagal terhubung ke server'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error koneksi: $e'};
    }
  }
}