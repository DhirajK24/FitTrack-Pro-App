import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analytics_model.dart';
import 'base_repository.dart';

class AnalyticsRepository extends BaseRepository<AnalyticsData> {
  static const String _key = 'analytics_data';
  static const String _achievementsKey = 'achievements';
  static const String _insightsKey = 'insights';
  static const String _weeklyReportsKey = 'weekly_reports';

  AnalyticsRepository(SharedPreferences prefs) : super(_key, prefs) {
    _prefs = prefs;
  }

  late final SharedPreferences _prefs;

  @override
  Map<String, dynamic> toJson(AnalyticsData item) => item.toJson();

  @override
  AnalyticsData fromJson(Map<String, dynamic> json) =>
      AnalyticsData.fromJson(json);

  @override
  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // Analytics data methods
  Future<void> saveDailyData(AnalyticsData data) async {
    await save(data);
  }

  Future<List<AnalyticsData>> getDataForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final allData = await getAll();
    return allData.where((data) {
      return data.date.isAfter(start.subtract(const Duration(days: 1))) &&
          data.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<AnalyticsData?> getDataForDate(DateTime date) async {
    final allData = await getAll();
    try {
      return allData.firstWhere((data) {
        return data.date.year == date.year &&
            data.date.month == date.month &&
            data.date.day == date.day;
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<AnalyticsData>> getLastNDays(int days) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    return getDataForDateRange(startDate, endDate);
  }

  // Achievement methods
  Future<List<Achievement>> getAchievements() async {
    final jsonString = _prefs.getString(_achievementsKey);
    if (jsonString == null) return _getDefaultAchievements();

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => Achievement.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAchievements(List<Achievement> achievements) async {
    final jsonList = achievements.map((a) => a.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_achievementsKey, jsonString);
  }

  Future<void> unlockAchievement(String achievementId) async {
    final achievements = await getAchievements();
    final updatedAchievements = achievements.map((achievement) {
      if (achievement.id == achievementId && !achievement.isUnlocked) {
        return Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          icon: achievement.icon,
          color: achievement.color,
          isUnlocked: true,
          unlockedAt: DateTime.now(),
          points: achievement.points,
          category: achievement.category,
        );
      }
      return achievement;
    }).toList();
    await saveAchievements(updatedAchievements);
  }

  // Insight methods
  Future<List<Insight>> getInsights() async {
    final jsonString = _prefs.getString(_insightsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => Insight.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveInsight(Insight insight) async {
    final insights = await getInsights();
    insights.add(insight);
    final jsonList = insights.map((i) => i.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_insightsKey, jsonString);
  }

  Future<void> markInsightAsRead(String insightId) async {
    final insights = await getInsights();
    final updatedInsights = insights.map((insight) {
      if (insight.id == insightId) {
        return Insight(
          id: insight.id,
          title: insight.title,
          description: insight.description,
          type: insight.type,
          color: insight.color,
          actionText: insight.actionText,
          actionRoute: insight.actionRoute,
          createdAt: insight.createdAt,
          isRead: true,
        );
      }
      return insight;
    }).toList();
    final jsonList = updatedInsights.map((i) => i.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_insightsKey, jsonString);
  }

  // Weekly report methods
  Future<List<WeeklyReport>> getWeeklyReports() async {
    final jsonString = _prefs.getString(_weeklyReportsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => WeeklyReport.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveWeeklyReport(WeeklyReport report) async {
    final reports = await getWeeklyReports();
    reports.add(report);
    final jsonList = reports.map((r) => r.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_weeklyReportsKey, jsonString);
  }

  // Default achievements
  List<Achievement> _getDefaultAchievements() {
    return [
      Achievement(
        id: 'first_workout',
        title: 'First Steps',
        description: 'Complete your first workout',
        icon: '🏃‍♂️',
        color: Colors.blue,
        isUnlocked: false,
        points: 10,
        category: AchievementCategory.workout,
      ),
      Achievement(
        id: 'water_week',
        title: 'Hydration Hero',
        description: 'Meet your water goal for 7 consecutive days',
        icon: '💧',
        color: Colors.cyan,
        isUnlocked: false,
        points: 25,
        category: AchievementCategory.nutrition,
      ),
      Achievement(
        id: 'sleep_week',
        title: 'Sleep Champion',
        description: 'Get 7+ hours of sleep for 7 consecutive days',
        icon: '😴',
        color: Colors.purple,
        isUnlocked: false,
        points: 25,
        category: AchievementCategory.sleep,
      ),
      Achievement(
        id: 'workout_streak_7',
        title: 'Week Warrior',
        description: 'Work out for 7 consecutive days',
        icon: '💪',
        color: Colors.orange,
        isUnlocked: false,
        points: 50,
        category: AchievementCategory.consistency,
      ),
      Achievement(
        id: 'workout_streak_30',
        title: 'Month Master',
        description: 'Work out for 30 consecutive days',
        icon: '🏆',
        color: Colors.amber,
        isUnlocked: false,
        points: 100,
        category: AchievementCategory.milestone,
      ),
      Achievement(
        id: 'weight_loss_5kg',
        title: 'Weight Loss Warrior',
        description: 'Lose 5kg from your starting weight',
        icon: '⚖️',
        color: Colors.green,
        isUnlocked: false,
        points: 75,
        category: AchievementCategory.milestone,
      ),
    ];
  }
}
