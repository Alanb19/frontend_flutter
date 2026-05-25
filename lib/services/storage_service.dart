import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise.dart';

class StorageService {
  static const String _kDonePrefix = 'done_v2:';      // done_v2:YYYY-MM-DD = [ids]
  static const String _kReadinessPrefix = 'ready_v1:';// ready_v1:YYYY-MM-DD = int
  static const String _kGarminList = 'garmin_v1';
  static const int garminMax = 25;

  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  static String dateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  // ─── Done exercises per date ───
  Set<String> getDone(DateTime d) {
    final list = _prefs.getStringList(_kDonePrefix + dateKey(d)) ?? const [];
    return list.toSet();
  }

  Future<void> setDone(DateTime d, Set<String> ids) async {
    await _prefs.setStringList(_kDonePrefix + dateKey(d), ids.toList());
  }

  Future<void> toggleDone(DateTime d, String id, bool value) async {
    final s = getDone(d);
    if (value) {
      s.add(id);
    } else {
      s.remove(id);
    }
    await setDone(d, s);
  }

  // ─── Readiness 1-10 per date ───
  int? getReadiness(DateTime d) =>
      _prefs.getInt(_kReadinessPrefix + dateKey(d));

  Future<void> setReadiness(DateTime d, int value) async {
    await _prefs.setInt(_kReadinessPrefix + dateKey(d), value);
  }

  // ─── Weekly stats ───
  /// Returns (sessionsCompletedCount, totalSessionsExpected) for week containing [anchor].
  /// A session counts as "completed" if at least one exercise done that day.
  ({int completed, int expected, int exercises}) weekStats(
    DateTime anchor,
    List<WorkoutDay> weekly,
  ) {
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    int completed = 0;
    int exercises = 0;
    for (int i = 0; i < 7; i++) {
      final d = DateTime(monday.year, monday.month, monday.day + i);
      final done = getDone(d);
      if (done.isNotEmpty) completed++;
      exercises += done.length;
    }
    return (completed: completed, expected: weekly.length, exercises: exercises);
  }

  // ─── Garmin screenshots ───
  List<GarminScreenshot> getGarmin() {
    final raw = _prefs.getString(_kGarminList);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => GarminScreenshot.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addGarmin(GarminScreenshot shot) async {
    final list = getGarmin()..insert(0, shot);
    if (list.length > garminMax) {
      list.removeRange(garminMax, list.length);
    }
    final encoded = jsonEncode(list.map((s) => s.toJson()).toList());
    await _prefs.setString(_kGarminList, encoded);
  }

  Future<void> deleteGarmin(String id) async {
    final list = getGarmin()..removeWhere((s) => s.id == id);
    final encoded = jsonEncode(list.map((s) => s.toJson()).toList());
    await _prefs.setString(_kGarminList, encoded);
  }
}
