import 'package:flutter/material.dart';

/// Satu baris catatan perubahan pengaturan.
class CatatanPengaturan {
  final String teks;
  final DateTime waktu;
  const CatatanPengaturan(this.teks, this.waktu);

  String get jam =>
      '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}';
}

/// Pengaturan sistem untuk admin (data CONTOH).
/// Tersimpan selama aplikasi terbuka. Nanti diganti penyimpanan di database,
/// dan baru saat itu pengaturan ini benar-benar memengaruhi aplikasi pengguna.
class StorePengaturanAdmin extends ChangeNotifier {
  StorePengaturanAdmin._();
  static final StorePengaturanAdmin instance = StorePengaturanAdmin._();

  bool _pendaftaranBuka = true;
  bool _notifikasiEmail = true;
  bool _pemeliharaan = false;
  final List<CatatanPengaturan> _catatan = [];

  bool get pendaftaranBuka => _pendaftaranBuka;
  bool get notifikasiEmail => _notifikasiEmail;
  bool get pemeliharaan => _pemeliharaan;

  /// Catatan terbaru di urutan pertama.
  List<CatatanPengaturan> get catatan => List.unmodifiable(_catatan);

  void _catat(String teks) {
    _catatan.insert(0, CatatanPengaturan(teks, DateTime.now()));
    if (_catatan.length > 20) _catatan.removeLast();
  }

  void ubahPendaftaran(bool nilai) {
    if (nilai == _pendaftaranBuka) return;
    _pendaftaranBuka = nilai;
    _catat(nilai ? 'Pendaftaran dibuka' : 'Pendaftaran ditutup');
    notifyListeners();
  }

  void ubahNotifikasi(bool nilai) {
    if (nilai == _notifikasiEmail) return;
    _notifikasiEmail = nilai;
    _catat(nilai ? 'Notifikasi email dinyalakan' : 'Notifikasi email dimatikan');
    notifyListeners();
  }

  void ubahPemeliharaan(bool nilai) {
    if (nilai == _pemeliharaan) return;
    _pemeliharaan = nilai;
    _catat(nilai ? 'Mode pemeliharaan diaktifkan' : 'Mode pemeliharaan dimatikan');
    notifyListeners();
  }
}
