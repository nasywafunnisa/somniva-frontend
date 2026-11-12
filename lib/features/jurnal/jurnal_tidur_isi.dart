import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/entri_tidur.dart';
import '../../core/format_tanggal.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../../shared/util.dart';

/// Isi halaman Jurnal Tidur (desain: Mobile App UI 04).
/// Dipakai di tab Jurnal (HP) dan halaman "Catat tidur" (web).
class JurnalTidurIsi extends StatefulWidget {
  /// Dipanggil setelah jurnal disimpan.
  final VoidCallback? setelahSimpan;
  const JurnalTidurIsi({super.key, this.setelahSimpan});

  @override
  State<JurnalTidurIsi> createState() => _JurnalTidurIsiState();
}

class _JurnalTidurIsiState extends State<JurnalTidurIsi> {
  late EntriTidur _e;

  static const List<String> _suasana = ['Cemas', 'Biasa', 'Tenang', 'Semangat'];

  @override
  void initState() {
    super.initState();
    _e = StoreTidur.instance.entri;
  }

  Future<void> _ubahTidur() async {
    final h = await pilihJam(context, _e.tidur, judul: 'Waktu tidur');
    if (h != null) setState(() => _e = _e.salin(tidur: h));
  }

  Future<void> _ubahBangun() async {
    final h = await pilihJam(context, _e.bangun, judul: 'Waktu bangun');
    if (h != null) setState(() => _e = _e.salin(bangun: h));
  }

  Future<void> _ubahKafeinJam() async {
    if (_e.kafein == 0) return;
    final h = await pilihJam(context, _e.kafeinTerakhir,
        judul: 'Kafein terakhir diminum');
    if (h != null) setState(() => _e = _e.salin(kafeinTerakhir: h));
  }

  Future<void> _ubahGadget() async {
    var nilai = _e.gadgetMenit.toDouble();
    final hasil = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialog) {
            return AlertDialog(
              backgroundColor: AppColors.krimTerang,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              title: const Text(
                'Layar sebelum tidur',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    EntriTidur.formatDurasi(nilai.round()),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SliderTheme(
                    data: _temaSlider(context),
                    child: Slider(
                      value: nilai,
                      min: 0,
                      max: 240,
                      divisions: 24,
                      onChanged: (v) => setDialog(() => nilai = v),
                    ),
                  ),
                  const Text(
                    'Geser untuk mengatur lama memakai HP atau layar lain satu jam sebelum tidur.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, nilai.round()),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.hijauTua,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (hasil != null) setState(() => _e = _e.salin(gadgetMenit: hasil));
  }

  SliderThemeData _temaSlider(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      trackHeight: 8,
      activeTrackColor: AppColors.hijauSedang,
      inactiveTrackColor: AppColors.hijauMuda,
      thumbColor: AppColors.hijauTua,
      overlayColor: const Color(0x3374836A),
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    );
  }

  void _simpan() {
    StoreTidur.instance.simpan(_e);
    final skor = StoreTidur.instance.skor;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Jurnal tersimpan. Sleep Score kamu ${FormatTanggal.labelSkor(skor).toLowerCase()}: $skor.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    widget.setelahSimpan?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Isi bisa digulir, tombol Simpan menempel di bawah.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  FormatTanggal.panjang(DateTime.now(), tahun: false),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Jurnal Tidur',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _kartuJam(
                        'Waktu tidur',
                        EntriTidur.formatJam(_e.tidur),
                        _ubahTidur,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _kartuJam(
                        'Waktu bangun',
                        EntriTidur.formatJam(_e.bangun),
                        _ubahBangun,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Lama tidur ${_e.durasiTeks}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _kartuSuasana(context),
                const SizedBox(height: 14),
                _kartuKebiasaan(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
          child: TombolUtama(
            teks: 'Simpan & lihat Sleep Score',
            onTap: _simpan,
          ),
        ),
      ],
    );
  }

  Widget _kartuJam(String label, String nilai, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: KartuSomniva(
          radius: 26,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                nilai,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kartuSuasana(BuildContext context) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Suasana hati',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _suasana.map((s) {
              final aktif = s == _e.suasana;
              return GestureDetector(
                onTap: () => setState(() => _e = _e.salin(suasana: s)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: aktif ? AppColors.hijauTua : AppColors.krim,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: aktif ? Colors.white : AppColors.hijauGelap,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tingkat stres',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text(
                '${_e.stres} dari 5',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: _temaSlider(context),
            child: Slider(
              value: _e.stres.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (v) => setState(() => _e = _e.salin(stres: v.round())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuKebiasaan() {
    final adaKafein = _e.kafein > 0;
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        children: [
          // Kafein
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kafein', style: _gayaJudul),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: _ubahKafeinJam,
                      child: Text(
                        adaKafein
                            ? '${_e.kafein} cangkir · terakhir ${EntriTidur.formatJam(_e.kafeinTerakhir)}'
                            : 'Tidak minum kafein',
                        style: _gayaKet,
                      ),
                    ),
                  ],
                ),
              ),
              _tombolKotak(Icons.remove, () {
                if (_e.kafein > 0) {
                  setState(() => _e = _e.salin(kafein: _e.kafein - 1));
                }
              }),
              const SizedBox(width: 12),
              _tombolKotak(Icons.add, () {
                if (_e.kafein < 8) {
                  setState(() => _e = _e.salin(kafein: _e.kafein + 1));
                }
              }),
            ],
          ),
          const SizedBox(height: 20),
          // Aktivitas fisik
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Aktivitas fisik', style: _gayaJudul),
                    const SizedBox(height: 2),
                    Text(
                      _e.aktif ? 'Bergerak ≥ 30 menit' : 'Belum bergerak hari ini',
                      style: _gayaKet,
                    ),
                  ],
                ),
              ),
              _pil(
                _e.aktif ? 'Ya' : 'Tidak',
                aktif: _e.aktif,
                onTap: () => setState(() => _e = _e.salin(aktif: !_e.aktif)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Gadget
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gadget sebelum tidur', style: _gayaJudul),
                    const SizedBox(height: 2),
                    Text(
                      '${EntriTidur.formatDurasi(_e.gadgetMenit)} layar',
                      style: _gayaKet,
                    ),
                  ],
                ),
              ),
              _pil('Ubah', aktif: false, onTap: _ubahGadget),
            ],
          ),
        ],
      ),
    );
  }

  static const TextStyle _gayaJudul = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.hijauGelap,
  );
  static const TextStyle _gayaKet = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: AppColors.teksSekunder,
  );

  Widget _tombolKotak(IconData ikon, VoidCallback onTap) {
    return Material(
      color: AppColors.krim,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Icon(ikon, size: 22, color: AppColors.hijauGelap),
        ),
      ),
    );
  }

  Widget _pil(String teks, {required bool aktif, required VoidCallback onTap}) {
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 76),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          alignment: Alignment.center,
          child: Text(
            teks,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: aktif ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}
