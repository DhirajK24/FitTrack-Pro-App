import 'package:hive/hive.dart';
import '../models/enhanced_sleep_model.dart';
import '../services/hive_storage_service.dart';

class EnhancedSleepRepository {
  Box<EnhancedSleepLogModel>? _logsBox;
  Box<SleepGoalModel>? _goalsBox;

  Future<void> initialize() async {
    _logsBox = await HiveStorageService.getSleepLogsBox();
    _goalsBox = await HiveStorageService.getSleepGoalsBox();
  }

  Future<void> ensureInitialized() async {
    if (_logsBox == null || _goalsBox == null) {
      await initialize();
    }
  }

  // Sleep Logs CRUD
  Future<String> saveSleepLog(EnhancedSleepLogModel log) async {
    await ensureInitialized();
    await _logsBox!.put(log.id, log);
    return log.id;
  }

  Future<EnhancedSleepLogModel?> getSleepLog(String id) async {
    await ensureInitialized();
    return _logsBox!.get(id);
  }

  Future<List<EnhancedSleepLogModel>> getAllSleepLogs() async {
    await ensureInitialized();
    return _logsBox!.values.toList();
  }

  Future<List<EnhancedSleepLogModel>> getSleepLogsByDate(DateTime date) async {
    await ensureInitialized();
    return _logsBox!.values.where((log) {
      return log.bedtime.year == date.year &&
          log.bedtime.month == date.month &&
          log.bedtime.day == date.day;
    }).toList();
  }

