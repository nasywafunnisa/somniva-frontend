import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/rekomendasi.dart';
import '../../core/store_pengingat.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/saklar_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../../shared/util.dart';

/// Pengingat Jadwal Tidur untuk HP (desain: Mobile App UI 14).
/// Dibuka dari Wind-Down Routine ("Atur pengingat wind-down").
/// Perubahan baru tersimpan setelah menekan "Simpan pengingat".
class PengingatPage extends StatefulWidget {
  const PengingatPage({super.key});

  @override
  State<PengingatPage> createState() => _PengingatPageState();
}

class _PengingatPageState extends State<PengingatPage> {
  static const List<String> _namaHari = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];

  late int _tidur;
  late int _bangun;
  late bool _windDown;
  late bool _pengingatTidur;
  late bool _alarm;
  late List<bool> _hari;

  @override
  void initState() {
    super.initState();
    final s = StorePengingat.instance;
    _tidur = s.tidurMenit;
    _bangun = s.bangunMenit;
    _windDown = s.windDownAktif;
    _pengingatTidur = s.tidurAktif;
    _alarm = s.alarmAktif;
    _hari = s.hari;
  }

  Future<void> _ubahJam(bool untukTidur) async {
    final awal = untukTidur ? _tidur : _bangun;
    final dipilih = await pilihJam(
      context,
      TimeOfDay(hour: awal ~/ 60, minute: awal % 60),
      judul: untukTidur ? 'Waktu tidur' : 'Waktu bangun',
    );
    if (dipilih == null || !mounted) return;
    final menit = dipilih.hour * 60 + dipilih.minute;
    setState(() {
      if (untukTidur) {
        _tidur = menit;
      } else {
        _bangun = menit;
      }
    });
  }

  void _simpan() {
    StorePengingat.instance.simpan(
      tidur: _tidur,
      bangun: _bangun,
      windDown: _windDown,
      pengingatTidur: _pengingatTidur,
      alarm: _alarm,
      hari: _hari,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Pengingat disimpan. Notifikasi di HP dibuat di tahap berikutnya.',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  String get _awalan => _hari.every((e) => e) ? 'Setiap hari' : 'Hari aktif';

  String get _ketHari {
    final n = _hari.where((e) => e).length;
    if (n == 7) return 'Semua hari aktif.';
    if (n == 0) return 'Belum ada hari aktif, pengingat tidak akan berbunyi.';
    const kerja = [true, true, true, true, true, false, false];
    var samaDenganKerja = true;
    for (var i = 0; i < 7; i++) {
      if (_hari[i] != kerja[i]) samaDenganKerja = false;
    }
    if (samaDenganKerja) {
      return 'Senin–Jumat aktif. Akhir pekan memakai jadwal fleksibel.';
    }
    final nama = [
      for (var i = 0; i < 7; i++)
        if (_hari[i]) _namaHari[i],
    ];
    return 'Aktif: ${nama.join(', ')}.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _kepala(),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: _kartuJam('Waktu tidur', _tidur, true)),
                            const SizedBox(width: 14),
                            Expanded(child: _kartuJam('Waktu bangun', _bangun, false)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _barisSaklar(
                          'Pengingat wind-down',
                          '$_awalan pukul ${Rekomendasi.jam(Rekomendasi.windDown(_tidur))}',
                          _windDown,
                          (v) => setState(() => _windDown = v),
                        ),
                        const SizedBox(height: 12),
                        _barisSaklar(
                          'Pengingat tidur',
                          '$_awalan pukul ${Rekomendasi.jam(_tidur)}',
                          _pengingatTidur,
                          (v) => setState(() => _pengingatTidur = v),
                        ),
                        const SizedBox(height: 12),
                        _barisSaklar(
                          'Alarm bangun',
                          '$_awalan pukul ${Rekomendasi.jam(_bangun)}',
                          _alarm,
                          (v) => setState(() => _alarm = v),
                        ),
                        const SizedBox(height: 14),
                        _kartuHari(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                  child: TombolUtama(teks: 'Simpan pengingat', onTap: _simpan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kepala() {
    return Row(
      children: [
        Material(
          color: AppColors.krim,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox(
              width: 46,
              height: 46,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Pengingat Jadwal Tidur',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
        ),
      ],
    );
  }

  Widget _kartuJam(String label, int menit, bool untukTidur) {
    return GestureDetector(
      onTap: () => _ubahJam(untukTidur),
      child: KartuSomniva(
        warna: AppColors.krim,
        radius: 26,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Rekomendasi.jam(menit),
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.5,
                color: AppColors.hijauGelap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisSaklar(
    String judul,
    String ket,
    bool nilai,
    ValueChanged<bool> onUbah,
  ) {
    return KartuSomniva(
      radius: 26,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ket,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SaklarSomniva(nilai: nilai, onUbah: onUbah),
        ],
      ),
    );
  }

  Widget _kartuHari() {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hari aktif',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(child: _chipHari(i)),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _ketHari,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipHari(int i) {
    final aktif = _hari[i];
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _hari[i] = !_hari[i]),
        child: SizedBox(
          height: 40,
          child: Center(
            child: Text(
              _namaHari[i],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: aktif ? Colors.white : AppColors.teksSekunder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
