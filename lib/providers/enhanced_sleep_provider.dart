import 'package:flutter/material.dart';
import '../models/enhanced_sleep_model.dart';
import '../repositories/enhanced_sleep_repository.dart';
import '../utils/progress_utils.dart';

class EnhancedSleepProvider extends ChangeNotifier {
  final EnhancedSleepRepository _repository;

  // State
  List<EnhancedSleepLogModel> _sleepLogs = [];
  SleepGoalModel? _currentGoal;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<EnhancedSleepLogModel> get sleepLogs => _sleepLogs;
  SleepGoalModel? get currentGoal => _currentGoal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Today's data
  EnhancedSleepLogModel? get lastNightSleep {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    return _sleepLogs.firstWhere(
      (log) =>
          log.bedtime.year == yesterday.year &&
          log.bedtime.month == yesterday.month &&
          log.bedtime.day == yesterday.day,
      orElse: () => throw StateError('No sleep log found'),
    );
  }

  double get lastNightSleepHours {
    try {
      return lastNightSleep?.durationHours ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  SleepQuality get lastNightSleepQuality {
    try {
      return lastNightSleep?.quality ?? SleepQuality.good;
    } catch (e) {
      return SleepQuality.good;
    }
  }

  String get lastNightSleepFormatted {
    try {
      return lastNightSleep?.formattedDuration ?? '0h 0m';
    } catch (e) {
      return '0h 0m';
    }
  }

  // Goal data
  double get targetHours => _currentGoal?.targetHours ?? 8.0;

  String get targetHoursFormatted => _currentGoal?.formattedTarget ?? '8h 0m';

  String get targetBedtime => _currentGoal?.bedtimeFormatted ?? '22:00';

  String get targetWakeTime => _currentGoal?.wakeTimeFormatted ?? '06:00';

  // Recent logs (last 7 days)
  List<EnhancedSleepLogModel> get recentLogs {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _sleepLogs.where((log) => log.bedtime.isAfter(weekAgo)).toList()
      ..sort((a, b) => b.bedtime.compareTo(a.bedtime));
  }

  // Weekly statistics
  double get weeklyAverageHours {
    if (recentLogs.isEmpty) return 0.0;
    final totalHours = recentLogs.fold(
      0.0,
      (sum, log) => sum + log.durationHours,
    );
    return totalHours / recentLogs.length;
  }

  double get weeklyAverageQuality {
    if (recentLogs.isEmpty) return 0.0;
    final totalQuality = recentLogs.fold(
      0.0,
      (sum, log) => sum + log.quality.index + 1,
    );
    return totalQuality / recentLogs.length;
  }

  int get weeklyGoalAchievementDays {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateSleepGoalAchievementDays(
      recentLogs,
      targetHours,
      weekStart,
      7,
    );
  }

  // Sleep patterns
  Map<String, String> get sleepPatterns {
    if (recentLogs.isEmpty) {
      return {
        'averageBedtime': '00:00',
        'averageWakeTime': '00:00',
        'consistencyScore': '0%',
        'sleepEfficiency': '0%',
      };
    }

    final totalBedtimeMinutes = recentLogs.fold(
      0,
      (sum, log) => sum + (log.bedtime.hour * 60 + log.bedtime.minute),
    );
    final totalWakeMinutes = recentLogs.fold(
      0,
      (sum, log) => sum + (log.wakeTime.hour * 60 + log.wakeTime.minute),
    );

    final avgBedtimeMinutes = totalBedtimeMinutes / recentLogs.length;
    final avgWakeMinutes = totalWakeMinutes / recentLogs.length;

    final avgBedtime =
        '${(avgBedtimeMinutes ~/ 60).toString().padLeft(2, '0')}:${(avgBedtimeMinutes % 60).toString().padLeft(2, '0')}';
    final avgWakeTime =
        '${(avgWakeMinutes ~/ 60).toString().padLeft(2, '0')}:${(avgWakeMinutes % 60).toString().padLeft(2, '0')}';

    return {
      'averageBedtime': avgBedtime,
      'averageWakeTime': avgWakeTime,
      'consistencyScore': '85%', // Placeholder
      'sleepEfficiency': '90%', // Placeholder
    };
  }

  EnhancedSleepProvider(this._repository);

  // Initialize provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _repository.initialize();
      await _loadSleepLogs();
      await _loadCurrentGoal();
    } catch (e) {
      _setError('Failed to initialize sleep provider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load data
  Future<void> _loadSleepLogs() async {
    try {
      _sleepLogs = await _repository.getAllSleepLogs();
      _sleepLogs.sort((a, b) => b.bedtime.compareTo(a.bedtime));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load sleep logs: $e');
    }
  }

  Future<void> _loadCurrentGoal() async {
    try {
      _currentGoal = await _repository.getCurrentSleepGoal();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load sleep goal: $e');
    }
  }

  // Sleep logging operations
  Future<String> logSleep({
    required DateTime bedtime,
    required DateTime wakeTime,
    required SleepQuality quality,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();
      final log = EnhancedSleepLogModel(
        id: _generateId(),
        bedtime: bedtime,
        wakeTime: wakeTime,
        quality: quality,
        notes: notes,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveSleepLog(log);
      _sleepLogs.insert(0, log);
      notifyListeners();
      return log.id;
    } catch (e) {
      _setError('Failed to log sleep: $e');
      rethrow;
    }
  }

  Future<void> updateSleepLog(
    String logId, {
    DateTime? bedtime,
    DateTime? wakeTime,
    SleepQuality? quality,
    String? notes,
  }) async {
    try {
      final log = _sleepLogs.firstWhere((l) => l.id == logId);
      final updatedLog = log.copyWith(
        bedtime: bedtime ?? log.bedtime,
        wakeTime: wakeTime ?? log.wakeTime,
        quality: quality ?? log.quality,
        notes: notes ?? log.notes,
        updatedAt: DateTime.now(),
      );

      await _repository.updateSleepLog(updatedLog);
      _updateLogInList(updatedLog);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update sleep log: $e');
    }
  }

  Future<void> deleteSleepLog(String logId) async {
    try {
      await _repository.deleteSleepLog(logId);
      _sleepLogs.removeWhere((l) => l.id == logId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete sleep log: $e');
    }
  }

  // Goal management
  Future<String> setSleepGoal({
    required double targetHours,
    required DateTime bedtime,
    required DateTime wakeTime,
  }) async {
    try {
      // Deactivate current goal
      if (_currentGoal != null) {
        await _repository.deactivateAllGoals();
      }

      final now = DateTime.now();
      final goal = SleepGoalModel(
        id: _generateId(),
        targetHours: targetHours,
        bedtime: bedtime,
        wakeTime: wakeTime,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveSleepGoal(goal);
      _currentGoal = goal;
      notifyListeners();
      return goal.id;
    } catch (e) {
      _setError('Failed to set sleep goal: $e');
      rethrow;
    }
  }

  Future<void> updateSleepGoal({
    double? targetHours,
    DateTime? bedtime,
    DateTime? wakeTime,
  }) async {
    try {
      if (_currentGoal == null) {
        await setSleepGoal(
          targetHours: targetHours ?? 8.0,
          bedtime: bedtime ?? DateTime(2024, 1, 1, 22, 0),
          wakeTime: wakeTime ?? DateTime(2024, 1, 2, 6, 0),
        );
        return;
      }

      final updatedGoal = _currentGoal!.copyWith(
        targetHours: targetHours ?? _currentGoal!.targetHours,
        bedtime: bedtime ?? _currentGoal!.bedtime,
        wakeTime: wakeTime ?? _currentGoal!.wakeTime,
        updatedAt: DateTime.now(),
      );

      await _repository.updateSleepGoal(updatedGoal);
      _currentGoal = updatedGoal;
      notifyListeners();
    } catch (e) {
      _setError('Failed to update sleep goal: $e');
    }
  }

  // Statistics
  Future<Map<String, dynamic>> getSleepStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _repository.getSleepStats(startDate, endDate);
    } catch (e) {
      _setError('Failed to get sleep stats: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSleepPatterns(
    DateTime startDate,
    int days,
  ) async {
    try {
      return await _repository.getSleepPatterns(startDate, days);
    } catch (e) {
      _setError('Failed to get sleep patterns: $e');
      return {};
    }
  }

  Future<double> getDailySleepHours(DateTime date) async {
    try {
      return await _repository.getDailySleepHours(date);
    } catch (e) {
      _setError('Failed to get daily sleep hours: $e');
      return 0.0;
    }
  }

  Future<double> getWeeklyAverageSleepHours(DateTime weekStart) async {
    try {
      return await _repository.getWeeklyAverageSleepHours(weekStart);
    } catch (e) {
      _setError('Failed to get weekly average sleep hours: $e');
      return 0.0;
    }
  }

  // Search and filter
  Future<List<EnhancedSleepLogModel>> searchSleepLogs(String query) async {
    try {
      return await _repository.searchSleepLogs(query);
    } catch (e) {
      _setError('Failed to search sleep logs: $e');
      return [];
    }
  }

  Future<List<EnhancedSleepLogModel>> getSleepLogsByQuality(
    SleepQuality quality,
  ) async {
    try {
      return await _repository.getSleepLogsByQuality(quality);
    } catch (e) {
      _setError('Failed to get sleep logs by quality: $e');
      return [];
    }
  }

  Future<List<EnhancedSleepLogModel>> getSleepLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _repository.getSleepLogsByDateRange(start, end);
    } catch (e) {
      _setError('Failed to get sleep logs by date range: $e');
      return [];
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadSleepLogs();
    await _loadCurrentGoal();
  }

  // Helper methods
  void _updateLogInList(EnhancedSleepLogModel updatedLog) {
    final index = _sleepLogs.indexWhere((l) => l.id == updatedLog.id);
    if (index != -1) {
      _sleepLogs[index] = updatedLog;
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }
}
