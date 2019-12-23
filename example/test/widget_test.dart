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
    var helloFinder = find.text('Olá');

    expect(titleFinder, findsOneWidget);
    expect(helloFinder, findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));

    await tester.pumpAndSettle();

    titleFinder = find.text('Home Page');
    helloFinder = find.text('Hello');

    expect(titleFinder, findsOneWidget);
    expect(helloFinder, findsOneWidget);
  });
}
