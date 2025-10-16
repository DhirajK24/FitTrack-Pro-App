import 'package:flutter/material.dart';
import '../models/analytics_model.dart';
import '../models/workout_model.dart';
import '../repositories/analytics_repository.dart';
import '../repositories/workout_repository.dart';
import '../repositories/wellness_repository.dart';

class AnalyticsProvider extends ChangeNotifier {
  AnalyticsRepository? _repository;
  WorkoutRepository? _workoutRepository;
  WaterRepository? _waterRepository;
  SleepRepository? _sleepRepository;

  // State
  List<AnalyticsData> _analyticsData = [];
  List<Achievement> _achievements = [];
  List<Insight> _insights = [];
  List<WeeklyReport> _weeklyReports = [];
  bool _isLoading = false;

  // Getters
  List<AnalyticsData> get analyticsData => _analyticsData;
  List<Achievement> get achievements => _achievements;
  List<Insight> get insights => _insights;
  List<WeeklyReport> get weeklyReports => _weeklyReports;
  bool get isLoading => _isLoading;

  // Unlocked achievements
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  // Unread insights
  List<Insight> get unreadInsights =>
      _insights.where((i) => !i.isRead).toList();

  // Total points
  int get totalPoints => _achievements
      .where((a) => a.isUnlocked)
      .fold(0, (sum, a) => sum + a.points);

  AnalyticsProvider(this._repository);

  // Update repositories after initialization
  void updateRepositories({
    required AnalyticsRepository analyticsRepository,
    WorkoutRepository? workoutRepository,
    WaterRepository? waterRepository,
    SleepRepository? sleepRepository,
  }) {
    _repository = analyticsRepository;
    _workoutRepository = workoutRepository;
    _waterRepository = waterRepository;
    _sleepRepository = sleepRepository;
  }

