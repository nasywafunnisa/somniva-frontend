/// Tombol aksi di akhir artikel.
enum AksiArtikel { tidak, latihanNapas, windDown }

class ArtikelTidur {
  final String id;
  final String judul;
  final String kategori;
  final int menit; // lama baca
  final String ringkas;
  final List<String> paragraf;
  final List<String> tips;
  final int nada; // 0,1,2 = warna kotak gambar
  final AksiArtikel aksi;

  const ArtikelTidur({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.menit,
    required this.ringkas,
    required this.paragraf,
    required this.tips,
    this.nada = 0,
    this.aksi = AksiArtikel.tidak,
  });

  String get meta => '$kategori · $menit menit baca';

  static const List<String> kategoriFilter = [
    'Semua',
    'Kebiasaan',
    'Kafein',
    'Kamar',
    'Relaksasi',
  ];

  /// Artikel "Pilihan hari ini" di HP.
  static const String idPilihan = 'rutinitas';

  static ArtikelTidur get pilihan =>
      daftar.firstWhere((a) => a.id == idPilihan);

  /// Mencari berdasarkan kategori dan kata kunci (judul, kategori, ringkasan).
  static List<ArtikelTidur> cari({String kategori = 'Semua', String kata = ''}) {
    final k = kata.trim().toLowerCase();
    return [
      for (final a in daftar)
        if ((kategori == 'Semua' || a.kategori == kategori) &&
            (k.isEmpty ||
                a.judul.toLowerCase().contains(k) ||
                a.kategori.toLowerCase().contains(k) ||
                a.ringkas.toLowerCase().contains(k)))
          a,
    ];
  }

