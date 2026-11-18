import 'package:flutter/material.dart';

enum StatusProgram { aktif, draf, nonaktif }

extension StatusProgramTeks on StatusProgram {
  String get label {
    switch (this) {
      case StatusProgram.aktif:
        return 'Aktif';
      case StatusProgram.draf:
        return 'Draf';
      case StatusProgram.nonaktif:
        return 'Nonaktif';
    }
  }
}

/// Satu tugas harian dalam sebuah program.
class TugasProgram {
  final int hari;
  final String teks;
  const TugasProgram(this.hari, this.teks);
}

/// Satu program di Manajemen Program (data CONTOH).
class ProgramKelola {
  final int id;
  final String nama;
  final StatusProgram status;
  final int peserta;
  final List<TugasProgram> tugas;

  const ProgramKelola({
    required this.id,
    required this.nama,
    required this.status,
    required this.peserta,
    required this.tugas,
  });

  ProgramKelola salinDengan({
    String? nama,
    StatusProgram? status,
    List<TugasProgram>? tugas,
  }) =>
      ProgramKelola(
        id: id,
        nama: nama ?? this.nama,
        status: status ?? this.status,
        peserta: peserta,
        tugas: tugas ?? this.tugas,
      );
}

/// Daftar program untuk halaman admin. Perubahan hanya tersimpan selama
/// aplikasi terbuka (hilang kalau halaman di-refresh).
/// Nanti diganti data asli dari database.
class StoreProgramAdmin extends ChangeNotifier {
  StoreProgramAdmin._();
  static final StoreProgramAdmin instance = StoreProgramAdmin._();

  static const int maksTugas = 30;

  static List<TugasProgram> _susun(List<String> teks) => [
        for (var i = 0; i < teks.length; i++) TugasProgram(i + 1, teks[i]),
      ];

  int _idBerikut = 4;

  late final List<ProgramKelola> _daftar = [
    ProgramKelola(
      id: 1,
      nama: 'Program 14 Hari Dasar',
      status: StatusProgram.aktif,
      peserta: 1204,
      tugas: _susun(const [
        'Catat jam tidur dan bangun',
        'Tetapkan jam bangun tetap',
        'Batasi kafein setelah 15:00',
        'Redupkan lampu 30 menit sebelum tidur',
        'Rutinitas tenang sebelum tidur',
        'Jalan kaki atau peregangan ringan',
        'Tinjau Sleep Score minggu pertama',
        'Atur jadwal bangun di akhir pekan',
        'Tulis hal yang masih dipikirkan',
        'Rapikan kamar agar nyaman',
        'Peregangan ringan sebelum tidur',
        'Tanpa kafein setelah 15:00',
        'Latihan napas 4–7–8 selama 5 menit',
        'Tinjau hasil dua minggu',
      ]),
    ),
    ProgramKelola(
      id: 2,
      nama: 'Jadwal Teratur 7 Hari',
      status: StatusProgram.draf,
      peserta: 0,
      tugas: _susun(const [
        'Catat jam tidur dan bangun',
        'Pilih jam bangun yang realistis',
        'Bangun di jam yang sama',
        'Tidur di jam yang sama',
        'Hindari tidur siang panjang',
        'Pertahankan jadwal di akhir pekan',
        'Tinjau hasil seminggu',
      ]),
    ),
    ProgramKelola(
      id: 3,
      nama: 'Kurangi Layar 10 Hari',
      status: StatusProgram.nonaktif,
      peserta: 312,
      tugas: _susun(const [
        'Catat durasi layar sebelum tidur',
        'Matikan layar 15 menit sebelum tidur',
        'Matikan layar 30 menit sebelum tidur',
        'Simpan ponsel jauh dari tempat tidur',
        'Matikan layar 45 menit sebelum tidur',
        'Ganti layar dengan membaca buku',
        'Aktifkan mode malam di perangkat',
        'Matikan layar 60 menit sebelum tidur',
        'Latihan napas sebelum tidur',
        'Tinjau perubahan skor tidurmu',
      ]),
    ),
  ];

  List<ProgramKelola> get semua => List.unmodifiable(_daftar);

  ProgramKelola? ambil(int id) {
    final i = _daftar.indexWhere((p) => p.id == id);
    return i < 0 ? null : _daftar[i];
  }

  int _cari(int id) => _daftar.indexWhere((p) => p.id == id);

  /// Program baru berstatus Draf, 0 peserta, belum ada tugas. Ditaruh di atas.
  ProgramKelola buat(String nama) {
    final baru = ProgramKelola(
      id: _idBerikut++,
      nama: nama,
      status: StatusProgram.draf,
      peserta: 0,
      tugas: const [],
    );
    _daftar.insert(0, baru);
    notifyListeners();
    return baru;
  }

  void ubahNama(int id, String nama) {
    final i = _cari(id);
    if (i < 0) return;
    _daftar[i] = _daftar[i].salinDengan(nama: nama);
    notifyListeners();
  }

  void ubahStatus(int id, StatusProgram status) {
    final i = _cari(id);
    if (i < 0) return;
    _daftar[i] = _daftar[i].salinDengan(status: status);
    notifyListeners();
  }

  void hapus(int id) {
    _daftar.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void tambahTugas(int id, String teks) {
    final i = _cari(id);
    if (i < 0 || _daftar[i].tugas.length >= maksTugas) return;
    final lama = _daftar[i].tugas;
    _daftar[i] = _daftar[i]
        .salinDengan(tugas: [...lama, TugasProgram(lama.length + 1, teks)]);
    notifyListeners();
  }

  void ubahTugas(int id, int hari, String teks) {
    final i = _cari(id);
    if (i < 0) return;
    _daftar[i] = _daftar[i].salinDengan(tugas: [
      for (final t in _daftar[i].tugas)
        t.hari == hari ? TugasProgram(t.hari, teks) : t,
    ]);
    notifyListeners();
  }

  /// Menghapus tugas, lalu nomor hari sesudahnya digeser naik.
  void hapusTugas(int id, int hari) {
    final i = _cari(id);
    if (i < 0) return;
    final sisa = [
      for (final t in _daftar[i].tugas)
        if (t.hari != hari) t,
    ];
    _daftar[i] = _daftar[i].salinDengan(tugas: [
      for (var n = 0; n < sisa.length; n++) TugasProgram(n + 1, sisa[n].teks),
    ]);
    notifyListeners();
  }
}
