import 'package:hive/hive.dart';
import '../models/enhanced_water_model.dart';
import '../models/enums.dart';
import '../services/hive_storage_service.dart';

class EnhancedWaterRepository {
  Box<EnhancedWaterLogModel>? _logsBox;
  Box<WaterGoalModel>? _goalsBox;

  Future<void> initialize() async {
    _logsBox = await HiveStorageService.getWaterLogsBox();
    _goalsBox = await HiveStorageService.getWaterGoalsBox();
  }

  Future<void> ensureInitialized() async {
    if (_logsBox == null || _goalsBox == null) {
      await initialize();
    }
  }

  // Water Logs CRUD
  Future<String> saveWaterLog(EnhancedWaterLogModel log) async {
    await ensureInitialized();
    await _logsBox!.put(log.id, log);
    return log.id;
  }

  Future<EnhancedWaterLogModel?> getWaterLog(String id) async {
    await ensureInitialized();
    return _logsBox!.get(id);
  }

  Future<List<EnhancedWaterLogModel>> getAllWaterLogs() async {
    await ensureInitialized();
    return _logsBox!.values.toList();
  }

  Future<List<EnhancedWaterLogModel>> getWaterLogsByDate(DateTime date) async {
    await ensureInitialized();
    return _logsBox!.values.where((log) {
      return log.timestamp.year == date.year &&
          log.timestamp.month == date.month &&
          log.timestamp.day == date.day;
    }).toList();
  }

  Future<List<EnhancedWaterLogModel>> getWaterLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    await ensureInitialized();
    return _logsBox!.values.where((log) {
      return log.timestamp.isAfter(start.subtract(const Duration(days: 1))) &&
          log.timestamp.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<List<EnhancedWaterLogModel>> getRecentWaterLogs(int limit) async {
    await ensureInitialized();
    final logs = _logsBox!.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs.take(limit).toList();
  }

  Future<void> updateWaterLog(EnhancedWaterLogModel log) async {
    await ensureInitialized();
    final updatedLog = log.copyWith(updatedAt: DateTime.now());
    await _logsBox!.put(log.id, updatedLog);
  }

  Future<void> deleteWaterLog(String id) async {
    await ensureInitialized();
    await _logsBox!.delete(id);
  }

  // Water Goals CRUD
  Future<String> saveWaterGoal(WaterGoalModel goal) async {
    await ensureInitialized();
    await _goalsBox!.put(goal.id, goal);
    return goal.id;
  }

  Future<WaterGoalModel?> getCurrentWaterGoal() async {
    await ensureInitialized();
    final activeGoals = _goalsBox!.values
        .where((goal) => goal.isActive)
        .toList();
    if (activeGoals.isEmpty) return null;

    // Return the most recent active goal
    activeGoals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return activeGoals.first;
  }

  Future<List<WaterGoalModel>> getAllWaterGoals() async {
    await ensureInitialized();
    return _goalsBox!.values.toList();
  }

  Future<void> updateWaterGoal(WaterGoalModel goal) async {
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
        await updateWaterGoal(deactivatedGoal);
      }
    }
  }

  Future<void> deleteWaterGoal(String id) async {
    await ensureInitialized();
    await _goalsBox!.delete(id);
  }

  // Statistics and Calculations
  Future<int> getDailyWaterIntake(DateTime date) async {
    await ensureInitialized();
    final dailyLogs = await getWaterLogsByDate(date);
    return dailyLogs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  Future<double> getWeeklyAverageWaterIntake(DateTime weekStart) async {
    await ensureInitialized();
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekLogs = await getWaterLogsByDateRange(weekStart, weekEnd);

    if (weekLogs.isEmpty) return 0.0;

    final totalMl = weekLogs.fold<int>(0, (sum, log) => sum + log.amountMl);
    return totalMl / 7.0; // Average per day
  }

  Future<int> getWaterGoalAchievementDays(DateTime startDate, int days) async {
    await ensureInitialized();
    final goal = await getCurrentWaterGoal();
    if (goal == null) return 0;

    int achievementDays = 0;
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyIntake = await getDailyWaterIntake(date);
      if (dailyIntake >= goal.goalMl) {
        achievementDays++;
      }
    }

    return achievementDays;
  }

  Future<double> getWaterGoalProgress(DateTime date) async {
    await ensureInitialized();
    final goal = await getCurrentWaterGoal();
    if (goal == null) return 0.0;

    final dailyIntake = await getDailyWaterIntake(date);
    return (dailyIntake / goal.goalMl * 100).clamp(0.0, 200.0); // Cap at 200%
  }

  Future<Map<String, dynamic>> getWaterStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await ensureInitialized();
    final logs = await getWaterLogsByDateRange(startDate, endDate);
    final goal = await getCurrentWaterGoal();

    if (logs.isEmpty) {
      return {
        'totalIntake': 0,
        'averageIntake': 0.0,
        'goalAchievementDays': 0,
        'goalProgress': 0.0,
        'goalMl': goal?.goalMl ?? 0,
      };
    }

    final totalIntake = logs.fold<int>(0, (sum, log) => sum + log.amountMl);
    final days = endDate.difference(startDate).inDays + 1;
    final averageIntake = totalIntake / days;

    int goalAchievementDays = 0;
    if (goal != null) {
      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final dailyIntake = await getDailyWaterIntake(date);
        if (dailyIntake >= goal.goalMl) {
          goalAchievementDays++;
        }
      }
    }

    return {
      'totalIntake': totalIntake,
      'averageIntake': averageIntake,
      'goalAchievementDays': goalAchievementDays,
      'goalProgress': goal != null
          ? (totalIntake / (goal.goalMl * days) * 100).clamp(0.0, 200.0)
          : 0.0,
      'goalMl': goal?.goalMl ?? 0,
    };
  }

  // Search and Filter
  Future<List<EnhancedWaterLogModel>> searchWaterLogs(String query) async {
    await ensureInitialized();
    final lowercaseQuery = query.toLowerCase();
    return _logsBox!.values.where((log) {
      return (log.notes?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          log.type.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<EnhancedWaterLogModel>> getWaterLogsByType(
    WaterLogType type,
  ) async {
    await ensureInitialized();
    return _logsBox!.values.where((log) => log.type == type).toList();
  }

  // Sync operations for future cloud integration
  Future<List<EnhancedWaterLogModel>> getUnsyncedWaterLogs() async {
    await ensureInitialized();
    return _logsBox!.values.where((log) => !log.synced).toList();
  }

  Future<List<WaterGoalModel>> getUnsyncedWaterGoals() async {
    await ensureInitialized();
    return _goalsBox!.values.where((goal) => !goal.synced).toList();
  }

  Future<void> markWaterLogAsSynced(String id, String remoteId) async {
    await ensureInitialized();
    final log = await getWaterLog(id);
    if (log != null) {
      final syncedLog = log.copyWith(
        synced: true,
        remoteId: remoteId,
        updatedAt: DateTime.now(),
      );
      await updateWaterLog(syncedLog);
    }
  }

  Future<void> markWaterGoalAsSynced(String id, String remoteId) async {
    await ensureInitialized();
    final goal = _goalsBox!.get(id);
    if (goal != null) {
      final syncedGoal = goal.copyWith(
        synced: true,
        remoteId: remoteId,
        updatedAt: DateTime.now(),
      );
      await updateWaterGoal(syncedGoal);
    }
  }

  // Cleanup
  Future<void> close() async {
    await _logsBox?.close();
    await _goalsBox?.close();
  }
}
