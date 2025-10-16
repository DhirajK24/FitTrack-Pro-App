import 'package:flutter/material.dart';
import '../models/enhanced_workout_model.dart';
import '../models/enhanced_water_model.dart';
import '../models/enhanced_sleep_model.dart';
import '../utils/progress_utils.dart';

class EnhancedProgressProvider extends ChangeNotifier {
  // Dependencies
  final List<EnhancedWorkoutModel> _workouts;
  final List<EnhancedWaterLogModel> _waterLogs;
  final List<EnhancedSleepLogModel> _sleepLogs;

  // State
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Progress calculations
  Map<String, double> get weeklyProgress {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return ProgressUtils.calculateWeeklyProgress(
      workouts: _workouts,
      waterLogs: _waterLogs,
      sleepLogs: _sleepLogs,
      waterGoalMl: 2000, // Default goal
      sleepGoalHours: 8.0, // Default goal
      weekStart: weekStart,
    );
  }

  Map<String, double> get monthlyProgress {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    return ProgressUtils.calculateMonthlyProgress(
      workouts: _workouts,
      waterLogs: _waterLogs,
      sleepLogs: _sleepLogs,
      waterGoalMl: 2000, // Default goal
      sleepGoalHours: 8.0, // Default goal
      monthStart: monthStart,
    );
  }

  // Workout progress
  double get totalWorkoutVolume =>
      ProgressUtils.calculateTotalVolume(_workouts);

  int get totalWorkoutCalories =>
      ProgressUtils.calculateTotalCalories(_workouts);

  int get totalWorkouts => ProgressUtils.calculateTotalWorkouts(_workouts);

  int get workoutStreak => ProgressUtils.calculateWorkoutStreak(_workouts);

  Duration get totalWorkoutTime =>
      ProgressUtils.calculateTotalWorkoutTime(_workouts);

  double get averageWorkoutDuration =>
      ProgressUtils.calculateAverageWorkoutDuration(_workouts);

  // Water progress
  int get todayWaterIntake {
    final today = DateTime.now();
    return ProgressUtils.calculateDailyWaterIntake(_waterLogs, today);
  }

  double get weeklyAverageWater {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateWeeklyAverageWaterIntake(
      _waterLogs,
      weekStart,
    );
  }

  int get weeklyWaterGoalDays {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateWaterGoalAchievementDays(
      _waterLogs,
      2000,
      weekStart,
      7,
    );
  }

  // Sleep progress
  double get lastNightSleepHours {
    final today = DateTime.now();
    return ProgressUtils.calculateDailySleepHours(_sleepLogs, today);
  }

  double get weeklyAverageSleep {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateWeeklyAverageSleep(_sleepLogs, weekStart);
  }

  double get weeklyAverageSleepQuality {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateAverageSleepQuality(_sleepLogs, weekStart, 7);
  }

  int get weeklySleepGoalDays {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return ProgressUtils.calculateSleepGoalAchievementDays(
      _sleepLogs,
      8.0,
      weekStart,
      7,
    );
  }

  // Personal records
  List<Map<String, dynamic>> get personalRecords =>
      ProgressUtils.detectPersonalRecords(_workouts);

  // Progress trends
  Map<String, List<double>> get progressTrends {
    final now = DateTime.now();
    final trends = <String, List<double>>{
      'workouts': [],
      'water': [],
      'sleep': [],
    };

    // Get last 30 days of data
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      // Workout trend (workouts per day)
      final dayWorkouts = _workouts
          .where(
            (w) =>
                w.startTime.year == date.year &&
                w.startTime.month == date.month &&
                w.startTime.day == date.day &&
                w.status == WorkoutStatus.completed,
          )
          .length;
      trends['workouts']!.add(dayWorkouts.toDouble());

      // Water trend (ml per day)
      final dayWater = ProgressUtils.calculateDailyWaterIntake(
        _waterLogs,
        date,
      );
      trends['water']!.add(dayWater.toDouble());

      // Sleep trend (hours per day)
      final daySleep = ProgressUtils.calculateDailySleepHours(_sleepLogs, date);
      trends['sleep']!.add(daySleep);
    }

