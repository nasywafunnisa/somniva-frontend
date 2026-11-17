import 'package:flutter/material.dart';
import '../../core/rekomendasi.dart';
import '../../core/store_pengingat.dart';
import 'pengingat_page.dart';

/// Dipakai tombol "Aktifkan pengingat" di halaman Rekomendasi.
/// Menyimpan jam tidur pilihan ke pengaturan pengingat, lalu memberi tahu.
/// [denganTombolAtur] true (HP) menambah tombol "Atur" ke halaman Pengingat.
void aktifkanPengingatDariRekomendasi(
  BuildContext context,
  int tidurMenit, {
  required bool denganTombolAtur,
}) {
  final store = StorePengingat.instance;
  store.aktifkanDariRekomendasi(tidurMenit);
  final windDown = Rekomendasi.jam(store.windDownMenit);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        'Pengingat wind-down diatur pukul $windDown. Notifikasi sungguhan dibuat di tahap berikutnya.',
      ),
      action: denganTombolAtur
          ? SnackBarAction(
              label: 'Atur',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PengingatPage()),
                );
              },
            )
          : null,
    ),
  );
}
