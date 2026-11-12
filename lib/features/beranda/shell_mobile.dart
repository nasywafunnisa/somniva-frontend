import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/halaman_segera.dart';
import '../analisis/score_mobile_page.dart';
import '../jurnal/jurnal_tidur_isi.dart';
import 'dashboard_mobile.dart';

class _TabHp {
  final String nama;
  final IconData ikon;
  const _TabHp(this.nama, this.ikon);
}

/// Kerangka HP setelah login: isi halaman + tab navigasi di bawah.
class ShellMobile extends StatefulWidget {
  const ShellMobile({super.key});

  @override
  State<ShellMobile> createState() => _ShellMobileState();
}

class _ShellMobileState extends State<ShellMobile> {
  int _terpilih = 0;

  static const List<_TabHp> _tab = [
    _TabHp('Beranda', Icons.home_outlined),
    _TabHp('Jurnal', Icons.description_outlined),
    _TabHp('Analisis', Icons.bar_chart_rounded),
    _TabHp('Program', Icons.check_rounded),
    _TabHp('Profil', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: _isiTab(),
          ),
        ),
      ),
      bottomNavigationBar: _navigasi(),
    );
  }

  Widget _isiTab() {
    switch (_terpilih) {
      case 0:
        return DashboardMobile(
          onCatat: () => setState(() => _terpilih = 1),
          onLihatSkor: () => setState(() => _terpilih = 2),
        );
      case 1:
        // Setelah simpan, langsung lihat Sleep Score (tab Analisis).
        return JurnalTidurIsi(
          setelahSimpan: () => setState(() => _terpilih = 2),
        );
      case 2:
        return ScoreMobilePage(
          onKembali: () => setState(() => _terpilih = 0),
        );
      default:
        return HalamanSegera(judul: _tab[_terpilih].nama);
    }
  }

  Widget _navigasi() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFEADC))),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Row(
              children: List.generate(_tab.length, (i) {
                final aktif = i == _terpilih;
                final t = _tab[i];
                final warna =
                    aktif ? AppColors.hijauGelap : AppColors.teksSekunder;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _terpilih = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(t.ikon, size: 26, color: warna),
                          const SizedBox(height: 4),
                          Text(
                            t.nama,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight:
                                  aktif ? FontWeight.w800 : FontWeight.w500,
                              color: warna,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
