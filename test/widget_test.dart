import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/calculator.dart';

void main() {
  testWidgets('Calculator shows keypad', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CalculatorHomeScreen()));

    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('0'), findsWidgets);
    expect(find.text('='), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '7'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, '⌫'));
    await tester.pump();

    expect(find.text('0'), findsWidgets);
  });
}
