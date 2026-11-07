// lib/services/saved_recipe_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_exception.dart';

typedef JsonMap = Map<String, dynamic>;

class SavedRecipeService {
  final SupabaseClient _db = Supabase.instance.client;
  static const _table = 'saved_recipes';

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PostgrestException catch (e) {
      throw AppException('Database error: ${e.message}');
    } on SocketException {
      throw const AppException('Tidak ada koneksi internet');
    } catch (e) {
      throw AppException('Terjadi kesalahan: $e');
    }
  }

  Future<List<JsonMap>> fetchAll(String studentId) => _guard(() async {
        final res = await _db
            .from(_table)
            .select()
            .eq('student_id', studentId)
            .order('created_at', ascending: false);
        return (res as List).cast<JsonMap>();
      });

  Future<JsonMap> insert(JsonMap data) => _guard(() async {
        final res = await _db.from(_table).insert(data).select().single();
        return res as JsonMap;
      });

  Future<JsonMap> update(String id, JsonMap data) => _guard(() async {
        final res = await _db.from(_table).update(data).eq('id', id).select().single();
        return res as JsonMap;
      });

  Future<void> delete(String id) =>
      _guard(() => _db.from(_table).delete().eq('id', id));
}