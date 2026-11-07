// lib/core/app_exception.dart
class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}