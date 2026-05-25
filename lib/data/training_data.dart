import 'package:flutter/material.dart';
import '../models/exercise.dart';

const List<Exercise> todayExercises = [
  Exercise(
    id: 'swim_400_easy',
    name: '400m Natación suave',
    sets: '1 bloque',
    videoUrl: 'https://www.youtube.com/watch?v=uiI6Z_0Q2Io',
  ),
  Exercise(
    id: 'kick_board',
    name: 'Patada con tabla',
    sets: '4 x 25m',
    videoUrl: 'https://www.youtube.com/watch?v=lYGVECC5e0Q',
  ),
  Exercise(
    id: 'pull_buoy',
    name: 'Pull buoy',
    sets: '4 x 50m',
    videoUrl: 'https://www.youtube.com/watch?v=693m5NQk9RM',
  ),
  Exercise(
    id: 'face_pull',
    name: 'Face Pull',
    sets: '3 x 15',
    videoUrl: 'https://www.youtube.com/watch?v=eIq5CB9JfKE',
  ),
  Exercise(
    id: 'dead_bug',
    name: 'Dead Bug',
    sets: '3 x 10',
    videoUrl: 'https://www.youtube.com/watch?v=g_BYB0R-4Ws',
  ),
  Exercise(
    id: 'hollow_hold',
    name: 'Hollow Hold',
    sets: '3 x 30 segundos',
    videoUrl: 'https://www.youtube.com/watch?v=LlDNef_Ztsc',
  ),
];

const List<TrainingDay> weeklyPlan = [
  TrainingDay(day: 'Lunes', workout: 'Core + movilidad + hombro', iconKey: 'gym'),
  TrainingDay(day: 'Martes', workout: 'Natación técnica', iconKey: 'pool'),
  TrainingDay(day: 'Miércoles', workout: 'Pierna + bici', iconKey: 'bike'),
  TrainingDay(day: 'Jueves', workout: 'Natación resistencia', iconKey: 'water'),
  TrainingDay(day: 'Viernes', workout: 'Full body + core', iconKey: 'gymnastics'),
  TrainingDay(day: 'Sábado', workout: 'Tirada larga bici + carrera corta', iconKey: 'bike'),
  TrainingDay(day: 'Domingo', workout: 'Tenis', iconKey: 'tennis'),
];

IconData iconFor(String key) {
  switch (key) {
    case 'pool':
      return Icons.pool;
    case 'bike':
      return Icons.directions_bike;
    case 'water':
      return Icons.water;
    case 'gymnastics':
      return Icons.sports_gymnastics;
    case 'tennis':
      return Icons.sports_tennis;
    case 'gym':
    default:
      return Icons.fitness_center;
  }
}
