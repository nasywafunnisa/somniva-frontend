import 'package:flutter/material.dart';

/// Tiga lingkaran pusat: terluar tetap, dua di dalamnya ikut membesar/mengecil.
/// [ukuran] 0 = paling kecil, 1 = paling besar.
class LingkaranNapas extends StatelessWidget {
  final double ukuran;
  final String label;
  final int? angka; // null = tidak ditampilkan (mis. saat selesai)

  const LingkaranNapas({
    super.key,
    required this.ukuran,
    required this.label,
    this.angka,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final d = box.maxWidth < 250 ? box.maxWidth : 250.0; // garis tengah terluar
        final tengah = d * (0.72 + 0.10 * ukuran);
        final dalam = d * (0.52 + 0.14 * ukuran);
        return SizedBox(
          width: d,
          height: d,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _bulat(d, const Color(0xFFE6EBDF)),
              _bulat(tengah, const Color(0xFFC9D4C0)),
              Container(
                width: dalam,
                height: dalam,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF56654D),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (angka != null)
                        Text(
                          '$angka',
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bulat(double d, Color warna) {
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
    );
  }
}