  // Isi artikel bersifat edukatif umum, bukan saran medis.
  static const List<ArtikelTidur> daftar = [
    ArtikelTidur(
      id: 'jam-konsisten',
      judul: 'Mengapa jam tidur yang konsisten penting',
      kategori: 'Kebiasaan',
      menit: 4,
      nada: 0,
      ringkas: 'Tubuhmu punya jam internal yang menyukai keteraturan.',
      paragraf: [
        'Tubuh punya jam internal yang disebut ritme sirkadian. Jam ini mengatur kapan kita merasa mengantuk dan kapan terjaga, dan ia paling nyaman dengan jadwal yang teratur.',
        'Saat jam tidur dan bangun bergeser jauh dari hari ke hari, tubuh seperti berpindah zona waktu setiap akhir pekan. Akibatnya sering terasa sulit tidur di malam Minggu dan berat bangun di Senin pagi.',
        'Kamu tidak perlu sempurna. Selisih kecil, misalnya sekitar 30 menit, umumnya tidak jadi masalah. Yang lebih berpengaruh adalah menjaga jam bangun tetap serupa, termasuk di akhir pekan.',
      ],
      tips: [
        'Pilih jam bangun yang realistis, lalu hitung mundur jam tidurnya. Itu yang dilakukan halaman Rekomendasi Tidur.',
        'Batasi pergeseran jadwal di akhir pekan sekitar 1 jam.',
        'Catat jam tidur dan bangun di Jurnal Tidur supaya polamu terlihat.',
      ],
    ),
    ArtikelTidur(
      id: 'kafein',
      judul: 'Kafein dan tidur: kapan batas terbaik?',
      kategori: 'Kafein',
      menit: 3,
      nada: 1,
      ringkas: 'Kafein bisa bertahan beberapa jam di tubuh.',
      paragraf: [
        'Kafein di kopi, teh, minuman energi, dan sebagian soda bekerja dengan menahan rasa kantuk. Efeknya bisa bertahan beberapa jam setelah diminum, dan lamanya berbeda-beda pada tiap orang.',
        'Pedoman yang umum dipakai: hindari kafein sekitar 6 jam sebelum jam tidur. Kalau kamu cepat terpengaruh, batas yang lebih awal, misalnya sebelum tengah hari, bisa lebih cocok.',
        'Cara paling jitu adalah melihat tubuhmu sendiri. Catat jumlah kafein dan jam terakhir minum, lalu bandingkan dengan Sleep Score di halaman Pola & Korelasi.',
      ],
      tips: [
        'Geser kopi terakhir lebih awal selama seminggu, lalu lihat perubahannya.',
        'Perhatikan sumber kafein yang tidak terasa, seperti teh dan cokelat.',
        'Ganti kopi sore dengan air putih atau teh tanpa kafein.',
      ],
    ),
    ArtikelTidur(
      id: 'kamar',
      judul: 'Menyiapkan kamar yang nyaman untuk tidur',
      kategori: 'Kamar',
      menit: 5,
      nada: 2,
      ringkas: 'Gelap, sejuk, dan tenang membantu tubuh rileks.',
      paragraf: [
        'Kamar yang mendukung tidur biasanya gelap, sejuk, dan tenang. Tubuh membaca cahaya sebagai tanda untuk tetap terjaga, jadi cahaya yang masuk ke kamar sangat berpengaruh.',
        'Tutup tirai atau pakai penutup mata, dan matikan lampu kecil yang terang. Suhu yang sejuk dan sirkulasi udara yang baik juga membantu tubuh rileks.',
        'Usahakan kamar dipakai untuk tidur. Bekerja atau menonton di atas kasur bisa membuat otak mengaitkan tempat tidur dengan aktivitas, bukan istirahat.',
      ],
      tips: [
        'Taruh ponsel di luar jangkauan tangan, atau aktifkan mode jangan ganggu.',
        'Pakai lampu hangat yang redup satu jam sebelum tidur.',
        'Kalau berisik, coba penyumbat telinga atau suara latar yang lembut.',
      ],
    ),
    ArtikelTidur(
      id: 'napas-478',
      judul: 'Pernapasan 4–7–8 untuk rileks',
      kategori: 'Relaksasi',
      menit: 3,
      nada: 0,
      aksi: AksiArtikel.latihanNapas,
      ringkas: 'Latihan napas sederhana sebelum tidur.',
      paragraf: [
        'Pernapasan 4–7–8 adalah latihan sederhana untuk menenangkan diri sebelum tidur. Caranya: tarik napas lewat hidung selama 4 hitungan, tahan 7 hitungan, lalu buang perlahan lewat mulut selama 8 hitungan.',
        'Ulangi beberapa siklus dengan santai. Kalau menahan napas 7 hitungan terasa berat, perpendek hitungannya dengan perbandingan yang sama.',
        'Latihan ini membantu merasa lebih rileks, tetapi bukan pengobatan. Hentikan kalau kamu pusing, dan bicarakan dengan tenaga kesehatan bila sulit tidur berlangsung lama.',
      ],
      tips: [
        'Lakukan sambil berbaring atau duduk bersandar.',
        'Mulai dari 3–4 siklus, lalu tambah pelan-pelan.',
        'Coba langsung di Latihan Relaksasi.',
      ],
    ),
    ArtikelTidur(
      id: idPilihan,
      judul: 'Panduan memulai rutinitas tenang sebelum tidur',
      kategori: 'Relaksasi',
      menit: 4,
      nada: 1,
      aksi: AksiArtikel.windDown,
      ringkas: 'Langkah kecil yang bisa dicoba malam ini.',
      paragraf: [
        'Rutinitas sebelum tidur memberi sinyal pada tubuh bahwa hari sudah selesai. Tidak perlu panjang. Sekitar 30 menit dengan langkah yang sama setiap malam sudah cukup untuk memulai.',
        'Mulailah dari hal paling mudah: kurangi layar, redupkan lampu, dan lakukan satu kegiatan menenangkan seperti minum air hangat atau latihan napas.',
        'Konsistensi lebih penting daripada kesempurnaan. Kalau satu malam terlewat, lanjutkan lagi besoknya tanpa menyalahkan diri.',
      ],
      tips: [
        'Mulai wind-down sekitar 30 menit sebelum jam tidur.',
        'Pilih 3–4 langkah yang benar-benar kamu sukai.',
        'Gunakan Wind-Down Routine di Somniva sebagai daftar centang.',
      ],
    ),
  ];
}
