import 'package:flutter/material.dart';

/// Rencana satu hari dalam Program 14 Hari.
class RencanaHari {
  final String judul;
  final List<String> tugas; // selalu 3 tugas
  const RencanaHari(this.judul, this.tugas);
}

/// Status Program 14 Hari: hari ke berapa, dan tugas mana yang sudah dicentang.
/// Disimpan di memori saja (hilang kalau halaman di-refresh).
class StoreProgram extends ChangeNotifier {
  StoreProgram._();
  static final StoreProgram instance = StoreProgram._();

  static const int total = 14;

  /// Isi program. Langkah-langkah umum kebersihan tidur (sleep hygiene),
  /// disusun sendiri sebagai bahan edukasi, bukan terapi medis.
  static const List<RencanaHari> rencana = [
    RencanaHari('Kenali kebiasaanmu', [
      'Catat jam tidur dan bangun di jurnal',
      'Catat jumlah kafein hari ini',
      'Tentukan jam bangun yang bisa kamu pertahankan',
    ]),
    RencanaHari('Jam bangun tetap', [
      'Bangun di jam yang sama dengan kemarin',
      'Cari cahaya pagi selama 10 menit',
      'Catat suasana hatimu di jurnal',
    ]),
    RencanaHari('Kafein lebih awal', [
      'Hentikan kafein setelah 15:00',
      'Minum air putih cukup di sore hari',
      'Catat tidurmu di jurnal',
    ]),
    RencanaHari('Jeda sebelum tidur', [
      'Redupkan lampu 30 menit sebelum tidur',
      'Siapkan kamar yang sejuk, gelap, dan tenang',
      'Catat tidurmu di jurnal',
    ]),
    RencanaHari('Rutinitas tenang', [
      'Matikan layar 45 menit sebelum tidur',
      'Latihan napas 4–7–8 selama 5 menit',
      'Tidur sebelum 22:30',
    ]),
    RencanaHari('Gerak ringan', [
      'Jalan kaki atau peregangan 20–30 menit',
      'Selesaikan makan malam 2–3 jam sebelum tidur',
      'Matikan layar 45 menit sebelum tidur',
    ]),
    RencanaHari('Tinjau minggu pertama', [
      'Lihat Sleep Score 7 harimu',
      'Pilih satu kebiasaan yang paling terasa membantu',
      'Tidur sebelum 22:30',
    ]),
    RencanaHari('Jadwal akhir pekan', [
      'Bangun paling lambat 1 jam dari jam biasa',
      'Batasi tidur siang maksimal 30 menit',
      'Catat tidurmu di jurnal',
    ]),
    RencanaHari('Ringankan pikiran', [
      'Tulis 3 hal yang masih kamu pikirkan',
      'Latihan napas 4–7–8 selama 5 menit',
      'Matikan layar 45 menit sebelum tidur',
    ]),
    RencanaHari('Kamar yang nyaman', [
      'Kurangi cahaya dan suara di kamar',
      'Pakai tempat tidur hanya untuk tidur',
      'Tidur sebelum 22:30',
    ]),
    RencanaHari('Peregangan malam', [
      'Peregangan ringan selama 5 menit',
      'Relaksasi otot selama 5 menit',
      'Matikan layar 45 menit sebelum tidur',
    ]),
    RencanaHari('Konsisten tanpa kafein sore', [
      'Tanpa kafein setelah 15:00',
      'Bangun di jam yang sama',
      'Tidur sebelum 22:30',
    ]),
    RencanaHari('Pertahankan', [
      'Ulangi rutinitas tenang malam ini',
      'Latihan napas 4–7–8 selama 5 menit',
      'Catat tidurmu di jurnal',
    ]),
    RencanaHari('Tinjau hasilmu', [
      'Bandingkan Sleep Score awal dan sekarang',
      'Tulis kebiasaan yang ingin kamu lanjutkan',
      'Tentukan jam tidur dan bangun tetapmu',
    ]),
  ];

  static DateTime _hariIni() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Program dianggap dimulai 4 hari lalu (data contoh), jadi hari ini Hari 5.
  DateTime _mulai = _hariIni().subtract(const Duration(days: 4));

  /// Tugas yang sudah dicentang: nomor hari -> nomor tugas (0 sampai 2).
  /// Hari 1 sampai 4 sudah selesai (contoh), Hari 5 baru tugas pertama.
  final Map<int, Set<int>> _centang = {
    1: {0, 1, 2},
    2: {0, 1, 2},
    3: {0, 1, 2},
    4: {0, 1, 2},
    5: {0},
  };

  /// Hari program hari ini (1 sampai 14), mengikuti tanggal.
  int get hariAktif {
    final selisih = _hariIni().difference(_mulai).inDays;
    return (selisih + 1).clamp(1, total);
  }

  String get judulHariIni => rencana[hariAktif - 1].judul;

  bool dicentang(int hari, int tugas) => _centang[hari]?.contains(tugas) ?? false;

  bool selesai(int hari) => (_centang[hari]?.length ?? 0) == 3;

  int get jumlahSelesai =>
      List.generate(total, (i) => i + 1).where(selesai).length;

  /// Persen berdasarkan hari berjalan (Hari 5 dari 14 = 36%).
  int get persen => (hariAktif / total * 100).round();

  /// Hanya tugas di hari ini yang bisa dicentang.
  void ubahCentang(int hari, int tugas) {
    if (hari != hariAktif) return;
    final set = _centang.putIfAbsent(hari, () => <int>{});
    if (!set.add(tugas)) set.remove(tugas);
    notifyListeners();
  }

  /// KHUSUS DEMO: maju satu hari supaya hari berikutnya bisa diperlihatkan.
  void majuSatuHariDemo() {
    if (hariAktif >= total) return;
    _mulai = _mulai.subtract(const Duration(days: 1));
    notifyListeners();
  }
}
