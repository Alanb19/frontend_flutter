import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/training_data.dart';
import '../models/exercise.dart';
import '../services/storage_service.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key, this.date});

  /// If null, uses today's date.
  final DateTime? date;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late DateTime _date;
  late WorkoutDay _workout;
  StorageService? _store;
  Set<String> _done = {};

  @override
  void initState() {
    super.initState();
    _date = widget.date ?? DateTime.now();
    _workout = workoutFor(_date.weekday);
    _init();
  }

  Future<void> _init() async {
    final s = await StorageService.create();
    if (!mounted) return;
    setState(() {
      _store = s;
      _done = s.getDone(_date);
    });
  }

  Future<void> _toggle(String id, bool? value) async {
    final v = value ?? false;
    setState(() {
      if (v) {
        _done.add(id);
      } else {
        _done.remove(id);
      }
    });
    await _store?.toggleDone(_date, id, v);
  }

  Future<void> _resetAll() async {
    setState(_done.clear);
    await _store?.setDone(_date, _done);
  }

  Future<void> _openVideo(String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_store == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final exercises = _workout.exercises;
    final total = exercises.length;
    final done = _done.where((id) => exercises.any((e) => e.id == id)).length;
    final progress = total == 0 ? 0.0 : done / total;
    final dateLabel = DateFormat("EEEE d 'de' MMMM", 'es').format(_date);

    return Scaffold(
      appBar: AppBar(
        title: Text(_workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar día',
            onPressed: _resetAll,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateLabel,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _workout.focus,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('$done de $total ejercicios completados'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final Exercise ex = exercises[index];
                    final isDone = _done.contains(ex.id);
                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isDone,
                              onChanged: (v) => _toggle(ex.id, v),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ex.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isDone
                                          ? Colors.grey[500]
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ex.sets,
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => _openVideo(ex.videoUrl),
                                    child: const Text(
                                      '▶ Ver técnica',
                                      style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
