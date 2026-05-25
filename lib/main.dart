import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const SwimStrengthAI());
}

class SwimStrengthAI extends StatelessWidget {
  const SwimStrengthAI({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwimStrength AI',
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardThemeData(
          color: Colors.grey[900],
          elevation: 2,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
