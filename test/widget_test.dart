import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend_flutter/main.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es', null);
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App boots and shows app title', (WidgetTester tester) async {
    await tester.pumpWidget(const SwimStrengthAI());
    // Allow async init (SharedPreferences) to complete.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('SwimStrength AI'), findsOneWidget);
  });
}
