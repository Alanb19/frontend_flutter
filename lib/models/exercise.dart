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

class TrainingDay {
  final String day;
  final String workout;
  final String iconKey;

  const TrainingDay({
    required this.day,
    required this.workout,
    required this.iconKey,
  });
}
