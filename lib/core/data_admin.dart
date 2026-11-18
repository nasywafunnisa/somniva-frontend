import 'package:flutter/material.dart';

/// Akun dan pengaturan admin.
/// Sementara belum ada server: akun admin berupa akun contoh.
/// Nanti diganti pengecekan ke PHP + MySQL (tahap database).
class StoreAdmin extends ChangeNotifier {
  StoreAdmin._();
  static final StoreAdmin instance = StoreAdmin._();

  /// Akun contoh untuk masuk (sesuai desain Login Admin).
  static const String emailContoh = 'admin@somniva.id';
  static const String sandiContoh = 'admin12345';

  String _nama = 'Admin Somniva';
  String _email = emailContoh;
  String _sandi = sandiContoh;

  String get nama => _nama;
  String get email => _email;

  String get inisial {
    final t = _nama.trim();
    return t.isEmpty ? 'A' : t.substring(0, 1).toUpperCase();
  }

  /// Simpan profil admin. [sandiBaru] kosong = kata sandi tidak diubah.
  /// Sementara hanya tersimpan selama aplikasi terbuka.
  void simpanProfil({
    required String nama,
    required String email,
    String sandiBaru = '',
  }) {
    _nama = nama.trim();
    _email = email.trim();
    if (sandiBaru.isNotEmpty) _sandi = sandiBaru;
    notifyListeners();
  }

  /// Benar kalau email dan kata sandi cocok dengan akun admin.
  bool cekMasuk(String email, String sandi) {
    return email.trim().toLowerCase() == _email.toLowerCase() &&
        sandi == _sandi;
  }
}

/// Satu baris di daftar "Artikel terpopuler".
class ArtikelPopuler {
  final String judul;
  final String kategori;
  final int baca;
  const ArtikelPopuler(this.judul, this.kategori, this.baca);
}

/// Satu baris di kartu "Penyelesaian Program 14 Hari".
class PenyelesaianProgram {
  final String label;
  final int persen;
  const PenyelesaianProgram(this.label, this.persen);
}

/// Data CONTOH untuk Dashboard Admin (data agregat saja, bukan data pribadi).
/// Nanti diganti data asli dari database.
class DataAdmin {
  DataAdmin._();

  static const int totalPengguna = 12480;
  static const int penggunaBaruBulanIni = 642;
  static const int aktif7Hari = 8214;
  static const int artikelTerbit = 48;
  static const int artikelDraf = 3;
  static const int pesertaProgram = 1516;
  static const String programTerbanyak = 'Program 14 Hari';

  /// Persen pengguna aktif 7 hari dari total.
  static int get persenAktif => (aktif7Hari * 100 / totalPengguna).round();

  /// Pendaftar baru 7 hari terakhir, dari yang terlama ke hari ini.
  static const List<int> pendaftar7Hari = [78, 92, 85, 110, 96, 122, 102];

  /// Nama hari untuk 7 hari terakhir, berakhir di hari ini.
  static List<String> get labelHari7 {
    const nama = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final sekarang = DateTime.now();
    return List<String>.generate(7, (i) {
      final hari = sekarang.subtract(Duration(days: 6 - i));
      return nama[hari.weekday - 1];
    });
  }

  static const List<PenyelesaianProgram> penyelesaian = [
    PenyelesaianProgram('Selesai', 41),
    PenyelesaianProgram('Sedang berjalan', 38),
    PenyelesaianProgram('Berhenti', 21),
  ];

  static const List<ArtikelPopuler> artikelPopuler = [
    ArtikelPopuler(
        'Mengapa jam tidur yang konsisten penting', 'Kebiasaan', 1842),
    ArtikelPopuler('Kafein dan tidur: kapan batas terbaik?', 'Kafein', 1316),
    ArtikelPopuler('Menyiapkan kamar yang nyaman untuk tidur', 'Kamar', 974),
  ];

