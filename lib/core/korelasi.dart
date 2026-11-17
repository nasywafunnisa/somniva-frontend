import 'data_contoh.dart';
import 'entri_tidur.dart';

/// Hasil perbandingan dua kelompok hari (contoh: kafein sebelum vs setelah 15:00).
class HasilBanding {
  final String label1;
  final String label2;
  final int? nilai1;
  final int? nilai2;
  final String ringkasan;

  const HasilBanding({
    required this.label1,
    required this.label2,
    required this.nilai1,
    required this.nilai2,
    required this.ringkasan,
  });

  bool get cukup => nilai1 != null && nilai2 != null;
}

/// Satu titik di grafik sebar: jam mulai tidur dan skor malam itu.
class TitikSebar {
  /// Menit sejak 00:00. Setelah tengah malam dihitung 24:00 dan seterusnya
  /// (00:30 menjadi 1470), supaya urutannya benar.
  final int menitTidur;
  final int skor;
  const TitikSebar(this.menitTidur, this.skor);
}

/// Mencari hubungan statistik sederhana dari catatan jurnal.
///
/// Caranya membandingkan rata-rata Sleep Score dua kelompok hari.
/// Ini HUBUNGAN, bukan sebab-akibat. Catatan penting: Sleep Score sendiri
/// dihitung dari faktor-faktor ini (lihat HitungSkor), jadi hubungannya
/// sebagian memang dibangun oleh rumus skor.
class Korelasi {
  Korelasi._();

  /// Kelompok minimal agar perbandingan dianggap berarti.
  static const int _minimalPerKelompok = 2;

  static int _skor(EntriTidur e) =>
      HitungSkor.total(e, targetJam: DataContoh.targetJam);

  static int _menitTidur(EntriTidur e) {
    final m = e.tidur.hour * 60 + e.tidur.minute;
    return m < 12 * 60 ? m + 24 * 60 : m;
  }

  static int? _rata(List<int> l) {
    if (l.length < _minimalPerKelompok) return null;
    return (l.reduce((a, b) => a + b) / l.length).round();
  }

  static const String _belumCukup =
      'Belum cukup catatan di kedua kelompok untuk dibandingkan.';

  /// Kafein sore: terakhir minum sebelum 15:00 (atau tidak minum) vs setelah 15:00.
  static HasilBanding kafein(List<EntriTidur> r) {
    final sebelum = <int>[];
    final setelah = <int>[];
    for (final e in r) {
      final menit = e.kafeinTerakhir.hour * 60 + e.kafeinTerakhir.minute;
      if (e.kafein > 0 && menit >= 15 * 60) {
        setelah.add(_skor(e));
      } else {
        sebelum.add(_skor(e));
      }
    }
    final a = _rata(sebelum);
    final b = _rata(setelah);
    String teks = _belumCukup;
    if (a != null && b != null) {
      final selisih = a - b;
      if (selisih > 0) {
        teks = 'Skor rata-rata turun $selisih poin pada hari dengan kafein sore.';
      } else if (selisih < 0) {
        teks = 'Di catatanmu, kafein sore belum terlihat menurunkan skor.';
      } else {
        teks = 'Skor rata-rata sama di hari dengan dan tanpa kafein sore.';
      }
    }
    return HasilBanding(
      label1: 'Sebelum 15:00',
      label2: 'Setelah 15:00',
      nilai1: a,
      nilai2: b,
      ringkasan: teks,
    );
  }

  /// Layar sebelum tidur: kurang dari 30 menit vs 60 menit atau lebih.
  static HasilBanding layar(List<EntriTidur> r) {
    final sedikit = <EntriTidur>[];
    final banyak = <EntriTidur>[];
    for (final e in r) {
      if (e.gadgetMenit < 30) sedikit.add(e);
      if (e.gadgetMenit >= 60) banyak.add(e);
    }
    final a = _rata(sedikit.map(_skor).toList());
    final b = _rata(banyak.map(_skor).toList());
    String teks = _belumCukup;
    if (a != null && b != null) {
      double rata(List<EntriTidur> l) =>
          l.map(_menitTidur).reduce((x, y) => x + y) / l.length;
      final selisih = (rata(banyak) - rata(sedikit)).round();
      if (selisih >= 5) {
        teks = 'Kamu cenderung mulai tidur sekitar $selisih menit lebih lambat.';
      } else {
        teks = 'Jam mulai tidurmu hampir sama di kedua kelompok.';
      }
    }
    return HasilBanding(
      label1: 'Kurang 30 mnt',
      label2: 'Lebih 1 jam',
      nilai1: a,
      nilai2: b,
      ringkasan: teks,
    );
  }

  /// Aktivitas fisik: hari aktif vs tidak aktif.
  static HasilBanding aktivitas(List<EntriTidur> r) {
    final aktif = <int>[];
    final tidak = <int>[];
    for (final e in r) {
      (e.aktif ? aktif : tidak).add(_skor(e));
    }
    final a = _rata(aktif);
    final b = _rata(tidak);
    String teks = _belumCukup;
    if (a != null && b != null) {
      final selisih = a - b;
      if (selisih > 0) {
        teks = 'Hari dengan aktivitas fisik punya skor $selisih poin lebih tinggi.';
      } else if (selisih < 0) {
        teks = 'Di catatanmu, hari aktif belum terlihat punya skor lebih tinggi.';
      } else {
        teks = 'Skor rata-rata sama di hari aktif dan tidak aktif.';
      }
    }
    return HasilBanding(
      label1: 'Aktif',
      label2: 'Tidak aktif',
      nilai1: a,
      nilai2: b,
      ringkasan: teks,
    );
  }

  /// Titik untuk grafik "Jam mulai tidur dan Sleep Score".
  static List<TitikSebar> titik(List<EntriTidur> r) {
    return r.map((e) => TitikSebar(_menitTidur(e), _skor(e))).toList();
  }

  /// Garis tren (kuadrat terkecil): skor = a + b * menit.
  /// Mengembalikan null kalau titiknya kurang dari 3 atau semua jamnya sama.
  static ({double a, double b})? tren(List<TitikSebar> t) {
    if (t.length < 3) return null;
    final n = t.length;
    final mx = t.map((p) => p.menitTidur).reduce((x, y) => x + y) / n;
    final my = t.map((p) => p.skor).reduce((x, y) => x + y) / n;
    var sxx = 0.0, sxy = 0.0;
    for (final p in t) {
      sxx += (p.menitTidur - mx) * (p.menitTidur - mx);
      sxy += (p.menitTidur - mx) * (p.skor - my);
    }
    if (sxx == 0) return null;
    final b = sxy / sxx;
    return (a: my - b * mx, b: b);
  }

  /// Satu kalimat untuk banner "Temuan minggu ini" di Dashboard web.
  static String temuan(List<EntriTidur> r) {
    final k = kafein(r);
    if (k.cukup && k.nilai1! > k.nilai2!) {
      final s = k.nilai1! - k.nilai2!;
      return 'Hari dengan kafein setelah 15:00 punya skor rata-rata $s poin lebih rendah. Ini hubungan statistik dari catatanmu, bukan diagnosis.';
    }
    return 'Catat lebih banyak hari untuk melihat hubungan antara kebiasaan dan skor tidurmu. Ini hubungan statistik, bukan diagnosis.';
  }
}
