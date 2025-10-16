import 'package:flutter/material.dart';
import '../models/enhanced_water_model.dart';
import '../repositories/enhanced_water_repository.dart';
import '../utils/progress_utils.dart';

class EnhancedWaterProvider extends ChangeNotifier {
  final EnhancedWaterRepository _repository;

  // State
  List<EnhancedWaterLogModel> _waterLogs = [];
  WaterGoalModel? _currentGoal;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<EnhancedWaterLogModel> get waterLogs => _waterLogs;
  WaterGoalModel? get currentGoal => _currentGoal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Today's data
  int get todayWaterIntake {
    final today = DateTime.now();
    return _waterLogs
        .where(
          (log) =>
              log.timestamp.year == today.year &&
              log.timestamp.month == today.month &&
              log.timestamp.day == today.day,
        )
        .fold(0, (sum, log) => sum + log.amountMl);
  }

  int get goalMl => _currentGoal?.goalMl ?? 2000;

  double get todayProgress {
    if (goalMl == 0) return 0.0;
    return (todayWaterIntake / goalMl * 100).clamp(0.0, 200.0);
  }

  bool get isGoalAchieved => todayWaterIntake >= goalMl;

  String get todayFormattedIntake {
    if (todayWaterIntake >= 1000) {
      return '${(todayWaterIntake / 1000).toStringAsFixed(1)}L';
    }
    return '${todayWaterIntake}ml';
  }

  String get goalFormatted {
    if (goalMl >= 1000) {
      return '${(goalMl / 1000).toStringAsFixed(1)}L';
    }
    return '${goalMl}ml';
  }

  // Recent logs (last 7 days)
  List<EnhancedWaterLogModel> get recentLogs {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _waterLogs.where((log) => log.timestamp.isAfter(weekAgo)).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Weekly statistics
  double get weeklyAverage {
    if (recentLogs.isEmpty) return 0.0;
    final totalMl = recentLogs.fold(0, (sum, log) => sum + log.amountMl);
    return totalMl / 7.0;
  }

  int get weeklyGoalAchievementDays {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateWaterGoalAchievementDays(
      recentLogs,
      goalMl,
      weekStart,
      7,
    );
  }

  EnhancedWaterProvider(this._repository);

  // Initialize provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _repository.initialize();
      await _loadWaterLogs();
      await _loadCurrentGoal();
    } catch (e) {
      _setError('Failed to initialize water provider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load data
  Future<void> _loadWaterLogs() async {
    try {
      _waterLogs = await _repository.getAllWaterLogs();
      _waterLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load water logs: $e');
    }
  }

  Future<void> _loadCurrentGoal() async {
    try {
      _currentGoal = await _repository.getCurrentWaterGoal();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load water goal: $e');
    }
  }

  // Water logging operations
  Future<String> addWater({
    required int amountMl,
    String? notes,
    WaterLogType type = WaterLogType.manual,
  }) async {
    try {
      final now = DateTime.now();
      final log = EnhancedWaterLogModel(
        id: _generateId(),
        amountMl: amountMl,
        timestamp: now,
        notes: notes,
        type: type,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveWaterLog(log);
      _waterLogs.insert(0, log);
      notifyListeners();
      return log.id;
    } catch (e) {
      _setError('Failed to add water: $e');
      rethrow;
    }
  }

  Future<void> updateWaterLog(
    String logId, {
    int? amountMl,
    String? notes,
    WaterLogType? type,
  }) async {
    try {
      final log = _waterLogs.firstWhere((l) => l.id == logId);
      final updatedLog = log.copyWith(
        amountMl: amountMl ?? log.amountMl,
        notes: notes ?? log.notes,
        type: type ?? log.type,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWaterLog(updatedLog);
      _updateLogInList(updatedLog);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update water log: $e');
    }
  }

  Future<void> deleteWaterLog(String logId) async {
    try {
      await _repository.deleteWaterLog(logId);
      _waterLogs.removeWhere((l) => l.id == logId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete water log: $e');
    }
  }

  // Goal management
  Future<String> setWaterGoal(int goalMl) async {
    try {
      // Deactivate current goal
      if (_currentGoal != null) {
        await _repository.deactivateAllGoals();
      }

      final now = DateTime.now();
      final goal = WaterGoalModel(
        id: _generateId(),
        goalMl: goalMl,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveWaterGoal(goal);
      _currentGoal = goal;
      notifyListeners();
      return goal.id;
    } catch (e) {
      _setError('Failed to set water goal: $e');
      rethrow;
    }
  }

  Future<void> updateWaterGoal(int goalMl) async {
    try {
      if (_currentGoal == null) {
        await setWaterGoal(goalMl);
        return;
      }

      final updatedGoal = _currentGoal!.copyWith(
        goalMl: goalMl,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWaterGoal(updatedGoal);
      _currentGoal = updatedGoal;
      notifyListeners();
    } catch (e) {
      _setError('Failed to update water goal: $e');
    }
  }

  // Quick add methods
  Future<void> addQuickWater(int amountMl) async {
    await addWater(amountMl: amountMl, type: WaterLogType.quickAdd);
  }

  Future<void> addReminderWater(int amountMl) async {
    await addWater(amountMl: amountMl, type: WaterLogType.reminder);
  }

  // Statistics
  Future<Map<String, dynamic>> getWaterStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _repository.getWaterStats(startDate, endDate);
    } catch (e) {
      _setError('Failed to get water stats: $e');
      return {};
    }
  }

  Future<double> getDailyWaterIntake(DateTime date) async {
    try {
      return await _repository
          .getDailyWaterIntake(date)
          .then((ml) => ml / 1000.0);
    } catch (e) {
      _setError('Failed to get daily water intake: $e');
      return 0.0;
    }
  }

  Future<double> getWeeklyAverageWaterIntake(DateTime weekStart) async {
    try {
      return await _repository
          .getWeeklyAverageWaterIntake(weekStart)
          .then((ml) => ml / 1000.0);
    } catch (e) {
      _setError('Failed to get weekly average: $e');
      return 0.0;
    }
  }

  // Search and filter
  Future<List<EnhancedWaterLogModel>> searchWaterLogs(String query) async {
    try {
      return await _repository.searchWaterLogs(query);
    } catch (e) {
      _setError('Failed to search water logs: $e');
      return [];
    }
  }

  Future<List<EnhancedWaterLogModel>> getWaterLogsByType(
    WaterLogType type,
  ) async {
    try {
      return await _repository.getWaterLogsByType(type);
    } catch (e) {
      _setError('Failed to get water logs by type: $e');
      return [];
    }
  }

  Future<List<EnhancedWaterLogModel>> getWaterLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _repository.getWaterLogsByDateRange(start, end);
    } catch (e) {
      _setError('Failed to get water logs by date range: $e');
      return [];
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadWaterLogs();
    await _loadCurrentGoal();
  }

  // Helper methods
  void _updateLogInList(EnhancedWaterLogModel updatedLog) {
    final index = _waterLogs.indexWhere((l) => l.id == updatedLog.id);
    if (index != -1) {
      _waterLogs[index] = updatedLog;
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

