import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_admin.dart';
import '../../shared/halaman_segera.dart';
import '../../shared/logo_somniva.dart';
import 'artikel/artikel_admin.dart';
import 'auth/login_admin_page.dart';
import 'dashboard/dashboard_admin.dart';
import 'pengaturan/pengaturan_admin.dart';
import 'pengguna/pengguna_admin.dart';
import 'program/program_admin.dart';

class _MenuAdmin {
  final String nama;
  final IconData ikon;
  const _MenuAdmin(this.nama, this.ikon);
}

/// Kerangka WEB ADMIN setelah login: sidebar kiri + isi halaman di kanan.
/// Pola sama dengan ShellWeb milik pengguna.
class ShellAdmin extends StatefulWidget {
  const ShellAdmin({super.key});

  @override
  State<ShellAdmin> createState() => _ShellAdminState();
}

class _ShellAdminState extends State<ShellAdmin> {
  int _terpilih = 0;

  /// Sidebar melebar (true) atau ramping (false). Pilihan pengguna.
  bool _lebar = true;

  /// Di bawah lebar layar ini sidebar otomatis ramping.
  static const double _batasOtomatis = 1100;
  static const double _lebarTerbuka = 252;
  static const double _lebarRamping = 84;

  static const List<_MenuAdmin> _menu = [
    _MenuAdmin('Dashboard', Icons.home_outlined),
    _MenuAdmin('Pengguna', Icons.people_outline_rounded),
    _MenuAdmin('Artikel & Edukasi', Icons.article_outlined),
    _MenuAdmin('Program Tidur', Icons.check_rounded),
    _MenuAdmin('Pengaturan', Icons.tune_rounded),
  ];

  void _keluar() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginAdminPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: LayoutBuilder(
        builder: (context, box) {
          final bolehToggle = box.maxWidth >= _batasOtomatis;
          final lebar = _lebar && bolehToggle;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sidebar(lebar, bolehToggle),
              Expanded(child: _isi()),
            ],
          );
        },
      ),
    );
  }

  Widget _isi() {
    Widget gulir(Widget anak) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 36, 40, 40),
          child: anak,
        );

    switch (_terpilih) {
      case 0:
        return gulir(const DashboardAdmin());
      case 1:
        return gulir(const PenggunaAdmin());
      case 2:
        return gulir(const ArtikelAdmin());
      case 3:
        return gulir(const ProgramAdmin());
      case 4:
        return gulir(const PengaturanAdmin());
      default:
        // Halaman lain dibuat di langkah berikutnya.
        return HalamanSegera(judul: _menu[_terpilih].nama);
    }
  }

  /// Sidebar mengambang: jarak dari tepi layar, sudut membulat,
  /// dan bisa melebar / meramping dengan animasi.
  Widget _sidebar(bool lebar, bool bolehToggle) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      width: lebar ? _lebarTerbuka : _lebarRamping,
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      padding: const EdgeInsets.fromLTRB(12, 22, 12, 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFEFEADC), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x142F3A2B),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x0A2F3A2B),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          // Teks baru ditampilkan setelah sidebar cukup lebar,
          // supaya tidak overflow di tengah animasi.
          final teks = box.maxWidth > 150;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _kepala(teks, lebar, bolehToggle),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _menu.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, i) => _itemMenu(i, teks),
                ),
              ),
              const SizedBox(height: 10),
              _kartuAdmin(teks),
            ],
          );
        },
      ),
    );
  }

  Widget _kepala(bool teks, bool lebar, bool bolehToggle) {
    final tombol = bolehToggle
        ? Tooltip(
            message: lebar ? 'Perkecil sidebar' : 'Perlebar sidebar',
            waitDuration: const Duration(milliseconds: 250),
            child: Material(
              color: AppColors.krim,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                hoverColor: AppColors.hijauMuda,
                onTap: () => setState(() => _lebar = !_lebar),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    lebar
                        ? Icons.keyboard_double_arrow_left_rounded
                        : Icons.keyboard_double_arrow_right_rounded,
                    size: 20,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    if (!teks) {
      return Column(
        children: [
          const Center(child: IkonBulan(ukuran: 34)),
          if (bolehToggle) const SizedBox(height: 12),
          tombol,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 4),
            const IkonBulan(ukuran: 34),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Somniva',
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
            tombol,
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.krim,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Admin',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemMenu(int i, bool teks) {
    final aktif = i == _terpilih;
    final m = _menu[i];
    final bening = AppColors.hijauPastel.withAlpha(0);

    final isi = Material(
      color: aktif ? AppColors.hijauPastel : bening,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        hoverColor: aktif ? bening : AppColors.hijauMuda,
        splashColor: AppColors.hijauPastel.withAlpha(120),
        highlightColor: bening,
        focusColor: bening,
        onTap: () => setState(() => _terpilih = i),
        child: SizedBox(
          height: 48,
          child: Stack(
            children: [
              // Penanda menu aktif: batang kecil di tepi kiri.
              Positioned(
                left: 0,
                top: 13,
                bottom: 13,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: aktif ? 4 : 0,
                  decoration: const BoxDecoration(
                    color: AppColors.hijauTua,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  // Ikon selalu di posisi yang sama (tengah saat ramping).
                  padding: const EdgeInsets.only(left: 19),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        m.ikon,
                        size: 21,
                        color: aktif
                            ? AppColors.hijauGelap
                            : AppColors.teksSekunder,
                      ),
                      if (teks) ...[
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            m.nama,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight:
                                  aktif ? FontWeight.w700 : FontWeight.w500,
                              color: aktif
                                  ? AppColors.hijauGelap
                                  : AppColors.teksSekunder,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (teks) return isi;
    return Tooltip(
      message: m.nama,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 250),
      child: isi,
    );
  }

  Widget _avatar() {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.hijauPastel,
        shape: BoxShape.circle,
      ),
      child: Text(
        StoreAdmin.instance.inisial,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.hijauGelap,
        ),
      ),
    );
  }

  Widget _kartuAdmin(bool teks) {
    return ListenableBuilder(
      listenable: StoreAdmin.instance,
      builder: (context, _) {
        if (!teks) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: StoreAdmin.instance.nama,
                preferBelow: false,
                waitDuration: const Duration(milliseconds: 250),
                child: Center(child: _avatar()),
              ),
              const SizedBox(height: 8),
              Tooltip(
                message: 'Keluar',
                preferBelow: false,
                waitDuration: const Duration(milliseconds: 250),
                child: Material(
                  color: AppColors.krim,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    hoverColor: AppColors.hijauMuda,
                    onTap: _keluar,
                    child: const SizedBox(
                      width: 40,
                      height: 36,
                      child: Icon(
                        Icons.logout_rounded,
                        size: 19,
                        color: AppColors.teksSekunder,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Material(
          color: AppColors.krim,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _avatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StoreAdmin.instance.nama,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                      GestureDetector(
                        onTap: _keluar,
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.teksSekunder,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
