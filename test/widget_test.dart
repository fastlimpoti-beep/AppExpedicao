// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app_separacao/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tela inicial carrega com sucesso', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    // Exemplo: Verifica se existe um título específico ou widget principal
    expect(find.text('Salve'), findsOneWidget);

    // Exemplo: Verifica se existe um botão esperado na tela inicial
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
