import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../shared/halaman_segera.dart';
import '../../shared/logo_somniva.dart';
import '../auth/login_page.dart';
import '../../core/nav_app.dart';
import '../analisis/grafik_riwayat_web.dart';
import '../analisis/pola_web.dart';
import '../edukasi/edukasi_web.dart';
import '../ekspor/ekspor_web.dart';
import '../profil/profil_web.dart';
import '../../core/store_profil.dart';
import '../rekomendasi/rekomendasi_web.dart';
import '../program/program_web.dart';
import '../analisis/score_debt_web.dart';
import 'dashboard_web.dart';

class _MenuWeb {
  final String nama;
  final IconData ikon;
  const _MenuWeb(this.nama, this.ikon);
}

/// Kerangka WEB setelah login: sidebar kiri + isi halaman di kanan.
class ShellWeb extends StatefulWidget {
  const ShellWeb({super.key});

  @override
  State<ShellWeb> createState() => _ShellWebState();
}

class _ShellWebState extends State<ShellWeb> {
  int _terpilih = 0;

  @override
  void initState() {
    super.initState();
    NavApp.menuWeb.addListener(_dariLuar);
  }

  @override
  void dispose() {
    NavApp.menuWeb.removeListener(_dariLuar);
    super.dispose();
  }

  void _dariLuar() {
    final v = NavApp.menuWeb.value;
    if (v == null) return;
    NavApp.menuWeb.value = null;
    if (mounted) setState(() => _terpilih = v);
  }

  static const List<_MenuWeb> _menu = [
    _MenuWeb('Dashboard', Icons.home_outlined),
    _MenuWeb('Score & Debt', Icons.schedule_rounded),
    _MenuWeb('Pola & Korelasi', Icons.show_chart_rounded),
    _MenuWeb('Grafik & Riwayat', Icons.bar_chart_rounded),
    _MenuWeb('Rekomendasi Tidur', Icons.nightlight_outlined),
    _MenuWeb('Program 14 Hari', Icons.check_rounded),
    _MenuWeb('Edukasi', Icons.menu_book_outlined),
    _MenuWeb('Ekspor Laporan', Icons.file_download_outlined),
    _MenuWeb('Profil & Privasi', Icons.shield_outlined),
  ];

  void _keluar() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: Row(
        children: [
          _sidebar(),
          Expanded(
            child: _isi(),
          ),
        ],
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
        return gulir(
          DashboardWeb(onPindah: (i) => setState(() => _terpilih = i)),
        );
      case 1:
        return gulir(const ScoreDebtWeb());
      case 2:
        return gulir(const PolaWeb());
      case 3:
        return gulir(const GrafikRiwayatWeb());
      case 4:
        return gulir(const RekomendasiWeb());
      case 5:
        return gulir(const ProgramWeb());
      case 6:
        return gulir(const EdukasiWeb());
      case 7:
        return gulir(const EksporWeb());
      case 8:
        return gulir(const ProfilWeb());
      default:
        return HalamanSegera(judul: _menu[_terpilih].nama);
    }
  }

  Widget _sidebar() {
    return Container(
      width: 252,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Row(
              children: [
                IkonBulan(ukuran: 34),
                SizedBox(width: 12),
                Text(
                  'Somniva',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView.separated(
              itemCount: _menu.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, i) => _itemMenu(i),
            ),
          ),
          _kartuPengguna(),
        ],
      ),
    );
  }

  Widget _itemMenu(int i) {
    final aktif = i == _terpilih;
    final m = _menu[i];
    return Material(
      color: aktif ? AppColors.hijauPastel : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _terpilih = i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(
                m.ikon,
                size: 21,
                color: aktif ? AppColors.hijauGelap : AppColors.teksSekunder,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  m.nama,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: aktif ? FontWeight.w700 : FontWeight.w500,
                    color:
                        aktif ? AppColors.hijauGelap : AppColors.teksSekunder,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kartuPengguna() {
    return ListenableBuilder(
      listenable: StoreProfil.instance,
      builder: (context, _) => _isiKartuPengguna(),
    );
  }

  Widget _isiKartuPengguna() {
    return Material(
      color: AppColors.krim,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.hijauPastel,
                shape: BoxShape.circle,
              ),
              child: Text(
                DataContoh.namaDepan.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DataContoh.namaLengkap,
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
  }
}
