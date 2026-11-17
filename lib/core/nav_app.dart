import 'package:flutter/foundation.dart';

/// Permintaan pindah menu dari halaman yang dibuka di atas kerangka utama
/// (misalnya dari halaman Sleep Debt ke tab Program).
/// Kerangka HP/web mendengarkan nilai ini lalu berpindah.
class NavApp {
  NavApp._();

  /// Nomor tab HP yang diminta (0 Beranda, 1 Jurnal, 2 Analisis, 3 Program, 4 Profil).
  static final ValueNotifier<int?> tabHp = ValueNotifier<int?>(null);

  /// Nomor menu sidebar web yang diminta.
  static final ValueNotifier<int?> menuWeb = ValueNotifier<int?>(null);
}
