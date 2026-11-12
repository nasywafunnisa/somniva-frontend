import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Kartu bersudut bulat dengan bayangan lembut (dipakai di Dashboard).
class KartuSomniva extends StatelessWidget {
  final Widget child;
  final Color warna;
  final double radius;
  final EdgeInsets padding;

  const KartuSomniva({
    super.key,
    required this.child,
    this.warna = Colors.white,
    this.radius = 24,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFEFEADC), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x142F3A2B),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