  // Initialize provider
  Future<void> initialize() async {
    if (_repository == null) return;

    _setLoading(true);

    try {
      await _loadAnalyticsData();
      await _loadAchievements();
      await _loadInsights();
      await _loadWeeklyReports();
    } catch (e) {
      debugPrint('Error initializing AnalyticsProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load analytics data
  Future<void> _loadAnalyticsData() async {
    if (_repository == null) return;
    _analyticsData = await _repository!.getLastNDays(30);
  }

  // Load achievements
  Future<void> _loadAchievements() async {
    if (_repository == null) return;
    _achievements = await _repository!.getAchievements();
  }

  // Load insights
  Future<void> _loadInsights() async {
    if (_repository == null) return;
    _insights = await _repository!.getInsights();
  }

  // Load weekly reports
  Future<void> _loadWeeklyReports() async {
    if (_repository == null) return;
    _weeklyReports = await _repository!.getWeeklyReports();
  }

  // Generate daily analytics data
  Future<void> generateDailyData() async {
    if (_repository == null ||
        _workoutRepository == null ||
        _waterRepository == null ||
        _sleepRepository == null)
      return;

    try {
      final today = DateTime.now();
      final todayData = await _repository!.getDataForDate(today);

      if (todayData != null) return; // Already generated for today

      // Get today's data from other repositories
      final waterLogs = await _waterRepository!.getLogsByDate(today);
      final sleepLogs = await _sleepRepository!.getLogsByDate(today);
      final workouts = await _workoutRepository!.getWorkoutsByDateRange(
        DateTime(today.year, today.month, today.day),
        DateTime(today.year, today.month, today.day, 23, 59, 59),
      );

      // Calculate metrics
      final waterIntake = waterLogs.fold<int>(
        0,
        (sum, log) => sum + log.amountMl,
      );
      final sleepDuration = sleepLogs.isNotEmpty
          ? sleepLogs.first.duration
          : null;
      final workoutMinutes = workouts.fold<int>(
        0,
        (sum, w) => sum + (w.totalDuration?.inMinutes ?? 0),
      );
      final completedWorkouts = workouts
          .where((w) => w.status == WorkoutStatus.completed)
          .length;

      // Create analytics data
      final analyticsData = AnalyticsData(
        date: today,
        waterIntakeMl: waterIntake,
        sleepDuration: sleepDuration,
        workoutMinutes: workoutMinutes,
        completedWorkouts: completedWorkouts,
        caloriesBurned: workoutMinutes * 8, // Rough estimate
        steps: 0, // Would come from step counter
      );

      await _repository!.saveDailyData(analyticsData);
      _analyticsData.insert(0, analyticsData);
      notifyListeners();

      // Check for achievements
      await _checkAchievements();

      // Generate insights
      await _generateInsights();
    } catch (e) {
      debugPrint('Error generating daily data: $e');
    }
  }

  // Check and unlock achievements
  Future<void> _checkAchievements() async {
    if (_repository == null) return;

    final today = DateTime.now();
    final last7Days = await _repository!.getLastNDays(7);
    final last30Days = await _repository!.getLastNDays(30);

    // Check water achievement
    final waterGoalMet = last7Days.every(
      (data) => data.waterIntakeMl != null && data.waterIntakeMl! >= 2000,
    );
    if (waterGoalMet) {
      await _unlockAchievement('water_week');
    }

    // Check sleep achievement
    final sleepGoalMet = last7Days.every(
      (data) => data.sleepDuration != null && data.sleepDuration!.inHours >= 7,
    );
    if (sleepGoalMet) {
      await _unlockAchievement('sleep_week');
    }

    // Check workout streak
    final workoutDays = last7Days
        .where(
          (data) =>
              data.completedWorkouts != null && data.completedWorkouts! > 0,
        )
        .length;
    if (workoutDays >= 7) {
      await _unlockAchievement('workout_streak_7');
    }

    final workoutDays30 = last30Days
        .where(
          (data) =>
              data.completedWorkouts != null && data.completedWorkouts! > 0,
        )
        .length;
    if (workoutDays30 >= 30) {
      await _unlockAchievement('workout_streak_30');
    }
  }

  // Unlock achievement
  Future<void> _unlockAchievement(String achievementId) async {
    if (_repository == null) return;

    final achievement = _achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => throw Exception('Achievement not found'),
    );

    if (!achievement.isUnlocked) {
      await _repository!.unlockAchievement(achievementId);
      await _loadAchievements();
      notifyListeners();
    }
  }

  // Generate insights
  Future<void> _generateInsights() async {
    if (_repository == null) return;

    final last7Days = await _repository!.getLastNDays(7);
    if (last7Days.length < 3) return; // Need at least 3 days of data

    final insights = <Insight>[];

    // Water intake insight
    final avgWater =
        last7Days
            .where((d) => d.waterIntakeMl != null)
            .map((d) => d.waterIntakeMl!)
            .fold(0, (sum, ml) => sum + ml) /
        last7Days.where((d) => d.waterIntakeMl != null).length;

    if (avgWater < 2000) {
      insights.add(
        Insight(
          id: 'water_insight_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Hydration Reminder',
          description:
              'Your average water intake is ${(avgWater / 1000).toStringAsFixed(1)}L. Try to reach 2L daily for better health.',
          type: 'nutrition',
          color: Colors.cyan,
          actionText: 'Log Water',
          actionRoute: '/wellness/water',
          createdAt: DateTime.now(),
          isRead: false,
        ),
      );
    }

    // Sleep insight
    final avgSleep =
        last7Days
            .where((d) => d.sleepDuration != null)
            .map((d) => d.sleepDuration!.inHours)
            .fold(0.0, (sum, hours) => sum + hours) /
        last7Days.where((d) => d.sleepDuration != null).length;

    if (avgSleep < 7) {
      insights.add(
        Insight(
          id: 'sleep_insight_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Sleep Optimization',
          description:
              'You\'re averaging ${avgSleep.toStringAsFixed(1)} hours of sleep. Aim for 7-9 hours for optimal recovery.',
          type: 'sleep',
          color: Colors.purple,
          actionText: 'Log Sleep',
          actionRoute: '/wellness/sleep',
          createdAt: DateTime.now(),
          isRead: false,
        ),
      );
    }

    // Workout insight
    final workoutDays = last7Days
        .where((d) => d.completedWorkouts != null && d.completedWorkouts! > 0)
        .length;

    if (workoutDays < 3) {
      insights.add(
        Insight(
          id: 'workout_insight_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Stay Active',
          description:
              'You\'ve worked out $workoutDays days this week. Try to aim for at least 3-4 workouts per week.',
          type: 'workout',
          color: Colors.orange,
          actionText: 'Start Workout',
          actionRoute: '/workout/logger',
          createdAt: DateTime.now(),
          isRead: false,
        ),
      );
    }

    // Save insights
    for (final insight in insights) {
      await _repository!.saveInsight(insight);
    }

    if (insights.isNotEmpty) {
      await _loadInsights();
      notifyListeners();
    }
  }

  // Mark insight as read
  Future<void> markInsightAsRead(String insightId) async {
    if (_repository == null) return;

    await _repository!.markInsightAsRead(insightId);
    await _loadInsights();
    notifyListeners();
  }

  // Get progress metrics for a specific metric
  ProgressMetrics getProgressMetrics(String metric, int days) {
    final recentData = _analyticsData.take(days).toList();
    if (recentData.length < 2) {
      return ProgressMetrics(
        currentValue: 0,
        previousValue: 0,
        targetValue: 0,
        unit: '',
        label: metric,
        color: Colors.grey,
        percentageChange: 0,
        isPositiveChange: false,
      );
    }

    double currentValue = 0;
    double previousValue = 0;
    String unit = '';
    Color color = Colors.grey;

    switch (metric) {
      case 'water':
        currentValue = recentData.first.waterIntakeMl?.toDouble() ?? 0;
        previousValue = recentData[1].waterIntakeMl?.toDouble() ?? 0;
        unit = 'ml';
        color = Colors.cyan;
        break;
      case 'sleep':
        currentValue = recentData.first.sleepDuration?.inHours.toDouble() ?? 0;
        previousValue = recentData[1].sleepDuration?.inHours.toDouble() ?? 0;
        unit = 'hours';
        color = Colors.purple;
        break;
      case 'workouts':
        currentValue = recentData.first.completedWorkouts?.toDouble() ?? 0;
        previousValue = recentData[1].completedWorkouts?.toDouble() ?? 0;
        unit = 'workouts';
        color = Colors.orange;
        break;
    }

    final percentageChange = previousValue > 0
        ? ((currentValue - previousValue) / previousValue) * 100
        : 0.0;

    return ProgressMetrics(
      currentValue: currentValue,
      previousValue: previousValue,
      targetValue: metric == 'water' ? 2000 : (metric == 'sleep' ? 8 : 3),
      unit: unit,
      label: metric,
      color: color,
      percentageChange: percentageChange,
      isPositiveChange: percentageChange > 0,
    );
  }

  // Generate weekly report
  Future<WeeklyReport> generateWeeklyReport() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final weekData = await _repository!.getDataForDateRange(weekStart, weekEnd);

    final totalWorkouts = weekData.fold<int>(
      0,
      (sum, d) => sum + (d.completedWorkouts ?? 0),
    );
    final totalWorkoutMinutes = weekData.fold<int>(
      0,
      (sum, d) => sum + (d.workoutMinutes ?? 0),
    );
    final avgWaterIntake =
        weekData
            .where((d) => d.waterIntakeMl != null)
            .map((d) => d.waterIntakeMl!)
            .fold(0, (sum, ml) => sum + ml) /
        weekData.where((d) => d.waterIntakeMl != null).length;
    final avgSleepHours =
        weekData
            .where((d) => d.sleepDuration != null)
            .map((d) => d.sleepDuration!.inHours)
            .fold(0.0, (sum, hours) => sum + hours) /
        weekData.where((d) => d.sleepDuration != null).length;
    final totalSteps = weekData.fold<int>(0, (sum, d) => sum + (d.steps ?? 0));
    final caloriesBurned = weekData.fold<int>(
      0,
      (sum, d) => sum + (d.caloriesBurned ?? 0),
    );

    final newAchievements = _achievements
        .where(
          (a) =>
              a.isUnlocked &&
              a.unlockedAt != null &&
              a.unlockedAt!.isAfter(weekStart),
        )
        .toList();

    final weekInsights = _insights
        .where((i) => i.createdAt.isAfter(weekStart))
        .toList();

    String summary = _generateWeeklySummary(
      totalWorkouts,
      totalWorkoutMinutes,
      avgWaterIntake,
      avgSleepHours,
      totalSteps,
      caloriesBurned,
    );

    final report = WeeklyReport(
      weekStart: weekStart,
      weekEnd: weekEnd,
      totalWorkouts: totalWorkouts,
      totalWorkoutMinutes: totalWorkoutMinutes,
      averageWaterIntake: avgWaterIntake,
      averageSleepHours: avgSleepHours,
      totalSteps: totalSteps,
      caloriesBurned: caloriesBurned,
      newAchievements: newAchievements,
      insights: weekInsights,
      summary: summary,
    );

    await _repository!.saveWeeklyReport(report);
    _weeklyReports.add(report);
    notifyListeners();

    return report;
  }

  String _generateWeeklySummary(
    int workouts,
    int minutes,
    double water,
    double sleep,
    int steps,
    int calories,
  ) {
    final buffer = StringBuffer();

    buffer.writeln(
      'This week you completed $workouts workouts totaling ${minutes ~/ 60} hours.',
    );
    buffer.writeln(
      'You averaged ${(water / 1000).toStringAsFixed(1)}L of water and ${sleep.toStringAsFixed(1)} hours of sleep daily.',
    );
    buffer.writeln(
      'You burned approximately $calories calories and took $steps steps.',
    );

    if (workouts >= 4) {
      buffer.writeln('Great job maintaining a consistent workout routine!');
    } else if (workouts >= 2) {
      buffer.writeln('Good progress! Try to add one more workout next week.');
    } else {
      buffer.writeln(
        'Consider adding more workouts to your routine for better results.',
      );
    }

    return buffer.toString();
  }

  // Refresh data
  Future<void> refresh() async {
    _setLoading(true);
    try {
      await _loadAnalyticsData();
      await _loadAchievements();
      await _loadInsights();
      await _loadWeeklyReports();
    } catch (e) {
      debugPrint('Error refreshing analytics: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
