import 'package:shared_preferences/shared_preferences.dart';
import '../models/wellness_model.dart';
import 'base_repository.dart';

class WaterRepository extends BaseRepository<WaterLogModel> {
  static const String _key = 'water_logs';

  WaterRepository(SharedPreferences prefs) : super(_key, prefs);

  @override
  Map<String, dynamic> toJson(WaterLogModel item) => item.toJson();

  @override
  WaterLogModel fromJson(Map<String, dynamic> json) =>
      WaterLogModel.fromJson(json);

  @override
  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // Water-specific methods
  Future<List<WaterLogModel>> getLogsByDate(DateTime date) async {
    final logs = await getAll();
    return logs.where((log) {
      return log.timestamp.year == date.year &&
          log.timestamp.month == date.month &&
          log.timestamp.day == date.day;
    }).toList();
  }

  Future<List<WaterLogModel>> getLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await getAll();
    return logs.where((log) {
      return log.timestamp.isAfter(start) && log.timestamp.isBefore(end);
    }).toList();
  }

  Future<int> getTotalWaterToday() async {
    final todayLogs = await getLogsByDate(DateTime.now());
    return todayLogs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  Future<int> getTotalWaterByDate(DateTime date) async {
    final dateLogs = await getLogsByDate(date);
    return dateLogs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  Future<Map<DateTime, int>> getWeeklyWaterIntake() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final Map<DateTime, int> weeklyData = {};

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final total = await getTotalWaterByDate(date);
      weeklyData[date] = total;
    }

    return weeklyData;
  }

  Future<void> addWater(int amountMl, {String? notes}) async {
    final log = WaterLogModel(
      id: generateId(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      notes: notes,
    );
    await save(log);
  }
}

class SleepRepository extends BaseRepository<SleepLogModel> {
  static const String _key = 'sleep_logs';

  SleepRepository(SharedPreferences prefs) : super(_key, prefs);

  @override
  Map<String, dynamic> toJson(SleepLogModel item) => item.toJson();

  @override
  SleepLogModel fromJson(Map<String, dynamic> json) =>
      SleepLogModel.fromJson(json);

  @override
  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // Sleep-specific methods
  Future<List<SleepLogModel>> getLogsByDate(DateTime date) async {
    final logs = await getAll();
    return logs.where((log) {
      return log.bedtime.year == date.year &&
          log.bedtime.month == date.month &&
          log.bedtime.day == date.day;
    }).toList();
  }

  Future<List<SleepLogModel>> getLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await getAll();
    return logs.where((log) {
      return log.bedtime.isAfter(start) && log.bedtime.isBefore(end);
    }).toList();
  }

  Future<List<SleepLogModel>> getRecentLogs({int limit = 5}) async {
    final logs = await getAll();
    logs.sort((a, b) => b.bedtime.compareTo(a.bedtime));
    return logs.take(limit).toList();
  }

  Future<SleepLogModel?> getLastNightSleep() async {
    final logs = await getAll();
    if (logs.isEmpty) return null;

    logs.sort((a, b) => b.bedtime.compareTo(a.bedtime));
    return logs.first;
  }

  Future<Duration> getAverageSleepDuration({int days = 7}) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    final logs = await getLogsByDateRange(startDate, now);

    if (logs.isEmpty) return Duration.zero;

    final totalMinutes = logs.fold(
      0,
      (sum, log) => sum + log.duration.inMinutes,
    );
    return Duration(minutes: totalMinutes ~/ logs.length);
  }

  Future<double> getAverageSleepScore({int days = 7}) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    final logs = await getLogsByDateRange(startDate, now);

    if (logs.isEmpty) return 0.0;

    final logsWithScore = logs.where((log) => log.sleepScore != null).toList();
    if (logsWithScore.isEmpty) return 0.0;

    final totalScore = logsWithScore.fold(
      0,
      (sum, log) => sum + (log.sleepScore ?? 0),
    );
    return totalScore / logsWithScore.length;
  }

  Future<Map<DateTime, Duration>> getWeeklySleepDuration() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final Map<DateTime, Duration> weeklyData = {};

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final logs = await getLogsByDate(date);
      final totalDuration = logs.fold(
        Duration.zero,
        (sum, log) => sum + log.duration,
      );
      weeklyData[date] = totalDuration;
    }

    return weeklyData;
  }

  Future<void> logSleep(
    DateTime bedtime,
    DateTime wakeTime,
    SleepQuality quality, {
    String? notes,
    int? sleepScore,
  }) async {
    final duration = wakeTime.difference(bedtime);
    final log = SleepLogModel(
      id: generateId(),
      bedtime: bedtime,
      wakeTime: wakeTime,
      duration: duration,
      quality: quality,
      notes: notes,
      sleepScore: sleepScore,
    );
    await save(log);
  }
}

