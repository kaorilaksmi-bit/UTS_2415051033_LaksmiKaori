// lib/core/breakpoints.dart
class Breakpoints {
  static const double compact = 600; // < 600 px  -> HP (Compact)
  static const double wide = 900;    // >= 900 px -> Laptop / Tablet Lebar (Wide)
}

/// Menentukan jumlah kolom grid berdasarkan lebar layar
int gridColumnsFor(double width) {
  if (width < Breakpoints.compact) return 2; // HP: 2 Kolom
  if (width < Breakpoints.wide) return 3;    // Tablet: 3 Kolom
  return 4;                                   // Laptop/Desktop: 4 Kolom
}