    return trends;
  }

  // Achievement tracking
  Map<String, bool> get achievements {
    return {
      'firstWorkout': totalWorkouts > 0,
      'workoutStreak7': workoutStreak >= 7,
      'workoutStreak30': workoutStreak >= 30,
      'waterGoalWeek': weeklyWaterGoalDays >= 7,
      'sleepGoalWeek': weeklySleepGoalDays >= 7,
      'personalRecord': personalRecords.isNotEmpty,
    };
  }

  // Progress scores (0-100)
  Map<String, double> get progressScores {
    return {
      'workoutConsistency': (weeklyProgress['totalWorkouts']! / 7 * 100).clamp(
        0.0,
        100.0,
      ),
      'waterHydration': (weeklyProgress['waterGoalDays']! / 7 * 100).clamp(
        0.0,
        100.0,
      ),
      'sleepQuality': (weeklyProgress['avgSleepQuality']! / 4 * 100).clamp(
        0.0,
        100.0,
      ),
      'overallHealth': _calculateOverallHealthScore(),
    };
  }

  double _calculateOverallHealthScore() {
    final scores = progressScores;
    return (scores['workoutConsistency']! +
            scores['waterHydration']! +
            scores['sleepQuality']!) /
        3;
  }

  // Weekly summary
  Map<String, dynamic> get weeklySummary {
    final progress = weeklyProgress;
    final scores = progressScores;

    return {
      'workouts': {
        'total': progress['totalWorkouts']!.toInt(),
        'volume': progress['totalVolume'],
        'calories': progress['totalCalories']!.toInt(),
        'averageDuration': progress['avgWorkoutDuration'],
        'score': scores['workoutConsistency'],
      },
      'water': {
        'averageIntake': progress['avgWaterIntake'],
        'goalDays': progress['waterGoalDays']!.toInt(),
        'score': scores['waterHydration'],
      },
      'sleep': {
        'averageHours': progress['avgSleepHours'],
        'averageQuality': progress['avgSleepQuality'],
        'goalDays': progress['sleepGoalDays']!.toInt(),
        'score': scores['sleepQuality'],
      },
      'overall': {
        'score': scores['overallHealth'],
        'achievements': achievements.values
            .where((achieved) => achieved)
            .length,
        'personalRecords': personalRecords.length,
      },
    };
  }

  // Monthly summary
  Map<String, dynamic> get monthlySummary {
    final progress = monthlyProgress;

    return {
      'workouts': {
        'total': progress['totalWorkouts']!.toInt(),
        'volume': progress['totalVolume'],
        'calories': progress['totalCalories']!.toInt(),
        'streak': progress['workoutStreak']!.toInt(),
      },
      'water': {
        'goalDays': progress['waterGoalDays']!.toInt(),
        'goalPercentage': progress['waterGoalPercentage'],
      },
      'sleep': {
        'goalDays': progress['sleepGoalDays']!.toInt(),
        'goalPercentage': progress['sleepGoalPercentage'],
        'averageQuality': progress['avgSleepQuality'],
      },
      'achievements': achievements.values.where((achieved) => achieved).length,
      'personalRecords': personalRecords.length,
    };
  }

  EnhancedProgressProvider({
    required List<EnhancedWorkoutModel> workouts,
    required List<EnhancedWaterLogModel> waterLogs,
    required List<EnhancedSleepLogModel> sleepLogs,
  }) : _workouts = workouts,
       _waterLogs = waterLogs,
       _sleepLogs = sleepLogs;

  // Update data sources
  void updateWorkouts(List<EnhancedWorkoutModel> workouts) {
    _workouts.clear();
    _workouts.addAll(workouts);
    notifyListeners();
  }

  void updateWaterLogs(List<EnhancedWaterLogModel> waterLogs) {
    _waterLogs.clear();
    _waterLogs.addAll(waterLogs);
    notifyListeners();
  }

  void updateSleepLogs(List<EnhancedSleepLogModel> sleepLogs) {
    _sleepLogs.clear();
    _sleepLogs.addAll(sleepLogs);
    notifyListeners();
  }

  // Helper methods
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
}

