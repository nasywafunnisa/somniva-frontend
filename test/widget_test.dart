import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:somniva/main.dart';

void main() {
  testWidgets('SomnivaApp berhasil ditampilkan', (WidgetTester tester) async {
    await tester.pumpWidget(const SomnivaApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
