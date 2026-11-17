import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/store_program.dart';
import '../../core/store_tema.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/ring_skor.dart';
import '../../shared/saklar_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../profil/bagian_profil.dart';

/// Tampilan (Mode Gelap) untuk HP (desain: Mobile App UI 19).
/// Pilihan langsung terlihat sebagai pratinjau. "Simpan tampilan" menyimpannya;
/// keluar tanpa menyimpan mengembalikan tampilan sebelumnya.
class TampilanPage extends StatefulWidget {
  const TampilanPage({super.key});

  @override
  State<TampilanPage> createState() => _TampilanPageState();
}

class _TampilanPageState extends State<TampilanPage> {
  bool _disimpan = false;

  @override
  void dispose() {
    if (!_disimpan) {
      // Ditunda sampai frame selesai supaya tidak mengubah tampilan
      // saat pohon widget sedang dibongkar.
      WidgetsBinding.instance
          .addPostFrameCallback((_) => StoreTema.instance.batalkan());
    }
    super.dispose();
  }

  void _simpan() {
    StoreTema.instance.simpan();
    _disimpan = true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Tampilan disimpan.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListenableBuilder(
              listenable: StoreTema.instance,
              builder: (context, _) => _isi(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _isi(BuildContext context) {
    final t = StoreTema.instance;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    TombolKembaliKotak(),
                    SizedBox(width: 16),
                    Text(
                      'Tampilan',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _pilihan('Terang', PilihanTema.terang, t),
                    const SizedBox(width: 12),
                    _pilihan('Gelap', PilihanTema.gelap, t),
                    const SizedBox(width: 12),
                    _pilihan('Sistem', PilihanTema.sistem, t),
                  ],
                ),
                const SizedBox(height: 16),
                _kartuSkor(),
                const SizedBox(height: 14),
                _kartuProgram(),
                const SizedBox(height: 14),
                _kartuOtomatis(t),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Tampilan gelap memakai hijau tua yang lembut agar nyaman dilihat sebelum tidur.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
          child: TombolUtama(teks: 'Simpan tampilan', onTap: _simpan),
        ),
      ],
    );
  }

  Widget _pilihan(String nama, PilihanTema nilai, StoreTema t) {
    final aktif = t.pilihan == nilai;
    return Expanded(
      child: Material(
        color: aktif ? AppColors.hijauTua : AppColors.krim,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: () => StoreTema.instance.pratinjau(pilihan: nilai),
          child: Container(
            height: 76,
            alignment: Alignment.center,
            child: Text(
              nama,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: aktif ? Colors.white : AppColors.hijauGelap,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _kartuSkor() {
    return ListenableBuilder(
      listenable: StoreTidur.instance,
      builder: (context, _) {
        final tidur = StoreTidur.instance;
        final skor = tidur.skor;
        final nilai = skor >= 80 ? 'Baik' : (skor >= 60 ? 'Cukup' : 'Perlu perbaikan');
        return KartuSomniva(
          radius: 30,
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              RingSkor(nilai: skor, ukuran: 104, tebal: 11),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sleep Score',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tidur.entri.durasiTeks} · ${tidur.entri.rentangTeks}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.teksSekunder,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.krim,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        nilai,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _kartuProgram() {
    final p = StoreProgram.instance;
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Program 14 Hari',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
              Text(
                'Hari ${p.hariAktif}',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: p.persen / 100,
              minHeight: 10,
              backgroundColor: AppColors.krim,
              valueColor: const AlwaysStoppedAnimation(AppColors.hijauTua),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuOtomatis(StoreTema t) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Otomatis saat malam',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.hijauGelap,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Aktif ${StoreTema.jamOtomatis}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SaklarSomniva(
            nilai: t.otomatisMalam,
            onUbah: (v) => StoreTema.instance.pratinjau(otomatis: v),
          ),
        ],
      ),
    );
  }
}
