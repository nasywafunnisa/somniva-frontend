import 'package:flutter/foundation.dart';
import 'rekomendasi.dart';

/// Pengaturan Pengingat Jadwal Tidur (disimpan selama aplikasi terbuka).
/// Data hilang kalau halaman di-refresh. Penyimpanan permanen dan notifikasi
/// sungguhan = tahap berikutnya.
class StorePengingat extends ChangeNotifier {
  StorePengingat._();
  static final StorePengingat instance = StorePengingat._();

  int _tidur = Rekomendasi.tidurMenit; // menit sejak 00:00
  int _bangun = Rekomendasi.bangunMenit;
  bool _windDownAktif = true;
  bool _tidurAktif = true;
  bool _alarmAktif = true;

  /// Senin sampai Minggu. Awalnya Senin-Jumat aktif.
  final List<bool> _hari = [true, true, true, true, true, false, false];

  int get tidurMenit => _tidur;
  int get bangunMenit => _bangun;
  bool get windDownAktif => _windDownAktif;
  bool get tidurAktif => _tidurAktif;
  bool get alarmAktif => _alarmAktif;
  List<bool> get hari => List<bool>.of(_hari);

  /// Wind-down dimulai sekian menit sebelum jam tidur.
  int get windDownMenit => Rekomendasi.windDown(_tidur);

  void simpan({
    required int tidur,
    required int bangun,
    required bool windDown,
    required bool pengingatTidur,
    required bool alarm,
    required List<bool> hari,
  }) {
    _tidur = tidur;
    _bangun = bangun;
    _windDownAktif = windDown;
    _tidurAktif = pengingatTidur;
    _alarmAktif = alarm;
    for (var i = 0; i < _hari.length && i < hari.length; i++) {
      _hari[i] = hari[i];
    }
    notifyListeners();
  }

  /// Dipakai tombol "Aktifkan pengingat" di halaman Rekomendasi.
  void aktifkanDariRekomendasi(int tidur) {
    _tidur = tidur;
    _windDownAktif = true;
    _tidurAktif = true;
    notifyListeners();
  }
}
