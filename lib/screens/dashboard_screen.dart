import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/training_data.dart';
import '../services/storage_service.dart';
import 'analytics_screen.dart';
import 'garmin_screen.dart';
import 'recovery_screen.dart';
import 'training_screen.dart';
import 'weekly_plan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  StorageService? _store;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final s = await StorageService.create();
    if (!mounted) return;
    setState(() => _store = s);
  }

  Future<void> _setReadiness(int v) async {
    await _store!.setReadiness(DateTime.now(), v);
    setState(() {});
  }

  Future<void> _push(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_store == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final now = DateTime.now();
    final todayWorkout = workoutFor(now.weekday);
    final doneToday = _store!.getDone(now);
    final readiness = _store!.getReadiness(now) ?? 7;
    final stats = _store!.weekStats(now, weeklyWorkouts);
    final dateLabel = DateFormat("EEEE d 'de' MMMM", 'es').format(now);

    return Scaffold(
      appBar: AppBar(title: const Text('SwimStrength AI')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(
                'Preparación Triatlón',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                dateLabel,
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 20),

              // Today card
              _TodayCard(
                workout: todayWorkout,
                doneCount: doneToday
                    .where(
                      (id) => todayWorkout.exercises.any((e) => e.id == id),
                    )
                    .length,
                onTap: () => _push(const TrainingScreen()),
              ),

              const SizedBox(height: 16),

              // Weekly stats
              _StatsCard(
                completed: stats.completed,
                expected: stats.expected,
                exercises: stats.exercises,
              ),

              const SizedBox(height: 16),

              // Readiness slider
              _ReadinessCard(value: readiness, onChanged: _setReadiness),

              const SizedBox(height: 24),

              const Text(
                'Secciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              _NavTile(
                title: 'Plan Semanal',
                subtitle: 'Lunes - Domingo',
                icon: Icons.calendar_month,
                color: Colors.blue,
                onTap: () => _push(const WeeklyPlanScreen()),
              ),
              _NavTile(
                title: 'Recovery',
                subtitle: 'Movilidad + sueño',
                icon: Icons.favorite,
                color: Colors.pink,
                onTap: () => _push(const RecoveryScreen()),
              ),
              _NavTile(
                title: 'Garmin Analytics',
                subtitle: 'Resumen métricas',
                icon: Icons.analytics,
                color: Colors.green,
                onTap: () => _push(const AnalyticsScreen()),
              ),
              _NavTile(
                title: 'Garmin Upload',
                subtitle: 'Subir capturas Garmin',
                icon: Icons.cloud_upload,
                color: Colors.purple,
                onTap: () => _push(const GarminScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.workout,
    required this.doneCount,
    required this.onTap,
  });
  final dynamic workout;
  final int doneCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = workout.exercises.length;
    final progress = total == 0 ? 0.0 : doneCount / total;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.orange.shade900,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.orange,
                    child: Icon(iconFor(workout.iconKey), color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Entrenamiento de hoy',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        Text(
                          workout.focus,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$doneCount de $total ejercicios',
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.completed,
    required this.expected,
    required this.exercises,
  });
  final int completed;
  final int expected;
  final int exercises;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Esta semana',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Metric(label: 'Sesiones', value: '$completed/$expected'),
                _Metric(label: 'Ejercicios', value: '$exercises'),
                _Metric(label: 'Carga', value: _loadLabel(exercises)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _loadLabel(int n) {
    if (n == 0) return '—';
    if (n < 10) return 'Baja';
    if (n < 25) return 'Media';
    if (n < 40) return 'Alta';
    return 'Muy alta';
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  Color _color() {
    if (value <= 3) return Colors.redAccent;
    if (value <= 6) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  String _label() {
    if (value <= 3) return 'Bajo — descansa';
    if (value <= 6) return 'Medio';
    return 'Listo para entrenar';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Readiness',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '$value/10',
                  style: TextStyle(
                    color: _color(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: _color(),
              label: '$value',
              onChanged: (v) => onChanged(v.round()),
            ),
            Text(_label(), style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