  Future<List<EnhancedSleepLogModel>> getSleepLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    await ensureInitialized();
    return _logsBox!.values.where((log) {
      return log.bedtime.isAfter(start.subtract(const Duration(days: 1))) &&
          log.bedtime.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<List<EnhancedSleepLogModel>> getRecentSleepLogs(int limit) async {
    await ensureInitialized();
    final logs = _logsBox!.values.toList();
    logs.sort((a, b) => b.bedtime.compareTo(a.bedtime));
    return logs.take(limit).toList();
  }

  Future<void> updateSleepLog(EnhancedSleepLogModel log) async {
    await ensureInitialized();
    final updatedLog = log.copyWith(updatedAt: DateTime.now());
    await _logsBox!.put(log.id, updatedLog);
  }

  Future<void> deleteSleepLog(String id) async {
    await ensureInitialized();
    await _logsBox!.delete(id);
  }

  // Sleep Goals CRUD
  Future<String> saveSleepGoal(SleepGoalModel goal) async {
    await ensureInitialized();
    await _goalsBox!.put(goal.id, goal);
    return goal.id;
  }

  Future<SleepGoalModel?> getCurrentSleepGoal() async {
    await ensureInitialized();
    final activeGoals = _goalsBox!.values
        .where((goal) => goal.isActive)
        .toList();
    if (activeGoals.isEmpty) return null;

    // Return the most recent active goal
    activeGoals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return activeGoals.first;
  }

  Future<List<SleepGoalModel>> getAllSleepGoals() async {
    await ensureInitialized();
    return _goalsBox!.values.toList();
  }

  Future<void> updateSleepGoal(SleepGoalModel goal) async {
    await ensureInitialized();
    final updatedGoal = goal.copyWith(updatedAt: DateTime.now());
    await _goalsBox!.put(goal.id, updatedGoal);
  }

  Future<void> deactivateAllGoals() async {
    await ensureInitialized();
    final goals = _goalsBox!.values.toList();
    for (final goal in goals) {
      if (goal.isActive) {
        final deactivatedGoal = goal.copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        await updateSleepGoal(deactivatedGoal);
      }
    }
  }

  Future<void> deleteSleepGoal(String id) async {
    await ensureInitialized();
    await _goalsBox!.delete(id);
  }

  // Statistics and Calculations
  Future<double> getDailySleepHours(DateTime date) async {
    await ensureInitialized();
    final dailyLogs = await getSleepLogsByDate(date);

    if (dailyLogs.isEmpty) return 0.0;

    final totalMinutes = dailyLogs.fold(
      0,
      (sum, log) => sum + log.duration.inMinutes,
    );
    return totalMinutes / 60.0;
  }

  Future<double> getWeeklyAverageSleepHours(DateTime weekStart) async {
    await ensureInitialized();
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekLogs = await getSleepLogsByDateRange(weekStart, weekEnd);

    if (weekLogs.isEmpty) return 0.0;

    final totalHours = weekLogs.fold(
      0.0,
      (sum, log) => sum + log.durationHours,
    );
    return totalHours / 7.0; // Average per day
  }

  Future<double> getAverageSleepQuality(DateTime startDate, int days) async {
    await ensureInitialized();
    final endDate = startDate.add(Duration(days: days));
    final periodLogs = await getSleepLogsByDateRange(startDate, endDate);

    if (periodLogs.isEmpty) return 0.0;

    final totalQuality = periodLogs.fold(
      0.0,
      (sum, log) => sum + log.quality.index + 1,
    );
    return totalQuality / periodLogs.length;
  }

  Future<int> getSleepGoalAchievementDays(DateTime startDate, int days) async {
    await ensureInitialized();
    final goal = await getCurrentSleepGoal();
    if (goal == null) return 0;

    int achievementDays = 0;
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyHours = await getDailySleepHours(date);
      if (dailyHours >= goal.targetHours) {
        achievementDays++;
      }
    }

    return achievementDays;
  }

  Future<double> getSleepGoalProgress(DateTime date) async {
    await ensureInitialized();
    final goal = await getCurrentSleepGoal();
    if (goal == null) return 0.0;

    final dailyHours = await getDailySleepHours(date);
    return (dailyHours / goal.targetHours * 100).clamp(
      0.0,
      200.0,
    ); // Cap at 200%
  }

  Future<Map<String, dynamic>> getSleepStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await ensureInitialized();
    final logs = await getSleepLogsByDateRange(startDate, endDate);
    final goal = await getCurrentSleepGoal();

    if (logs.isEmpty) {
      return {
        'totalSleepHours': 0.0,
        'averageSleepHours': 0.0,
        'averageSleepQuality': 0.0,
        'goalAchievementDays': 0,
        'goalProgress': 0.0,
        'targetHours': goal?.targetHours ?? 0.0,
      };
    }

    final totalSleepHours = logs.fold(
      0.0,
      (sum, log) => sum + log.durationHours,
    );
    final days = endDate.difference(startDate).inDays + 1;
    final averageSleepHours = totalSleepHours / days;
    final averageSleepQuality =
        logs.fold(0.0, (sum, log) => sum + log.quality.index + 1) / logs.length;

    int goalAchievementDays = 0;
    if (goal != null) {
      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final dailyHours = await getDailySleepHours(date);
        if (dailyHours >= goal.targetHours) {
          goalAchievementDays++;
        }
      }
    }

