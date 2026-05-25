import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_flutter/main.dart';

void main() {
  testWidgets('Dashboard renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const SwimStrengthAI());
    await tester.pumpAndSettle();

    expect(find.text('SwimStrength AI'), findsOneWidget);
    expect(find.text('Preparación Triatlón'), findsOneWidget);
    expect(find.text('Entrenamiento de Hoy'), findsOneWidget);
  });
}
