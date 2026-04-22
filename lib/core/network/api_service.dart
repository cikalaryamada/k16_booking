import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti dengan domain InfinityFree kalian!
  //static const String baseUrl = "https://ksixteenbooking.kesug.com";
 // Ubah ke localhost karena ngetesnya di Web (Chrome)
  static const String baseUrl = "http://localhost/k16_api";

    // Tambahkan fungsi ini di dalam class ApiService
static Future<Map<String, dynamic>> registerUser(String nama, String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {
        'nama_lengkap': nama,
        'username': username,
        'password': password, // Akan masuk ke kolom password_hash
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Mengembalikan JSON dari PHP
    } else {
      return {'status': 'error', 'message': 'Gagal terhubung ke server (Error ${response.statusCode})'};
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Periksa koneksi internet Anda. Detail: $e'};
  }
}
  // Fungsi memanggil get_katalog.php
  static Future<List<dynamic>> fetchKatalog() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_katalog.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 'success') {
          // Akan mengembalikan list yang berisi: nama_tampil, harga, fisik_ruangan, dll
          return responseData['data']; 
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal terhubung ke server InfinityFree');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ── 1. FUNGSI LOGIN ──
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Error Server: ${response.statusCode}'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal terhubung ke database. Pastikan XAMPP menyala.\nDetail: $e'};
    }
  }

  // ── 2. FUNGSI AMBIL DATA KURSI ──
  static Future<List<dynamic>> getKursi(String namaPs) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_kursi.php?nama_ps=$namaPs'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return []; // Kembalikan list kosong jika error server
      }
    } catch (e) {
      return []; // Kembalikan list kosong jika gagal koneksi
    }
  }
}
