import 'package:flutter/material.dart';
import '../models/wellness_model.dart';
import '../repositories/wellness_repository.dart';

class WaterProvider extends ChangeNotifier {
  WaterRepository? _repository;

  // State
  int _currentWaterMl = 0;
  int _goalWaterMl = 3000; // Default 3L goal
  List<WaterLogModel> _todayLogs = [];
  Map<DateTime, int> _weeklyData = {};
  bool _isLoading = false;

  // Getters
  int get currentWaterMl => _currentWaterMl;
  int get goalWaterMl => _goalWaterMl;
  List<WaterLogModel> get todayLogs => _todayLogs;
  Map<DateTime, int> get weeklyData => _weeklyData;
  bool get isLoading => _isLoading;
  bool get isGoalExceeded => _currentWaterMl > _goalWaterMl;
  double get progressPercentage =>
      (_currentWaterMl / _goalWaterMl).clamp(0.0, 1.0);
  int get actualPercentage => ((_currentWaterMl / _goalWaterMl) * 100).round();

  WaterProvider(this._repository);

  // Update repository after initialization
  void updateRepository(WaterRepository repository) {
    _repository = repository;
  }

  // Initialize provider
  Future<void> initialize() async {
    if (_repository == null) return;

    // Set loading without notifying listeners during initialization
    _isLoading = true;

    try {
      await _loadTodayData();
      await _loadWeeklyData();
    } catch (e) {
      debugPrint('Error initializing WaterProvider: $e');
    } finally {
      _isLoading = false;
      // Only notify listeners after initialization is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Load today's water data
  Future<void> _loadTodayData() async {
    if (_repository == null) return;

    final today = DateTime.now();
    _todayLogs = await _repository!.getLogsByDate(today);
    _currentWaterMl = _todayLogs.fold(0, (sum, log) => sum + log.amountMl);
  }

  // Load weekly data
  Future<void> _loadWeeklyData() async {
    if (_repository == null) return;

    _weeklyData = await _repository!.getWeeklyWaterIntake();
  }

  // Add water
  Future<void> addWater(int amountMl, {String? notes}) async {
    if (_repository == null) return;

    _setLoading(true);

    try {
      await _repository!.addWater(amountMl, notes: notes);
      await _loadTodayData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding water: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Set water goal
  Future<void> setWaterGoal(int goalMl) async {
    _goalWaterMl = goalMl;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    _setLoading(true);

    try {
      await _loadTodayData();
      await _loadWeeklyData();
    } catch (e) {
      debugPrint('Error refreshing water data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get water for specific day
  Future<int> getWaterForDay(DateTime day) async {
    if (_repository == null) return 0;

    final logs = await _repository!.getLogsByDate(day);
    return logs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  // Format volume helper
  String formatVolume(int ml) {
    if (ml < 1000) {
      return '$ml ml';
    } else {
      final liters = ml / 1000.0;
      return '${liters.toStringAsFixed(liters % 1 == 0 ? 0 : 1)} L';
    }
  }

  // Compute remaining text
  String computeRemainingText() {
    final difference = _currentWaterMl - _goalWaterMl;
    if (difference >= 0) {
      return 'Exceeded by ${formatVolume(difference)}';
    } else {
      return 'Remaining ${formatVolume(-difference)}';
    }
  }

  // Compute visual percent (clamped for UI)
  double computeVisualPercent() {
    return (_currentWaterMl / _goalWaterMl).clamp(0.0, 1.0);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
