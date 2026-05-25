import 'package:flutter/material.dart';
import '../models/exercise.dart';

const Exercise _eSwim400 = Exercise(
  id: 'swim_400_easy',
  name: '400m Natación suave',
  sets: '1 bloque',
  videoUrl: 'https://www.youtube.com/watch?v=uiI6Z_0Q2Io',
);
const Exercise _eKick = Exercise(
  id: 'kick_board',
  name: 'Patada con tabla',
  sets: '4 x 25m',
  videoUrl: 'https://www.youtube.com/watch?v=lYGVECC5e0Q',
);
const Exercise _ePull = Exercise(
  id: 'pull_buoy',
  name: 'Pull buoy',
  sets: '4 x 50m',
  videoUrl: 'https://www.youtube.com/watch?v=693m5NQk9RM',
);
const Exercise _eFacePull = Exercise(
  id: 'face_pull',
  name: 'Face Pull',
  sets: '3 x 15',
  videoUrl: 'https://www.youtube.com/watch?v=eIq5CB9JfKE',
);
const Exercise _eDeadBug = Exercise(
  id: 'dead_bug',
  name: 'Dead Bug',
  sets: '3 x 10',
  videoUrl: 'https://www.youtube.com/watch?v=g_BYB0R-4Ws',
);
const Exercise _eHollow = Exercise(
  id: 'hollow_hold',
  name: 'Hollow Hold',
  sets: '3 x 30 seg',
  videoUrl: 'https://www.youtube.com/watch?v=LlDNef_Ztsc',
);
const Exercise _eCatCow = Exercise(
  id: 'cat_cow',
  name: 'Cat-Cow',
  sets: '2 x 10',
  videoUrl: 'https://www.youtube.com/watch?v=kqnua4rHVVA',
);
const Exercise _e9090 = Exercise(
  id: 'switch_9090',
  name: '90/90 Switch',
  sets: '2 x 8 lado',
  videoUrl: 'https://www.youtube.com/watch?v=43t_g2GgGYU',
);
const Exercise _eThoracic = Exercise(
  id: 'thoracic_rot',
  name: 'Thoracic Rotation',
  sets: '2 x 8 lado',
  videoUrl: 'https://www.youtube.com/watch?v=2HU6jHHe-jw',
);
const Exercise _eBikeWarm = Exercise(
  id: 'bike_warm',
  name: 'Bici Z2 calentamiento',
  sets: '15 min',
  videoUrl: 'https://www.youtube.com/watch?v=Q5L4yytIIJI',
);
const Exercise _eBikeIntervals = Exercise(
  id: 'bike_intervals',
  name: 'Bici intervalos',
  sets: '4 x 4 min Z4',
  videoUrl: 'https://www.youtube.com/watch?v=Q5L4yytIIJI',
);
const Exercise _eSquat = Exercise(
  id: 'goblet_squat',
  name: 'Goblet Squat',
  sets: '4 x 8',
  videoUrl: 'https://www.youtube.com/watch?v=MeIiIdhvXT4',
);
const Exercise _eDeadlift = Exercise(
  id: 'rdl',
  name: 'Romanian Deadlift',
  sets: '4 x 8',
  videoUrl: 'https://www.youtube.com/watch?v=jEy_czb3RKA',
);
const Exercise _eRun5k = Exercise(
  id: 'run_5k',
  name: 'Carrera 5km Z2',
  sets: '5 km suave',
  videoUrl: 'https://www.youtube.com/watch?v=brFHyOtTwH4',
);
const Exercise _eSwimTech = Exercise(
  id: 'swim_tech_drills',
  name: 'Drills técnica natación',
  sets: '8 x 25m',
  videoUrl: 'https://www.youtube.com/watch?v=GE0qsAycDOQ',
);
const Exercise _eSwim800 = Exercise(
  id: 'swim_800',
  name: '800m continuos',
  sets: '1 bloque',
  videoUrl: 'https://www.youtube.com/watch?v=uiI6Z_0Q2Io',
);
const Exercise _ePushup = Exercise(
  id: 'pushup',
  name: 'Flexiones',
  sets: '3 x max',
  videoUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
);
const Exercise _ePlank = Exercise(
  id: 'plank',
  name: 'Plancha',
  sets: '3 x 45 seg',
  videoUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
);
const Exercise _eFascia = Exercise(
  id: 'fascia_plantar',
  name: 'Fascia plantar (pelota)',
  sets: '2 min cada pie',
  videoUrl: 'https://www.youtube.com/watch?v=4BOTvaRaDjI',
);
const Exercise _eAnkle = Exercise(
  id: 'ankle_mob',
  name: 'Movilidad tobillos',
  sets: '2 x 10',
  videoUrl: 'https://www.youtube.com/watch?v=fbiUVtH7Y9Q',
);
const Exercise _eTennis = Exercise(
  id: 'tennis_match',
  name: 'Partido tenis',
  sets: '60-90 min',
  videoUrl: 'https://www.youtube.com/watch?v=hN8mRT5q4Co',
);

const List<WorkoutDay> _workouts = [
  WorkoutDay(
    weekday: 1,
    name: 'Lunes',
    focus: 'Core + movilidad + hombro',
    iconKey: 'gym',
    exercises: [_eCatCow, _e9090, _eThoracic, _eFacePull, _eDeadBug, _eHollow],
  ),
  WorkoutDay(
    weekday: 2,
    name: 'Martes',
    focus: 'Natación técnica',
    iconKey: 'pool',
    exercises: [_eSwim400, _eSwimTech, _eKick, _ePull],
  ),
  WorkoutDay(
    weekday: 3,
    name: 'Miércoles',
    focus: 'Pierna + bici',
    iconKey: 'bike',
    exercises: [_eBikeWarm, _eBikeIntervals, _eSquat, _eDeadlift],
  ),
  WorkoutDay(
    weekday: 4,
    name: 'Jueves',
    focus: 'Natación resistencia',
    iconKey: 'water',
    exercises: [_eSwim400, _eSwim800, _ePull],
  ),
  WorkoutDay(
    weekday: 5,
    name: 'Viernes',
    focus: 'Full body + core',
    iconKey: 'gymnastics',
    exercises: [_eSquat, _ePushup, _eFacePull, _ePlank, _eHollow],
  ),
  WorkoutDay(
    weekday: 6,
    name: 'Sábado',
    focus: 'Bici larga + carrera corta',
    iconKey: 'bike',
    exercises: [_eBikeWarm, _eBikeIntervals, _eRun5k, _eFascia, _eAnkle],
  ),
  WorkoutDay(
    weekday: 7,
    name: 'Domingo',
    focus: 'Tenis',
    iconKey: 'tennis',
    exercises: [_eTennis, _eFascia, _eAnkle],
  ),
];

List<WorkoutDay> get weeklyWorkouts => _workouts;

WorkoutDay workoutFor(int weekday) =>
    _workouts.firstWhere((w) => w.weekday == weekday);

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
