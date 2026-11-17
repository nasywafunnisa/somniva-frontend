import 'package:flutter/foundation.dart';

/// Data profil dan izin privasi (disimpan selama aplikasi terbuka).
/// Hilang kalau halaman di-refresh. Penyimpanan permanen = tahap database.
class StoreProfil extends ChangeNotifier {
  StoreProfil._();
  static final StoreProfil instance = StoreProfil._();

  static const String _namaAwal = 'Sari Wulandari';
  static const String _emailAwal = 'sari@email.com';
  static const int _bangunAwal = 6 * 60 + 30; // 06:30
  static const int _targetAwal = 8;

  String _nama = _namaAwal;
  String _email = _emailAwal;
  int _bangunMenit = _bangunAwal;
  int _targetJam = _targetAwal;

  bool _simpanRiwayat = true;
  bool _analisisKorelasi = true;
  bool _rekomendasiPribadi = true;

  String get nama => _nama;
  String get email => _email;
  int get bangunMenit => _bangunMenit;
  int get targetJam => _targetJam;

  bool get simpanRiwayat => _simpanRiwayat;
  bool get analisisKorelasi => _analisisKorelasi;
  bool get rekomendasiPribadi => _rekomendasiPribadi;

  /// Nama depan (kata pertama) untuk sapaan.
  String get namaDepan {
    final bagian = _nama.trim().split(RegExp(r'\s+'));
    return bagian.first.isEmpty ? 'Kamu' : bagian.first;
  }

  /// Huruf pertama untuk lingkaran avatar.
  String get inisial => namaDepan.substring(0, 1).toUpperCase();

  void simpanProfil({
    String? nama,
    String? email,
    int? bangunMenit,
    int? targetJam,
  }) {
    if (nama != null && nama.trim().isNotEmpty) _nama = nama.trim();
    if (email != null && email.trim().isNotEmpty) _email = email.trim();
    if (bangunMenit != null) _bangunMenit = bangunMenit;
    if (targetJam != null) _targetJam = targetJam;
    notifyListeners();
  }

  void ubahIzin({
    bool? simpanRiwayat,
    bool? analisisKorelasi,
    bool? rekomendasiPribadi,
  }) {
    _simpanRiwayat = simpanRiwayat ?? _simpanRiwayat;
    _analisisKorelasi = analisisKorelasi ?? _analisisKorelasi;
    _rekomendasiPribadi = rekomendasiPribadi ?? _rekomendasiPribadi;
    notifyListeners();
  }

  /// Dipakai "Hapus akun & semua data": kembali ke data awal.
  void reset() {
    _nama = _namaAwal;
    _email = _emailAwal;
    _bangunMenit = _bangunAwal;
    _targetJam = _targetAwal;
    _simpanRiwayat = true;
    _analisisKorelasi = true;
    _rekomendasiPribadi = true;
    notifyListeners();
  }
}
