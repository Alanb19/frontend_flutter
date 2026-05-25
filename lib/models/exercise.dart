class Exercise {
  final String id;
  final String name;
  final String sets;
  final String videoUrl;

  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.videoUrl,
  });
}

class WorkoutDay {
  final int weekday; // 1 = lunes, 7 = domingo (DateTime.weekday)
  final String name;
  final String focus;
  final String iconKey;
  final List<Exercise> exercises;

  const WorkoutDay({
    required this.weekday,
    required this.name,
    required this.focus,
    required this.iconKey,
    required this.exercises,
  });
}

class GarminScreenshot {
  final String id;
  final String dateIso;
  final String label;
  final String base64Jpeg;

  const GarminScreenshot({
    required this.id,
    required this.dateIso,
    required this.label,
    required this.base64Jpeg,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': dateIso,
        'label': label,
        'img': base64Jpeg,
      };

  factory GarminScreenshot.fromJson(Map<String, dynamic> j) => GarminScreenshot(
        id: j['id'] as String,
        dateIso: j['date'] as String,
        label: j['label'] as String? ?? '',
        base64Jpeg: j['img'] as String,
      );
}