    return {
      'totalSleepHours': totalSleepHours,
      'averageSleepHours': averageSleepHours,
      'averageSleepQuality': averageSleepQuality,
      'goalAchievementDays': goalAchievementDays,
      'goalProgress': goal != null
          ? (totalSleepHours / (goal.targetHours * days) * 100).clamp(
              0.0,
              200.0,
            )
          : 0.0,
      'targetHours': goal?.targetHours ?? 0.0,
    };
  }

  // Sleep Pattern Analysis
  Future<Map<String, dynamic>> getSleepPatterns(
    DateTime startDate,
    int days,
  ) async {
    await ensureInitialized();
    final endDate = startDate.add(Duration(days: days));
    final logs = await getSleepLogsByDateRange(startDate, endDate);

    if (logs.isEmpty) {
      return {
        'averageBedtime': '00:00',
        'averageWakeTime': '00:00',
        'consistencyScore': 0.0,
        'sleepEfficiency': 0.0,
      };
    }

    // Calculate average bedtime and wake time
    final totalBedtimeMinutes = logs.fold(
      0,
      (sum, log) => sum + (log.bedtime.hour * 60 + log.bedtime.minute),
    );
    final totalWakeMinutes = logs.fold(
      0,
      (sum, log) => sum + (log.wakeTime.hour * 60 + log.wakeTime.minute),
    );

    final avgBedtimeMinutes = totalBedtimeMinutes / logs.length;
    final avgWakeMinutes = totalWakeMinutes / logs.length;

    final avgBedtime =
        '${(avgBedtimeMinutes ~/ 60).toString().padLeft(2, '0')}:${(avgBedtimeMinutes % 60).toString().padLeft(2, '0')}';
    final avgWakeTime =
        '${(avgWakeMinutes ~/ 60).toString().padLeft(2, '0')}:${(avgWakeMinutes % 60).toString().padLeft(2, '0')}';

    // Calculate consistency (lower standard deviation = higher consistency)
    final bedtimeVariances = logs.map((log) {
      final logMinutes = log.bedtime.hour * 60 + log.bedtime.minute;
      return (logMinutes - avgBedtimeMinutes) *
          (logMinutes - avgBedtimeMinutes);
    }).toList();

    final bedtimeVariance =
        bedtimeVariances.fold(0.0, (sum, variance) => sum + variance) /
        logs.length;
    final consistencyScore = (100 - (bedtimeVariance / 100)).clamp(0.0, 100.0);

    // Calculate sleep efficiency (time in bed vs actual sleep time)
    final totalTimeInBed = logs.fold(
      0.0,
      (sum, log) => sum + log.durationHours,
    );
    final totalSleepTime = logs.fold(
      0.0,
      (sum, log) => sum + log.durationHours,
    ); // Assuming all time is sleep time
    final sleepEfficiency = totalTimeInBed > 0
        ? (totalSleepTime / totalTimeInBed * 100).clamp(0.0, 100.0)
        : 0.0;

    return {
      'averageBedtime': avgBedtime,
      'averageWakeTime': avgWakeTime,
      'consistencyScore': consistencyScore,
      'sleepEfficiency': sleepEfficiency,
    };
  }

  // Search and Filter
  Future<List<EnhancedSleepLogModel>> searchSleepLogs(String query) async {
    await ensureInitialized();
    final lowercaseQuery = query.toLowerCase();
    return _logsBox!.values.where((log) {
      return (log.notes?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          log.quality.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<EnhancedSleepLogModel>> getSleepLogsByQuality(
    SleepQuality quality,
  ) async {
    await ensureInitialized();
    return _logsBox!.values.where((log) => log.quality == quality).toList();
  }

  // Sync operations for future cloud integration
  Future<List<EnhancedSleepLogModel>> getUnsyncedSleepLogs() async {
    await ensureInitialized();
    return _logsBox!.values.where((log) => !log.synced).toList();
  }

  Future<List<SleepGoalModel>> getUnsyncedSleepGoals() async {
    await ensureInitialized();
    return _goalsBox!.values.where((goal) => !goal.synced).toList();
  }

  Future<void> markSleepLogAsSynced(String id, String remoteId) async {
    await ensureInitialized();
    final log = await getSleepLog(id);
    if (log != null) {
      final syncedLog = log.copyWith(
        synced: true,
        remoteId: remoteId,
        updatedAt: DateTime.now(),
      );
      await updateSleepLog(syncedLog);
    }
  }

  Future<void> markSleepGoalAsSynced(String id, String remoteId) async {
    await ensureInitialized();
    final goal = _goalsBox!.get(id);
    if (goal != null) {
      final syncedGoal = goal.copyWith(
        synced: true,
        remoteId: remoteId,
        updatedAt: DateTime.now(),
      );
      await updateSleepGoal(syncedGoal);
    }
  }

  // Cleanup
  Future<void> close() async {
    await _logsBox?.close();
    await _goalsBox?.close();
  }
}
