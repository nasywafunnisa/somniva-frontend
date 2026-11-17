/// Gerak lingkaran: membesar (naik), tetap besar, mengecil (turun), tetap kecil.
enum Gerak { naik, besar, turun, kecil }

/// Satu fase dalam satu siklus latihan.
class FaseLatihan {
  final String label;
  final int detik;
  final Gerak gerak;
  const FaseLatihan(this.label, this.detik, this.gerak);
}

/// Satu jenis latihan. Fasenya diulang terus sampai [menit] habis.
/// Panduannya sederhana dan bersifat edukatif, bukan terapi medis.
class LatihanRelaksasi {
  final String nama;
  final String ket; // teks di daftar "Latihan lain"
  final int menit;
  final List<FaseLatihan> fase;

  /// true hanya untuk 4–7–8: selesai = langkah Wind-Down ke-4 ikut tercentang.
  final bool napas478;

  const LatihanRelaksasi({
    required this.nama,
    required this.ket,
    required this.menit,
    required this.fase,
    this.napas478 = false,
  });

  int get totalDetik => menit * 60;

  int get panjangSiklus {
    var total = 0;
    for (final f in fase) {
      total += f.detik;
    }
    return total;
  }

  static const List<LatihanRelaksasi> daftar = [
    LatihanRelaksasi(
      nama: 'Pernapasan 4–7–8',
      ket: '5 menit · pemula',
      menit: 5,
      napas478: true,
      fase: [
        FaseLatihan('Tarik napas', 4, Gerak.naik),
        FaseLatihan('Tahan napas', 7, Gerak.besar),
        FaseLatihan('Buang napas', 8, Gerak.turun),
      ],
    ),
    LatihanRelaksasi(
      nama: 'Pernapasan kotak',
      ket: '4 menit · pemula',
      menit: 4,
      fase: [
        FaseLatihan('Tarik napas', 4, Gerak.naik),
        FaseLatihan('Tahan napas', 4, Gerak.besar),
        FaseLatihan('Buang napas', 4, Gerak.turun),
        FaseLatihan('Tahan napas', 4, Gerak.kecil),
      ],
    ),
    LatihanRelaksasi(
      nama: 'Relaksasi otot progresif',
      ket: '10 menit · berbaring',
      menit: 10,
      fase: [
        FaseLatihan('Tegangkan otot', 5, Gerak.naik),
        FaseLatihan('Lepaskan perlahan', 10, Gerak.turun),
      ],
    ),
    LatihanRelaksasi(
      nama: 'Pemindaian tubuh',
      ket: '8 menit · berbaring',
      menit: 8,
      fase: [
        FaseLatihan('Rasakan tubuhmu', 8, Gerak.naik),
        FaseLatihan('Lepaskan ketegangan', 8, Gerak.turun),
      ],
    ),
  ];
}