class NutritionRepository extends BaseRepository<NutritionLogModel> {
  static const String _key = 'nutrition_logs';

  NutritionRepository(SharedPreferences prefs) : super(_key, prefs);

  @override
  Map<String, dynamic> toJson(NutritionLogModel item) => item.toJson();

  @override
  NutritionLogModel fromJson(Map<String, dynamic> json) =>
      NutritionLogModel.fromJson(json);

  @override
  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // Nutrition-specific methods
  Future<List<NutritionLogModel>> getLogsByDate(DateTime date) async {
    final logs = await getAll();
    return logs.where((log) {
      return log.timestamp.year == date.year &&
          log.timestamp.month == date.month &&
          log.timestamp.day == date.day;
    }).toList();
  }

  Future<List<NutritionLogModel>> getLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await getAll();
    return logs.where((log) {
      return log.timestamp.isAfter(start) && log.timestamp.isBefore(end);
    }).toList();
  }

  Future<List<NutritionLogModel>> getLogsByMealType(
    String mealType,
    DateTime date,
  ) async {
    final dateLogs = await getLogsByDate(date);
    return dateLogs.where((log) => log.mealType == mealType).toList();
  }

  Future<Map<String, double>> getDailyNutritionTotals(DateTime date) async {
    final logs = await getLogsByDate(date);

    return {
      'calories': logs.fold(0.0, (sum, log) => sum + log.calories),
      'protein': logs.fold(0.0, (sum, log) => sum + log.protein),
      'carbs': logs.fold(0.0, (sum, log) => sum + log.carbs),
      'fat': logs.fold(0.0, (sum, log) => sum + log.fat),
      'fiber': logs.fold(0.0, (sum, log) => sum + log.fiber),
      'sugar': logs.fold(0.0, (sum, log) => sum + log.sugar),
      'sodium': logs.fold(0.0, (sum, log) => sum + log.sodium),
    };
  }

  Future<Map<String, double>> getWeeklyNutritionAverages() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final logs = await getLogsByDateRange(weekStart, now);

    if (logs.isEmpty) {
      return {
        'calories': 0.0,
        'protein': 0.0,
        'carbs': 0.0,
        'fat': 0.0,
        'fiber': 0.0,
        'sugar': 0.0,
        'sodium': 0.0,
      };
    }

    final totalDays = 7;
    return {
      'calories': logs.fold(0.0, (sum, log) => sum + log.calories) / totalDays,
      'protein': logs.fold(0.0, (sum, log) => sum + log.protein) / totalDays,
      'carbs': logs.fold(0.0, (sum, log) => sum + log.carbs) / totalDays,
      'fat': logs.fold(0.0, (sum, log) => sum + log.fat) / totalDays,
      'fiber': logs.fold(0.0, (sum, log) => sum + log.fiber) / totalDays,
      'sugar': logs.fold(0.0, (sum, log) => sum + log.sugar) / totalDays,
      'sodium': logs.fold(0.0, (sum, log) => sum + log.sodium) / totalDays,
    };
  }

  Future<void> logNutrition({
    required String mealType,
    required String foodName,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    double fiber = 0.0,
    double sugar = 0.0,
    double sodium = 0.0,
    required int quantity,
    String? notes,
  }) async {
    final log = NutritionLogModel(
      id: generateId(),
      timestamp: DateTime.now(),
      mealType: mealType,
      foodName: foodName,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
      quantity: quantity,
      notes: notes,
    );
    await save(log);
  }
}
