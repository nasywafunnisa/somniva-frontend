import 'data_contoh.dart';
import 'entri_tidur.dart';
import 'store_profil.dart';
import 'store_tidur.dart';

/// Perhitungan Rekomendasi Waktu Tidur.
///
/// Aturannya sederhana dan RANCANGAN KITA SENDIRI (edukatif, bukan medis):
/// jam tidur = jam bangun dikurangi target tidur.
/// Contoh: bangun 06:30, target 8 jam -> tidur 22:30.
class Rekomendasi {
  Rekomendasi._();

  static const int _hari = 24 * 60;

  /// Jam bangun yang diinginkan (menit sejak 00:00). 06:30 = 390.
  static int get bangunMenit => StoreProfil.instance.bangunMenit;

  /// Wind-down dimulai sekian menit sebelum jam tidur.
  static const int windDownMenit = 30;

  /// Selisih pilihan jam tidur (22:15, 22:30, 22:45).
  static const int langkahMenit = 15;

  static int _bulat(int m) => ((m % _hari) + _hari) % _hari;

  /// Jam tidur yang disarankan.
  static int get tidurMenit => _bulat(bangunMenit - DataContoh.targetJam * 60);

  /// Tiga pilihan: lebih awal 15 menit, saran utama, lebih lambat 15 menit.
  static List<int> get pilihan => [
        _bulat(tidurMenit - langkahMenit),
        tidurMenit,
        _bulat(tidurMenit + langkahMenit),
      ];

  static int windDown(int tidur) => _bulat(tidur - windDownMenit);

  /// Lama tidur kalau mulai [tidur] dan bangun di [bangunMenit].
  static int durasi(int tidur) => _bulat(bangunMenit - tidur);

  /// 1350 -> "22:30"
  static String jam(int menit) {
    final m = _bulat(menit);
    final h = (m ~/ 60).toString().padLeft(2, '0');
    final mm = (m % 60).toString().padLeft(2, '0');
    return '$h:$mm';
  }

  /// Teks di bawah angka besar.
  /// Contoh: "Bangun 06:30 · target 8 jam · wind-down mulai 22:00"
  static String ringkasan(int tidur) {
    final d = durasi(tidur);
    final lama = d == DataContoh.targetJam * 60
        ? 'target ${DataContoh.targetJam} jam'
        : 'tidur ${EntriTidur.formatDurasi(d)}';
    return 'Bangun ${jam(bangunMenit)} · $lama · wind-down mulai ${jam(windDown(tidur))}';
  }

  /// Berapa poin skor rata-rata malam yang mulai tidur sebelum 23:00
  /// lebih tinggi dibanding yang lebih lambat. null kalau catatannya
  /// belum cukup (minimal 2 malam di tiap kelompok).
  /// Ini hubungan statistik dari catatanmu, bukan sebab-akibat.
  static int? selisihTidurAwal(List<EntriTidur> riwayat) {
    final awal = <int>[];
    final lambat = <int>[];
    for (final e in riwayat) {
      var m = e.tidur.hour * 60 + e.tidur.minute;
      if (m < 12 * 60) m += _hari; // 00:30 dihitung 24:30
      final skor = HitungSkor.total(e, targetJam: DataContoh.targetJam);
      (m < 23 * 60 ? awal : lambat).add(skor);
    }
    if (awal.length < 2 || lambat.length < 2) return null;
    double rata(List<int> l) => l.reduce((a, b) => a + b) / l.length;
    return (rata(awal) - rata(lambat)).round();
  }

  /// Kalimat dasar ke-2: pengaruh jam tidur terhadap skor.
  static String kalimatRiwayat() {
    final s = selisihTidurAwal(StoreTidur.instance.riwayat);
    if (s == null) {
      return 'Catat lebih banyak malam untuk melihat pengaruh jam tidur';
    }
    if (s > 0) return 'Tidur sebelum 23:00 → skor rata-rata +$s poin';
    return 'Di catatanmu, tidur lebih awal belum terlihat menaikkan skor';
  }

  /// Judul dasar ke-3: Sleep Debt sekarang.
  static String judulDebt() {
    final d = StoreTidur.instance.sleepDebtMenit;
    if (d == 0) return 'Tidak ada Sleep Debt';
    return 'Sleep Debt ${EntriTidur.formatDurasi(d)}';
  }

  static String ketDebt() {
    return StoreTidur.instance.sleepDebtMenit == 0
        ? 'Pertahankan jadwal tidurmu'
        : 'Dicicil bertahap, bukan sekaligus';
  }
}
