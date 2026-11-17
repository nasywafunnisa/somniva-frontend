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
  static const EntriTidur _awal = EntriTidur(
    tidur: TimeOfDay(hour: 23, minute: 0),
    bangun: TimeOfDay(hour: 6, minute: 15),
    suasana: 'Tenang',
    stres: 3,
    kafein: 2,
    kafeinTerakhir: TimeOfDay(hour: 15, minute: 30),
    aktif: true,
    gadgetMenit: 100,
  );

  EntriTidur _entri = _awal;

  EntriTidur get entri => _entri;

  /// Durasi tidur 6 malam sebelumnya (menit), data CONTOH.
  /// Malam terakhir (hari ini) diambil dari jurnal yang kamu isi.
  static const List<int> _malamSebelumnya = [420, 390, 450, 390, 420, 510];

  /// 20 catatan malam sebelumnya, data CONTOH (supaya analisis pola punya
  /// bahan). Catatan ke-21 adalah jurnal hari ini yang kamu isi sendiri.
  static const List<EntriTidur> _riwayatContoh = [
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 5), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Biasa', stres: 3, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 13, minute: 0), aktif: true, gadgetMenit: 125),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 35), bangun: TimeOfDay(hour: 6, minute: 5), suasana: 'Cemas', stres: 4, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 15, minute: 0), aktif: false, gadgetMenit: 110),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 50), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Cemas', stres: 4, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 16, minute: 0), aktif: false, gadgetMenit: 125),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 20), bangun: TimeOfDay(hour: 6, minute: 30), suasana: 'Cemas', stres: 5, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 18, minute: 0), aktif: false, gadgetMenit: 20),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 30), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Cemas', stres: 4, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 16, minute: 0), aktif: false, gadgetMenit: 95),
    EntriTidur(tidur: TimeOfDay(hour: 22, minute: 10), bangun: TimeOfDay(hour: 6, minute: 35), suasana: 'Cemas', stres: 4, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 14, minute: 0), aktif: true, gadgetMenit: 25),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 0), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Biasa', stres: 3, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 15, minute: 30), aktif: false, gadgetMenit: 80),
    EntriTidur(tidur: TimeOfDay(hour: 22, minute: 55), bangun: TimeOfDay(hour: 6, minute: 20), suasana: 'Semangat', stres: 1, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 15, minute: 30), aktif: true, gadgetMenit: 95),
    EntriTidur(tidur: TimeOfDay(hour: 22, minute: 45), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Biasa', stres: 3, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 10, minute: 0), aktif: true, gadgetMenit: 110),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 5), bangun: TimeOfDay(hour: 6, minute: 5), suasana: 'Tenang', stres: 2, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 16, minute: 0), aktif: true, gadgetMenit: 20),
    EntriTidur(tidur: TimeOfDay(hour: 22, minute: 40), bangun: TimeOfDay(hour: 6, minute: 40), suasana: 'Cemas', stres: 5, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 13, minute: 0), aktif: false, gadgetMenit: 25),
    EntriTidur(tidur: TimeOfDay(hour: 22, minute: 10), bangun: TimeOfDay(hour: 6, minute: 15), suasana: 'Biasa', stres: 3, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 10, minute: 0), aktif: true, gadgetMenit: 10),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 15), bangun: TimeOfDay(hour: 6, minute: 5), suasana: 'Cemas', stres: 5, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 16, minute: 0), aktif: false, gadgetMenit: 25),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 5), bangun: TimeOfDay(hour: 6, minute: 40), suasana: 'Biasa', stres: 3, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 17, minute: 0), aktif: true, gadgetMenit: 10),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 40), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Biasa', stres: 3, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 15, minute: 0), aktif: false, gadgetMenit: 110),
    EntriTidur(tidur: TimeOfDay(hour: 22, minute: 55), bangun: TimeOfDay(hour: 6, minute: 25), suasana: 'Tenang', stres: 2, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 18, minute: 0), aktif: true, gadgetMenit: 80),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 5), bangun: TimeOfDay(hour: 6, minute: 25), suasana: 'Biasa', stres: 3, kafein: 2, kafeinTerakhir: TimeOfDay(hour: 17, minute: 0), aktif: false, gadgetMenit: 25),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 30), bangun: TimeOfDay(hour: 6, minute: 10), suasana: 'Cemas', stres: 5, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 10, minute: 0), aktif: false, gadgetMenit: 140),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 0), bangun: TimeOfDay(hour: 6, minute: 15), suasana: 'Biasa', stres: 3, kafein: 1, kafeinTerakhir: TimeOfDay(hour: 12, minute: 0), aktif: false, gadgetMenit: 125),
    EntriTidur(tidur: TimeOfDay(hour: 23, minute: 30), bangun: TimeOfDay(hour: 6, minute: 5), suasana: 'Biasa', stres: 3, kafein: 3, kafeinTerakhir: TimeOfDay(hour: 15, minute: 30), aktif: false, gadgetMenit: 70),
  ];

  /// Semua catatan (20 contoh + hari ini), yang terlama dulu.
  List<EntriTidur> get riwayat => [..._riwayatContoh, _entri];

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

  /// Menghapus catatan jurnal yang kamu isi sendiri (kembali ke catatan awal).
  /// Data contoh bawaan tetap ada sampai database dibuat.
  void hapusCatatanSaya() {
    _entri = _awal;
    notifyListeners();
  }

  void simpan(EntriTidur baru) {
    _entri = baru;
    notifyListeners();
  }
}