  /// 2026-10-12 -> "12 Okt 2026"
  static String tanggalPendek(DateTime d) {
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', //
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  /// 0 -> "Hari ini", 1 -> "Kemarin", 5 -> "5 hari lalu"
  static String terakhirMasuk(int hariLalu) {
    if (hariLalu <= 0) return 'Hari ini';
    if (hariLalu == 1) return 'Kemarin';
    return '$hariLalu hari lalu';
  }

  /// 12480 -> "12.480"
  static String ribuan(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}

/// Satu akun pengguna di Manajemen Pengguna.
/// Hanya data akun. Tidak ada jurnal, catatan, atau skor tidur pribadi.
class AkunPengguna {
  final int id;
  final String nama;
  final String email;
  final DateTime daftar;
  final int hariLaluMasuk;
  final bool aktif;

  const AkunPengguna({
    required this.id,
    required this.nama,
    required this.email,
    required this.daftar,
    required this.hariLaluMasuk,
    required this.aktif,
  });

  String get inisial =>
      nama.trim().isEmpty ? '?' : nama.trim().substring(0, 1).toUpperCase();

  AkunPengguna salinDengan({bool? aktif}) => AkunPengguna(
        id: id,
        nama: nama,
        email: email,
        daftar: daftar,
        hariLaluMasuk: hariLaluMasuk,
        aktif: aktif ?? this.aktif,
      );
}

/// Daftar akun untuk halaman Manajemen Pengguna (data CONTOH).
/// Perubahan status hanya tersimpan selama aplikasi terbuka.
/// Nanti diganti data asli dari database.
class StorePenggunaAdmin extends ChangeNotifier {
  StorePenggunaAdmin._();
  static final StorePenggunaAdmin instance = StorePenggunaAdmin._();

  final List<AkunPengguna> _daftar = [
    AkunPengguna(
        id: 1,
        nama: 'Sari Wulandari',
        email: 'sari@email.com',
        daftar: DateTime(2026, 10, 12),
        hariLaluMasuk: 0,
        aktif: true),
    AkunPengguna(
        id: 2,
        nama: 'Budi Santoso',
        email: 'budi.s@email.com',
        daftar: DateTime(2026, 10, 3),
        hariLaluMasuk: 1,
        aktif: true),
    AkunPengguna(
        id: 3,
        nama: 'Dewi Anggraini',
        email: 'dewi.a@email.com',
        daftar: DateTime(2026, 9, 28),
        hariLaluMasuk: 0,
        aktif: true),
    AkunPengguna(
        id: 4,
        nama: 'Rizky Pratama',
        email: 'rizky.p@email.com',
        daftar: DateTime(2026, 9, 19),
        hariLaluMasuk: 41,
        aktif: false),
    AkunPengguna(
        id: 5,
        nama: 'Putri Maharani',
        email: 'putri.m@email.com',
        daftar: DateTime(2026, 9, 7),
        hariLaluMasuk: 2,
        aktif: true),
    AkunPengguna(
        id: 6,
        nama: 'Andi Firmansyah',
        email: 'andi.f@email.com',
        daftar: DateTime(2026, 9, 2),
        hariLaluMasuk: 3,
        aktif: true),
    AkunPengguna(
        id: 7,
        nama: 'Maya Lestari',
        email: 'maya.l@email.com',
        daftar: DateTime(2026, 8, 21),
        hariLaluMasuk: 5,
        aktif: true),
    AkunPengguna(
        id: 8,
        nama: 'Fajar Nugroho',
        email: 'fajar.n@email.com',
        daftar: DateTime(2026, 8, 9),
        hariLaluMasuk: 63,
        aktif: false),
    AkunPengguna(
        id: 9,
        nama: 'Citra Ayu',
        email: 'citra.a@email.com',
        daftar: DateTime(2026, 7, 30),
        hariLaluMasuk: 1,
        aktif: true),
    AkunPengguna(
        id: 10,
        nama: 'Hendra Wijaya',
        email: 'hendra.w@email.com',
        daftar: DateTime(2026, 7, 14),
        hariLaluMasuk: 9,
        aktif: true),
  ];

  List<AkunPengguna> get semua => List.unmodifiable(_daftar);

  /// [status]: 'Semua', 'Aktif', atau 'Nonaktif'.
  /// [kata]: dicocokkan ke nama atau email (huruf besar/kecil tidak berpengaruh).
  List<AkunPengguna> cari({String status = 'Semua', String kata = ''}) {
    final k = kata.trim().toLowerCase();
    return _daftar.where((a) {
      if (status == 'Aktif' && !a.aktif) return false;
      if (status == 'Nonaktif' && a.aktif) return false;
      if (k.isEmpty) return true;
      return a.nama.toLowerCase().contains(k) ||
          a.email.toLowerCase().contains(k);
    }).toList();
  }

  void ubahStatus(int id, bool aktif) {
    final i = _daftar.indexWhere((a) => a.id == id);
    if (i < 0) return;
    _daftar[i] = _daftar[i].salinDengan(aktif: aktif);
    notifyListeners();
  }
}
