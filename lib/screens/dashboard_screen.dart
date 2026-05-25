import 'package:flutter/material.dart';

import 'training_screen.dart';
import 'recovery_screen.dart';
import 'analytics_screen.dart';
import 'weekly_plan_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subtitle, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwimStrength AI')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                'Preparación Triatlón',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('700m swim • 40km bike • 10km run'),
              const SizedBox(height: 30),
              _buildCard(
                context,
                'Entrenamiento de Hoy',
                'Tu rutina del día',
                Icons.fitness_center,
                Colors.orange,
                const TrainingScreen(),
              ),
              _buildCard(
                context,
                'Plan Semanal',
                'Rutina completa',
                Icons.calendar_month,
                Colors.blue,
                const WeeklyPlanScreen(),
              ),
              _buildCard(
                context,
                'Recovery',
                'Movilidad + sueño',
                Icons.favorite,
                Colors.pink,
                const RecoveryScreen(),
              ),
              _buildCard(
                context,
                'Garmin Analytics',
                'Feedback manual',
                Icons.analytics,
                Colors.green,
                const AnalyticsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
