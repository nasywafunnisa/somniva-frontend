import 'package:flutter/material.dart';
import 'data_contoh.dart';
import 'entri_tidur.dart';

/// Tempat menyimpan catatan tidur TERAKHIR selama aplikasi terbuka.
/// Dashboard membaca dari sini, jadi ikut berubah setelah jurnal disimpan.
/// Data hilang kalau halaman di-refresh. Penyimpanan permanen = tahap database.
class StoreTidur extends ChangeNotifier {
  StoreTidur._();
  static final StoreTidur instance = StoreTidur._();

  /// Catatan awal (contoh) supaya Dashboard tidak kosong.
  EntriTidur _entri = const EntriTidur(
    tidur: TimeOfDay(hour: 23, minute: 0),
    bangun: TimeOfDay(hour: 6, minute: 15),
    suasana: 'Tenang',
    stres: 3,
    kafein: 2,
    kafeinTerakhir: TimeOfDay(hour: 15, minute: 30),
    aktif: true,
    gadgetMenit: 100,
  );

  EntriTidur get entri => _entri;

  /// Durasi tidur 6 malam sebelumnya (menit), data CONTOH.
  /// Malam terakhir (hari ini) diambil dari jurnal yang kamu isi.
  static const List<int> _malamSebelumnya = [420, 390, 450, 390, 420, 510];

  /// Durasi tidur 7 hari terakhir (menit), yang terlama dulu.
  List<int> get durasi7Hari => [..._malamSebelumnya, _entri.durasiMenit];

  /// Sleep Debt = (target x 7 malam) dikurangi total tidur 7 malam.
  /// Tidur berlebih di satu malam ikut menutup kekurangan malam lain.
  /// Tidak pernah negatif.
  int get sleepDebtMenit {
    final target = DataContoh.targetJam * 60 * 7;
    final total = durasi7Hari.fold<int>(0, (a, b) => a + b);
    final selisih = target - total;
    return selisih < 0 ? 0 : selisih;
  }

  int get skor => HitungSkor.total(_entri, targetJam: DataContoh.targetJam);

  List<FaktorSkor> get faktor =>
      HitungSkor.faktor(_entri, targetJam: DataContoh.targetJam);

  void simpan(EntriTidur baru) {
    _entri = baru;
    notifyListeners();
  }
}
