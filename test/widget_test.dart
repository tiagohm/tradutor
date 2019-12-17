import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app.dart';

void main() {
  testWidgets('Change Language', (tester) async {
    await tester.pumpWidget(const App(
      locale: Locale('pt', 'BR'),
    ));

    await tester.pumpAndSettle();

    var titleFinder = find.text('Página Inicial');
    var messageFinder = find.text('Esta é uma simples mensagem');

    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));

    await tester.pumpAndSettle();

    titleFinder = find.text('Home Page');
    messageFinder = find.text('This is a simple Message');

    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
