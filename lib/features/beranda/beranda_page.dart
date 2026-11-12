import 'package:flutter/material.dart';
import 'shell_mobile.dart';
import 'shell_web.dart';

/// Halaman utama setelah login.
/// Layar lebar -> kerangka web (sidebar). Layar sempit -> kerangka HP (tab bawah).
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  static const double _batasWeb = 900;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= _batasWeb) return const ShellWeb();
        return const ShellMobile();
      },
    );
  }
}
