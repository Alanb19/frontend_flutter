import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/training_data.dart';
import '../models/exercise.dart';
import '../services/storage_service.dart';
import 'training_screen.dart';

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
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

  DateTime _dateForWeekday(int weekday) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day + (weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    if (_store == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final todayWd = DateTime.now().weekday;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan Semanal')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: weeklyWorkouts.map((w) {
            final date = _dateForWeekday(w.weekday);
            final done = _store!.getDone(date);
            final doneCount = done
                .where((id) => w.exercises.any((e) => e.id == id))
                .length;
            final total = w.exercises.length;
            final progress = total == 0 ? 0.0 : doneCount / total;
            final isToday = w.weekday == todayWd;
            return _DayCard(
              workout: w,
              progress: progress,
              doneCount: doneCount,
              total: total,
              isToday: isToday,
              dateLabel: DateFormat('d MMM', 'es').format(date),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainingScreen(date: date),
                  ),
                );
                if (mounted) setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.workout,
    required this.progress,
    required this.doneCount,
    required this.total,
    required this.isToday,
    required this.dateLabel,
    required this.onTap,
  });
  final WorkoutDay workout;
  final double progress;
  final int doneCount;
  final int total;
  final bool isToday;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isToday ? Colors.orange.shade900 : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                iconFor(workout.iconKey),
                size: 36,
                color: isToday ? Colors.white : Colors.orange,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'HOY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Colors.white70 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(workout.focus),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$doneCount/$total ejercicios',
                      style: TextStyle(
                        fontSize: 12,
                        color: isToday ? Colors.white70 : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
