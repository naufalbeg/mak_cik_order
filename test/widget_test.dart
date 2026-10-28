import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mak_cik_order/screens/splash_screen.dart';

void main() {
  testWidgets('Game logo renders the title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: GameLogo()))));
    expect(find.text('Mak Cik, Order!'), findsWidgets);
    expect(find.text('Jelajah Rasa Malaysia'), findsOneWidget);
  });
}
