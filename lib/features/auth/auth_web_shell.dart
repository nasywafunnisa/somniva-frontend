import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/store_tema.dart';
import '../../shared/logo_somniva.dart';

// =============================================================================
// Kerangka Login / Register Somniva (split screen dengan panel melengkung).
//
// Layar lebar (>= 900 px): panel hijau melengkung bergeser antara kiri dan
// kanan saat pindah Masuk <-> Daftar. Bentuk lengkungnya ikut berubah, isi
// panel dan formulir bertukar dengan fade + geser halus.
// Layar sempit: LoginPage / RegisterPage memakai satu kolom dan komponen
// AuthHeaderMelengkung + PeralihanAuth di bawah.
// =============================================================================

/// Isi satu sisi formulir di tampilan web: judul, subjudul, dan form-nya.
class IsiAuth {
  final String judul;
  final String subjudul;
  final Widget form;

  const IsiAuth({
    required this.judul,
    required this.subjudul,
    required this.form,
  });
}

/// Teks di panel hijau untuk satu mode (Masuk atau Daftar).
class _DataPanel {
  final String judul;
  final String deskripsi;
  final List<String> poin;
  final String ajakan;
  final String tombolAjakan;

  const _DataPanel({
    required this.judul,
    required this.deskripsi,
    required this.poin,
    required this.ajakan,
    required this.tombolAjakan,
  });
}

const _DataPanel _panelMasuk = _DataPanel(
  judul: 'Kenali pola tidurmu,\nperbaiki kebiasaannya.',
  deskripsi:
      'Catat kebiasaan harian, lihat hubungannya dengan kualitas tidur, lalu ikuti program 14 hari yang terarah.',
  poin: [
    'Sleep Score dan Sleep Debt yang mudah dibaca',
    'Analisis hubungan kafein, stres, dan layar',
    'Rekomendasi waktu tidur yang personal',
  ],
  ajakan: 'Belum punya akun?',
  tombolAjakan: 'Daftar',
);

const _DataPanel _panelDaftar = _DataPanel(
  judul: 'Mulai tidur lebih\ntenang malam ini.',
  deskripsi:
      'Buat akun dalam satu menit. Tentukan target tidurmu dan biarkan Somniva menyusun langkah kecil yang mudah diikuti.',
  poin: [
    'Gratis dan tanpa data kesehatan yang rumit',
    'Program 14 hari dengan tugas ringan tiap hari',
    'Data tidurmu tetap milikmu, bisa dihapus kapan saja',
  ],
  ajakan: 'Sudah punya akun?',
  tombolAjakan: 'Masuk',
);

double _batas(double v, double a, double b) => v < a ? a : (v > b ? b : v);

// =============================================================================
// Kerangka web
// =============================================================================

/// Kerangka halaman Masuk/Daftar untuk tampilan WEB (layar lebar).
/// Dipakai LoginPage (tabAwal 0) dan RegisterPage (tabAwal 1).
/// Pindah tab terjadi di sini dengan animasi, tanpa membuka halaman baru,
/// sehingga isian di kedua form tidak hilang.
class AuthWebShell extends StatefulWidget {
  /// 0 = Masuk, 1 = Daftar.
  final int tabAwal;
  final IsiAuth isiMasuk;
  final IsiAuth isiDaftar;

  const AuthWebShell({
    super.key,
    required this.tabAwal,
    required this.isiMasuk,
    required this.isiDaftar,
  });

  @override
  State<AuthWebShell> createState() => _AuthWebShellState();
}

