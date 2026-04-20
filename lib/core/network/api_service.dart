import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti dengan domain InfinityFree kalian!
  //static const String baseUrl = "https://ksixteenbooking.kesug.com";
  static const String baseUrl = "http://172.16.115.115/k16_booking";

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
}