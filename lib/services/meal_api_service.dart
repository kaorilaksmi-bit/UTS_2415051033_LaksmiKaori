// lib/services/meal_api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/app_exception.dart';

typedef JsonMap = Map<String, dynamic>;

class MealApiService {
  MealApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<JsonMap>> _get(String path, String key) async {
    try {
      final res = await _client
          .get(Uri.parse('$_base/$path'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        throw AppException('Server bermasalah (kode ${res.statusCode})');
      }
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final list = json[key] as List<dynamic>?;
      return list?.cast<JsonMap>() ?? [];
    } on SocketException {
      throw const AppException('Tidak ada koneksi internet');
    } on http.ClientException {
      throw const AppException('Tidak ada koneksi internet');
    } on TimeoutException {
      throw const AppException('Koneksi terlalu lama, coba lagi');
    } on FormatException {
      throw const AppException('Format data dari server tidak valid');
    }
  }

  Future<List<JsonMap>> search(String q) =>
      _get('search.php?s=${Uri.encodeQueryComponent(q)}', 'meals');

  Future<List<JsonMap>> filterByCategory(String c) =>
      _get('filter.php?c=${Uri.encodeQueryComponent(c)}', 'meals');

  Future<List<JsonMap>> lookup(String id) =>
      _get('lookup.php?i=$id', 'meals');

  Future<List<JsonMap>> categories() =>
      _get('categories.php', 'categories');
}