class _AuthWebShellState extends State<AuthWebShell>
    with SingleTickerProviderStateMixin {
  // Nilai 0 = layout Masuk (panel di kiri), 1 = layout Daftar (panel di kanan).
  late final AnimationController _gerak;
  late int _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.tabAwal;
    _gerak = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      value: _tab.toDouble(),
    );
  }

  @override
  void dispose() {
    _gerak.dispose();
    super.dispose();
  }

  void _pindah(int tujuan) {
    if (tujuan == _tab) return;
    _tab = tujuan;
    _gerak.animateTo(tujuan.toDouble(), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final paneMasuk = _KontenPane(
      isi: widget.isiMasuk,
      gerak: _gerak,
      onPilih: _pindah,
    );
    final paneDaftar = _KontenPane(
      isi: widget.isiDaftar,
      gerak: _gerak,
      onPilih: _pindah,
    );

    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;
          final lebarPanel = w * 0.5;
          final lebarForm = w - lebarPanel;

          return AnimatedBuilder(
            animation: _gerak,
            builder: (context, _) {
              final p = _gerak.value.clamp(0.0, 1.0);
              final kiriPanel = p * (w - lebarPanel);

              // Form Masuk menghilang di paruh awal, form Daftar muncul di
              // paruh akhir, supaya tidak saling tumpang tindih.
              final tampilMasuk = 1 - _batas((p - 0.10) / 0.35, 0, 1);
              final tampilDaftar = _batas((p - 0.55) / 0.35, 0, 1);

              return Stack(
                children: [
                  // Form Masuk: sisi kanan.
                  Positioned(
                    left: lebarPanel,
                    top: 0,
                    width: lebarForm,
                    height: h,
                    child: _LapisanForm(
                      terlihat: tampilMasuk,
                      geser: p * 40,
                      child: paneMasuk,
                    ),
                  ),
                  // Form Daftar: sisi kiri.
                  Positioned(
                    left: 0,
                    top: 0,
                    width: lebarForm,
                    height: h,
                    child: _LapisanForm(
                      terlihat: tampilDaftar,
                      geser: -(1 - p) * 40,
                      child: paneDaftar,
                    ),
                  ),
                  // Panel hijau melengkung (di atas kedua form).
                  Positioned(
                    left: kiriPanel,
                    top: 0,
                    width: lebarPanel,
                    height: h,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _PainterPanel(p),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _LapisanPanel(
                                terlihat: 1 - _batas(p / 0.40, 0, 1),
                                lengkungDiKanan: true,
                                data: _panelMasuk,
                                onAjakan: () => _pindah(1),
                              ),
                            ),
                            Positioned.fill(
                              child: _LapisanPanel(
                                terlihat: _batas((p - 0.60) / 0.40, 0, 1),
                                lengkungDiKanan: false,
                                data: _panelDaftar,
                                onAjakan: () => _pindah(0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Membungkus form: atur transparansi + geser, dan matikan sentuhan/fokus
/// kalau sedang tidak terlihat.
class _LapisanForm extends StatelessWidget {
  final double terlihat; // 0 sampai 1
  final double geser;
  final Widget child;

  const _LapisanForm({
    required this.terlihat,
    required this.geser,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final aktif = terlihat >= 0.5;
    return IgnorePointer(
      ignoring: !aktif,
      child: ExcludeFocus(
        excluding: !aktif,
        child: ExcludeSemantics(
          excluding: !aktif,
          child: Opacity(
            opacity: terlihat,
            child: Transform.translate(
              offset: Offset(geser, 0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Isi sisi formulir: tombol gelap/terang, tab Masuk|Daftar, judul, form.
class _KontenPane extends StatelessWidget {
  final IsiAuth isi;
  final Animation<double> gerak;
  final ValueChanged<int> onPilih;

  const _KontenPane({
    required this.isi,
    required this.gerak,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: AppColors.krim,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: StoreTema.instance.balik,
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.dark_mode_outlined,
                        size: 20,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _TabAuth(gerak: gerak, onPilih: onPilih),
              const SizedBox(height: 24),
              Text(
                isi.judul,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isi.subjudul,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              const SizedBox(height: 20),
              isi.form,
            ],
          ),
        ),
      ),
    );
  }
}

/// Tab Masuk | Daftar. Pil hijau bergeser mengikuti animasi panel.
class _TabAuth extends StatelessWidget {
  final Animation<double> gerak;
  final ValueChanged<int> onPilih;

  const _TabAuth({required this.gerak, required this.onPilih});

  Widget _item(String teks, int nomor, double p) {
    // Teks aktif putih, tidak aktif hijau gelap; berganti mengikuti p.
    final seberapaAktif = nomor == 0 ? 1 - p : p;
    final warna = Color.lerp(
      AppColors.hijauGelap,
      Colors.white,
      seberapaAktif,
    )!;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onPilih(nomor),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          child: Text(
            teks,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: warna,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.krim,
        borderRadius: BorderRadius.circular(26),
      ),
      child: AnimatedBuilder(
        animation: gerak,
        builder: (context, _) {
          final p = gerak.value.clamp(0.0, 1.0);
          return Stack(
            children: [
              Align(
                alignment: Alignment(-1 + 2 * p, 0),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.hijauTua,
                      borderRadius: BorderRadius.circular(21),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _item('Masuk', 0, p),
                  _item('Daftar', 1, p),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// =============================================================================
// Panel hijau melengkung
// =============================================================================

/// Menggambar bentuk panel. [p] = 0: panel di kiri, sisi kanannya melengkung.
/// [p] = 1: panel di kanan, sisi kirinya melengkung. Di antaranya bentuk
/// lengkungnya berubah perlahan dari satu sisi ke sisi lain.
class _PainterPanel extends CustomPainter {
  final double p;
  const _PainterPanel(this.p);

  static const List<Offset> _bintang = [
    Offset(0.18, 0.20),
    Offset(0.42, 0.12),
    Offset(0.62, 0.30),
    Offset(0.30, 0.52),
    Offset(0.70, 0.62),
    Offset(0.12, 0.74),
    Offset(0.52, 0.84),
  ];

  @override
  void paint(Canvas canvas, Size s) {
    final kotak = Offset.zero & s;
    final rx = math.min(s.width * 0.30, 230.0);
    final ry = s.height / 2;
    Radius radius(double f) => Radius.elliptical(rx * f, ry * f);

    final bentuk = RRect.fromRectAndCorners(
      kotak,
      topLeft: radius(p),
      bottomLeft: radius(p),
      topRight: radius(1 - p),
      bottomRight: radius(1 - p),
    );
    final jalur = Path()..addRRect(bentuk);

    canvas.drawShadow(jalur, const Color(0x55000000), 16, false);
    canvas.drawPath(
      jalur,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.hijauTua, AppColors.hijauGelap],
        ).createShader(kotak),
    );

    // Hiasan lembut, dipotong mengikuti bentuk panel.
    canvas.save();
    canvas.clipPath(jalur);

    final lingkaran = Paint()..color = AppColors.hijauPastel.withAlpha(24);
    canvas.drawCircle(
        Offset(s.width * 0.88, s.height * 0.10), s.width * 0.34, lingkaran);
    canvas.drawCircle(
        Offset(s.width * 0.08, s.height * 0.96), s.width * 0.30, lingkaran);
    canvas.drawCircle(
      Offset(s.width * 0.50, s.height * 0.52),
      s.width * 0.58,
      Paint()..color = AppColors.hijauPastel.withAlpha(10),
    );

    final titik = Paint()..color = AppColors.krimTerang.withAlpha(120);
    for (final b in _bintang) {
      canvas.drawCircle(Offset(b.dx * s.width, b.dy * s.height), 1.8, titik);
    }

    canvas.drawPath(
      bulanSabit(Offset(s.width * 0.80, s.height * 0.16), s.width * 0.04),
      Paint()..color = AppColors.krimTerang.withAlpha(190),
    );

    // Dua gelombang tipis di bagian bawah.
    for (var i = 0; i < 2; i++) {
      final garis = Path();
      final dasar = s.height * (0.90 + i * 0.035);
      garis.moveTo(0, dasar);
      for (double x = 0; x <= s.width; x += 6) {
        final y = dasar +
            math.sin(x / s.width * math.pi * 3 + i * 1.4) * s.height * 0.012;
        garis.lineTo(x, y);
      }
      canvas.drawPath(
        garis,
        Paint()
          ..color = AppColors.hijauPastel.withAlpha(i == 0 ? 60 : 36)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PainterPanel lama) => lama.p != p;
}

/// Satu lapis isi panel (Masuk atau Daftar). Dua lapis ditumpuk dan
/// diganti dengan fade selagi panel bergeser.
class _LapisanPanel extends StatelessWidget {
  final double terlihat;
  final bool lengkungDiKanan;
  final _DataPanel data;
  final VoidCallback onAjakan;

  const _LapisanPanel({
    required this.terlihat,
    required this.lengkungDiKanan,
    required this.data,
    required this.onAjakan,
  });

  @override
  Widget build(BuildContext context) {
    final aktif = terlihat >= 0.5;
    return IgnorePointer(
      ignoring: !aktif,
      child: ExcludeSemantics(
        excluding: !aktif,
        child: Opacity(
          opacity: terlihat,
          child: LayoutBuilder(
            builder: (context, box) {
              final rx = math.min(box.maxWidth * 0.30, 230.0);
              final dasar = _batas(box.maxWidth * 0.09, 28, 56);
              final tambah = rx * 0.35; // jauhkan teks dari sisi melengkung
              final kiri = lengkungDiKanan ? dasar : dasar + tambah;
              final kanan = lengkungDiKanan ? dasar + tambah : dasar;
              final lebarIsi = math.max(160.0, box.maxWidth - kiri - kanan);
              final ukuranJudul = _batas(box.maxWidth * 0.075, 30, 52);

              return Padding(
                padding: EdgeInsets.fromLTRB(kiri, 44, kanan, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _MerekPanel(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: lebarIsi,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.judul,
                                  style: TextStyle(
                                    fontSize: ukuranJudul,
                                    fontWeight: FontWeight.w800,
                                    height: 1.12,
                                    letterSpacing: -1,
                                    color: AppColors.krimTerang,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  data.deskripsi,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500,
                                    height: 1.55,
                                    color: AppColors.hijauPastel,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                for (final t in data.poin) _PoinPanel(t),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MerekPanel extends StatelessWidget {
  const _MerekPanel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.nightlight_round, size: 26, color: AppColors.krimTerang),
        SizedBox(width: 12),
        Text(
          'Somniva',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.krimTerang,
          ),
        ),
      ],
    );
  }
}

class _PoinPanel extends StatelessWidget {
  final String teks;
  const _PoinPanel(this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: AppColors.hijauPastel.withAlpha(60),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 14,
              color: AppColors.krimTerang,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teks,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: AppColors.krimTerang,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Komponen untuk tampilan HP / tablet portrait (satu kolom)
// =============================================================================

/// Header hijau dengan tepi bawah melengkung untuk Login/Register di HP.
/// [onKembali] opsional: kalau diisi, muncul tombol kembali di kiri atas.
class AuthHeaderMelengkung extends StatelessWidget {
  final double tinggi;
  final VoidCallback? onKembali;

  const AuthHeaderMelengkung({super.key, this.tinggi = 150, this.onKembali});

  @override
  Widget build(BuildContext context) {
    final atas = MediaQuery.paddingOf(context).top;
    return ClipPath(
      clipper: const _LengkungBawah(),
      child: Container(
        width: double.infinity,
        height: tinggi + atas,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.hijauTua, AppColors.hijauGelap],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _HiasanHeader())),
            Padding(
              padding: EdgeInsets.fromLTRB(22, atas + 14, 22, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (onKembali != null)
                    Material(
                      color: AppColors.hijauPastel.withAlpha(48),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: onKembali,
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: AppColors.krimTerang,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  const Row(
                    children: [
                      Icon(Icons.nightlight_round,
                          size: 24, color: AppColors.krimTerang),
                      SizedBox(width: 10),
                      Text(
                        'Somniva',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: AppColors.krimTerang,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LengkungBawah extends CustomClipper<Path> {
  const _LengkungBawah();

  @override
  Path getClip(Size s) {
    return Path()
      ..lineTo(0, s.height - 34)
      ..quadraticBezierTo(s.width / 2, s.height + 26, s.width, s.height - 34)
      ..lineTo(s.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _HiasanHeader extends CustomPainter {
  const _HiasanHeader();

  @override
  void paint(Canvas canvas, Size s) {
    final lingkaran = Paint()..color = AppColors.hijauPastel.withAlpha(26);
    canvas.drawCircle(
        Offset(s.width * 0.92, s.height * 0.18), s.height * 0.55, lingkaran);
    canvas.drawCircle(
        Offset(s.width * 0.62, s.height * 0.95), s.height * 0.38, lingkaran);
    canvas.drawPath(
      bulanSabit(Offset(s.width * 0.84, s.height * 0.30), 15),
      Paint()..color = AppColors.krimTerang.withAlpha(200),
    );
    final titik = Paint()..color = AppColors.krimTerang.withAlpha(120);
    canvas.drawCircle(Offset(s.width * 0.70, s.height * 0.22), 1.8, titik);
    canvas.drawCircle(Offset(s.width * 0.93, s.height * 0.55), 1.8, titik);
    canvas.drawCircle(Offset(s.width * 0.55, s.height * 0.40), 1.5, titik);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Transisi halaman Masuk <-> Daftar di HP: fade + geser halus.
class PeralihanAuth {
  PeralihanAuth._();

  static Route<T> rute<T>(Widget halaman, {bool dariKanan = true}) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => halaman,
      transitionsBuilder: (_, animasi, __, anak) {
        final kurva = CurvedAnimation(
          parent: animasi,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: kurva,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(dariKanan ? 0.12 : -0.12, 0),
              end: Offset.zero,
            ).animate(kurva),
            child: anak,
          ),
        );
      },
    );
  }
}
