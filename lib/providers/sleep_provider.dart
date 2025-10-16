import 'package:flutter/material.dart';
import '../models/wellness_model.dart';
import '../repositories/wellness_repository.dart';

class SleepProvider extends ChangeNotifier {
  SleepRepository? _repository;

  // State
  List<SleepLogModel> _recentLogs = [];
  Map<DateTime, Duration> _weeklyData = {};
  Duration _averageSleep = Duration.zero;
  double _averageSleepScore = 0.0;
  SleepQuality _selectedQuality = SleepQuality.good;
  bool _isLoading = false;

  // Getters
  List<SleepLogModel> get recentLogs => _recentLogs;
  Map<DateTime, Duration> get weeklyData => _weeklyData;
  Duration get averageSleep => _averageSleep;
  double get averageSleepScore => _averageSleepScore;
  SleepQuality get selectedQuality => _selectedQuality;
  bool get isLoading => _isLoading;
  SleepLogModel? get lastNightSleep =>
      _recentLogs.isNotEmpty ? _recentLogs.first : null;

  SleepProvider(this._repository);

  // Update repository after initialization
  void updateRepository(SleepRepository repository) {
    _repository = repository;
  }

  // Initialize provider
  Future<void> initialize() async {
    if (_repository == null) return;

    // Set loading without notifying listeners during initialization
    _isLoading = true;

    try {
      await _loadRecentLogs();
      await _loadWeeklyData();
      await _loadAverages();
    } catch (e) {
      debugPrint('Error initializing SleepProvider: $e');
    } finally {
      _isLoading = false;
      // Only notify listeners after initialization is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Load recent sleep logs
  Future<void> _loadRecentLogs() async {
    if (_repository == null) return;

    _recentLogs = await _repository!.getRecentLogs();
  }

  // Load weekly data
  Future<void> _loadWeeklyData() async {
    if (_repository == null) return;

    _weeklyData = await _repository!.getWeeklySleepDuration();
  }

  // Load averages
  Future<void> _loadAverages() async {
    if (_repository == null) return;

    _averageSleep = await _repository!.getAverageSleepDuration();
    _averageSleepScore = await _repository!.getAverageSleepScore();
  }

  // Log sleep
  Future<void> logSleep(
    DateTime bedtime,
    DateTime wakeTime,
    SleepQuality quality, {
    String? notes,
    int? sleepScore,
  }) async {
    if (_repository == null) return;

    _setLoading(true);

    try {
      await _repository!.logSleep(
        bedtime,
        wakeTime,
        quality,
        notes: notes,
        sleepScore: sleepScore,
      );
      await _loadRecentLogs();
      await _loadWeeklyData();
      await _loadAverages();
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging sleep: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Set selected quality
  void setSelectedQuality(SleepQuality quality) {
    _selectedQuality = quality;
    notifyListeners();
  }

  // Get sleep for specific day
  Future<SleepLogModel?> getSleepForDay(DateTime day) async {
    if (_repository == null) return null;

    final logs = await _repository!.getLogsByDate(day);
    return logs.isNotEmpty ? logs.first : null;
  }

  // Get sleep duration for specific day
  Future<Duration> getSleepDurationForDay(DateTime day) async {
    if (_repository == null) return Duration.zero;

    final logs = await _repository!.getLogsByDate(day);
    return logs.fold<Duration>(Duration.zero, (sum, log) => sum + log.duration);
  }

  // Get sleep hours for specific day
  Future<double> getSleepHoursForDay(DateTime day) async {
    final duration = await getSleepDurationForDay(day);
    return duration.inMinutes / 60.0;
  }

  // Refresh data
  Future<void> refresh() async {
    _setLoading(true);

    try {
      await _loadRecentLogs();
      await _loadWeeklyData();
      await _loadAverages();
    } catch (e) {
      debugPrint('Error refreshing sleep data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Format time helper
  String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  // Format date helper
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  // Get day name helper
  String getDayName(DateTime day) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[day.weekday - 1];
  }

  // Get quality icon helper
  IconData getQualityIcon(SleepQuality quality) {
    switch (quality) {
      case SleepQuality.excellent:
        return Icons.sentiment_very_satisfied;
      case SleepQuality.good:
        return Icons.sentiment_satisfied;
      case SleepQuality.fair:
        return Icons.sentiment_neutral;
      case SleepQuality.poor:
        return Icons.sentiment_dissatisfied;
    }
  }

  // Get quality color helper
  Color getQualityColor(SleepQuality quality) {
    switch (quality) {
      case SleepQuality.excellent:
        return const Color(0xFF10B981); // success
      case SleepQuality.good:
        return const Color(0xFF5DD62C); // accent1
      case SleepQuality.fair:
        return const Color(0xFFF59E0B); // warning
      case SleepQuality.poor:
        return const Color(0xFFEF4444); // error
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
