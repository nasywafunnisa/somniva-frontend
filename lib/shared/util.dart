import 'package:flutter/material.dart';

/// Pesan singkat untuk fitur yang belum dibuat.
void tampilkanSegera(BuildContext context, String fitur) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$fitur akan dibuat di langkah berikutnya.'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Pemilih jam 24 jam, bahasa Indonesia untuk tombolnya.
Future<TimeOfDay?> pilihJam(
  BuildContext context,
  TimeOfDay awal, {
  String judul = 'Pilih jam',
}) {
  return showTimePicker(
    context: context,
    initialTime: awal,
    helpText: judul,
    cancelText: 'Batal',
    confirmText: 'Pilih',
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
}
