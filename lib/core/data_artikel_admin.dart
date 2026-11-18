import 'package:flutter/material.dart';

/// Satu artikel di Manajemen Artikel & Edukasi (data CONTOH).
class ArtikelKelola {
  final int id;
  final String judul;
  final String kategori;
  final String isi;
  final bool terbit; // false = draf

  const ArtikelKelola({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.isi,
    required this.terbit,
  });

  ArtikelKelola salinDengan({
    String? judul,
    String? kategori,
    String? isi,
    bool? terbit,
  }) =>
      ArtikelKelola(
        id: id,
        judul: judul ?? this.judul,
        kategori: kategori ?? this.kategori,
        isi: isi ?? this.isi,
        terbit: terbit ?? this.terbit,
      );
}

/// Daftar artikel untuk halaman admin. Perubahan hanya tersimpan selama
/// aplikasi terbuka (hilang kalau halaman di-refresh).
/// Nanti diganti data asli dari database.
class StoreArtikelAdmin extends ChangeNotifier {
  StoreArtikelAdmin._();
  static final StoreArtikelAdmin instance = StoreArtikelAdmin._();

  static const List<String> kategori = [
    'Kebiasaan',
    'Kafein',
    'Kamar',
    'Relaksasi',
  ];

  // Angka dasar sesuai desain: 48 terbit dan 3 draf. Daftar di bawah hanya
  // memuat artikel terbaru (3 terbit + 2 draf dari angka itu).
  static const int _dasarTerbit = 48;
  static const int _dasarDraf = 3;
  static const int _contohTerbit = 3;
  static const int _contohDraf = 2;

  int _idBerikut = 6;

  final List<ArtikelKelola> _daftar = [
    const ArtikelKelola(
      id: 1,
      judul: 'Mengapa jam tidur yang konsisten penting',
      kategori: 'Kebiasaan',
      terbit: true,
      isi:
          'Tubuh punya jam internal yang menyukai keteraturan. Tidur dan bangun pada jam yang sama, termasuk akhir pekan, membantu kantuk datang lebih mudah di malam hari.',
    ),
    const ArtikelKelola(
      id: 2,
      judul: 'Kafein dan tidur: kapan batas terbaik?',
      kategori: 'Kafein',
      terbit: true,
      isi:
          'Kafein bertahan di tubuh selama beberapa jam. Untuk kebanyakan orang, menghindarinya enam jam sebelum tidur membantu tidur lebih nyenyak.',
    ),
    const ArtikelKelola(
      id: 3,
      judul: 'Menyiapkan kamar yang nyaman untuk tidur',
      kategori: 'Kamar',
      terbit: true,
      isi:
          'Kamar yang gelap, sejuk, dan tenang membantu tubuh masuk ke fase tidur. Kurangi cahaya layar dan jauhkan sumber suara yang mengganggu.',
    ),
    const ArtikelKelola(
      id: 4,
      judul: 'Panduan pernapasan 4–7–8',
      kategori: 'Relaksasi',
      terbit: false,
      isi:
          'Langkah singkat pernapasan sebelum tidur: tarik napas empat hitungan, tahan tujuh hitungan, lalu embuskan perlahan delapan hitungan.',
    ),
    const ArtikelKelola(
      id: 5,
      judul: 'Layar dan kebiasaan sebelum tidur',
      kategori: 'Kebiasaan',
      terbit: false,
      isi:
          'Cahaya layar di malam hari dapat menunda rasa kantuk. Coba hentikan layar sekitar satu jam sebelum tidur dan ganti dengan kegiatan yang menenangkan.',
    ),
  ];

  List<ArtikelKelola> get semua => List.unmodifiable(_daftar);

  int get _terbitSekarang => _daftar.where((a) => a.terbit).length;
  int get _drafSekarang => _daftar.length - _terbitSekarang;

  /// Jumlah artikel terbit di seluruh sistem (angka dasar + perubahan di daftar).
  int get jumlahTerbit => _dasarTerbit - _contohTerbit + _terbitSekarang;

  /// Jumlah draf di seluruh sistem.
  int get jumlahDraf => _dasarDraf - _contohDraf + _drafSekarang;

  /// [status]: 'Semua', 'Terbit', atau 'Draf'.
  List<ArtikelKelola> cari({String status = 'Semua'}) {
    return _daftar.where((a) {
      if (status == 'Terbit') return a.terbit;
      if (status == 'Draf') return !a.terbit;
      return true;
    }).toList();
  }

  ArtikelKelola? ambil(int id) {
    final i = _daftar.indexWhere((a) => a.id == id);
    return i < 0 ? null : _daftar[i];
  }

  /// Tambah artikel baru (id null) atau perbarui yang sudah ada.
  /// Artikel baru ditaruh paling atas. Mengembalikan artikel yang tersimpan.
  ArtikelKelola simpan({
    int? id,
    required String judul,
    required String kategoriArtikel,
    required String isi,
    required bool terbit,
  }) {
    if (id != null) {
      final i = _daftar.indexWhere((a) => a.id == id);
      if (i >= 0) {
        _daftar[i] = _daftar[i].salinDengan(
          judul: judul,
          kategori: kategoriArtikel,
          isi: isi,
          terbit: terbit,
        );
        notifyListeners();
        return _daftar[i];
      }
    }
    final baru = ArtikelKelola(
      id: _idBerikut++,
      judul: judul,
      kategori: kategoriArtikel,
      isi: isi,
      terbit: terbit,
    );
    _daftar.insert(0, baru);
    notifyListeners();
    return baru;
  }

  void hapus(int id) {
    _daftar.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
