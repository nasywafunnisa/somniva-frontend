import 'package:flutter/foundation.dart';

class LangkahWindDown {
  final String judul;
  final String ket;
  const LangkahWindDown(this.judul, this.ket);
}

/// Daftar centang Wind-Down Routine malam ini (disimpan selama aplikasi
/// terbuka). Awalnya semua belum dicentang. Data hilang kalau di-refresh.
class StoreWindDown extends ChangeNotifier {
  StoreWindDown._();
  static final StoreWindDown instance = StoreWindDown._();

  static const List<LangkahWindDown> langkah = [
    LangkahWindDown('Matikan layar', '10 menit sebelum berbaring'),
    LangkahWindDown('Redupkan lampu', 'Gunakan cahaya hangat'),
    LangkahWindDown('Minum air hangat tanpa kafein', '5 menit'),
    LangkahWindDown('Latihan napas 4–7–8', '5 menit · panduan tersedia'),
  ];

  final List<bool> _selesai = List<bool>.filled(langkah.length, false);

  bool selesai(int i) => _selesai[i];

  int get jumlah => _selesai.where((e) => e).length;
  int get total => langkah.length;
  int get persen => (jumlah * 100 / total).round();

  /// Menandai satu langkah selesai (tidak membatalkan kalau sudah selesai).
  /// Dipakai Latihan Relaksasi untuk langkah "Latihan napas 4–7–8".
  void tandaiSelesai(int i) {
    if (_selesai[i]) return;
    _selesai[i] = true;
    notifyListeners();
  }

  void ubah(int i) {
    _selesai[i] = !_selesai[i];
    notifyListeners();
  }
}
