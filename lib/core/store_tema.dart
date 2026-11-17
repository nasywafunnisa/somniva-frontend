import 'package:flutter/material.dart';

/// Pilihan tampilan: Terang, Gelap, atau mengikuti pengaturan perangkat.
enum PilihanTema { terang, gelap, sistem }

/// Pengaturan mode gelap (disimpan selama aplikasi terbuka).
/// Hilang kalau halaman di-refresh. Penyimpanan permanen = tahap database.
class StoreTema extends ChangeNotifier {
  StoreTema._();
  static final StoreTema instance = StoreTema._();

  // Yang sedang tampil (bisa berupa pratinjau di halaman Tampilan).
  PilihanTema _pilihan = PilihanTema.terang;
  bool _otomatis = false;

  // Yang sudah disimpan.
  PilihanTema _pilihanTersimpan = PilihanTema.terang;
  bool _otomatisTersimpan = false;

  bool _gelapTerakhir = false;

  PilihanTema get pilihan => _pilihan;
  bool get otomatisMalam => _otomatis;

  /// Jam otomatis gelap: 19:00 sampai 06:00.
  static const String jamOtomatis = '19:00–06:00';

  static bool _malam(DateTime t) => t.hour >= 19 || t.hour < 6;

  /// Apakah sekarang harus tampil gelap.
  bool gelapSekarang(Brightness perangkat, {DateTime? sekarang}) {
    bool hasil;
    if (_otomatis && _malam(sekarang ?? DateTime.now())) {
      hasil = true;
    } else {
      switch (_pilihan) {
        case PilihanTema.terang:
          hasil = false;
          break;
        case PilihanTema.gelap:
          hasil = true;
          break;
        case PilihanTema.sistem:
          hasil = perangkat == Brightness.dark;
          break;
      }
    }
    _gelapTerakhir = hasil;
    return hasil;
  }

  /// Menampilkan pilihan langsung (belum disimpan).
  void pratinjau({PilihanTema? pilihan, bool? otomatis}) {
    _pilihan = pilihan ?? _pilihan;
    _otomatis = otomatis ?? _otomatis;
    notifyListeners();
  }

  /// "Simpan tampilan".
  void simpan() {
    _pilihanTersimpan = _pilihan;
    _otomatisTersimpan = _otomatis;
  }

  /// Keluar dari halaman Tampilan tanpa menyimpan: kembali ke yang tersimpan.
  void batalkan() {
    if (_pilihan == _pilihanTersimpan && _otomatis == _otomatisTersimpan) return;
    _pilihan = _pilihanTersimpan;
    _otomatis = _otomatisTersimpan;
    notifyListeners();
  }

  /// Tombol bulan di web: bolak-balik Terang <-> Gelap, langsung disimpan.
  void balik() {
    _pilihan = _gelapTerakhir ? PilihanTema.terang : PilihanTema.gelap;
    _otomatis = false;
    simpan();
    notifyListeners();
  }
}
