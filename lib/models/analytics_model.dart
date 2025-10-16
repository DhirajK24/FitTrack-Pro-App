import 'package:flutter/material.dart';

// Analytics data models for tracking user progress and insights

class AnalyticsData {
  final DateTime date;
  final double? weight;
  final int? waterIntakeMl;
  final Duration? sleepDuration;
  final int? caloriesBurned;
  final int? steps;
  final int? workoutMinutes;
  final int? completedWorkouts;
  final double? bodyFatPercentage;
  final double? muscleMass;

  AnalyticsData({
    required this.date,
    this.weight,
    this.waterIntakeMl,
    this.sleepDuration,
    this.caloriesBurned,
    this.steps,
    this.workoutMinutes,
    this.completedWorkouts,
    this.bodyFatPercentage,
    this.muscleMass,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'waterIntakeMl': waterIntakeMl,
      'sleepDuration': sleepDuration?.inMinutes,
      'caloriesBurned': caloriesBurned,
      'steps': steps,
      'workoutMinutes': workoutMinutes,
      'completedWorkouts': completedWorkouts,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
    };
  }

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      date: DateTime.parse(json['date'] as String),
      weight: json['weight'] as double?,
      waterIntakeMl: json['waterIntakeMl'] as int?,
      sleepDuration: json['sleepDuration'] != null
          ? Duration(minutes: json['sleepDuration'] as int)
          : null,
      caloriesBurned: json['caloriesBurned'] as int?,
      steps: json['steps'] as int?,
      workoutMinutes: json['workoutMinutes'] as int?,
      completedWorkouts: json['completedWorkouts'] as int?,
      bodyFatPercentage: json['bodyFatPercentage'] as double?,
      muscleMass: json['muscleMass'] as double?,
    );
  }

  AnalyticsData copyWith({
    DateTime? date,
    double? weight,
    int? waterIntakeMl,
    Duration? sleepDuration,
    int? caloriesBurned,
    int? steps,
    int? workoutMinutes,
    int? completedWorkouts,
    double? bodyFatPercentage,
    double? muscleMass,
  }) {
    return AnalyticsData(
      date: date ?? this.date,
      weight: weight ?? this.weight,
      waterIntakeMl: waterIntakeMl ?? this.waterIntakeMl,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      completedWorkouts: completedWorkouts ?? this.completedWorkouts,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
    );
  }
}

class ProgressMetrics {
  final double currentValue;
  final double previousValue;
  final double targetValue;
  final String unit;
  final String label;
  final Color color;
  final double percentageChange;
  final bool isPositiveChange;

  ProgressMetrics({
    required this.currentValue,
    required this.previousValue,
    required this.targetValue,
    required this.unit,
    required this.label,
    required this.color,
    required this.percentageChange,
    required this.isPositiveChange,
  });

  String get changeText {
    final change = percentageChange.abs();
    if (change < 0.1) return 'No change';
    return '${change.toStringAsFixed(1)}% ${isPositiveChange ? 'increase' : 'decrease'}';
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int points;
  final AchievementCategory category;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    this.unlockedAt,
    required this.points,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color.value,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'points': points,
      'category': category.name,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      color: Color(json['color'] as int),
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      points: json['points'] as int,
      category: AchievementCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => AchievementCategory.general,
      ),
    );
  }
}

enum AchievementCategory {
  general,
  workout,
  nutrition,
  sleep,
  consistency,
  milestone,
}

class Insight {
  final String id;
  final String title;
  final String description;
  final String type;
  final Color color;
  final String actionText;
  final String? actionRoute;
  final DateTime createdAt;
  final bool isRead;

  Insight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.color,
    required this.actionText,
    this.actionRoute,
    required this.createdAt,
    required this.isRead,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'color': color.value,
      'actionText': actionText,
      'actionRoute': actionRoute,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      color: Color(json['color'] as int),
      actionText: json['actionText'] as String,
      actionRoute: json['actionRoute'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
    );
  }
}

class WeeklyReport {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalWorkouts;
  final int totalWorkoutMinutes;
  final double averageWaterIntake;
  final double averageSleepHours;
  final int totalSteps;
  final int caloriesBurned;
  final List<Achievement> newAchievements;
  final List<Insight> insights;
  final String summary;

  WeeklyReport({
    required this.weekStart,
    required this.weekEnd,
    required this.totalWorkouts,
    required this.totalWorkoutMinutes,
    required this.averageWaterIntake,
    required this.averageSleepHours,
    required this.totalSteps,
    required this.caloriesBurned,
    required this.newAchievements,
    required this.insights,
    required this.summary,
  });

  Map<String, dynamic> toJson() {
    return {
      'weekStart': weekStart.toIso8601String(),
      'weekEnd': weekEnd.toIso8601String(),
      'totalWorkouts': totalWorkouts,
      'totalWorkoutMinutes': totalWorkoutMinutes,
      'averageWaterIntake': averageWaterIntake,
      'averageSleepHours': averageSleepHours,
      'totalSteps': totalSteps,
      'caloriesBurned': caloriesBurned,
      'newAchievements': newAchievements.map((a) => a.toJson()).toList(),
      'insights': insights.map((i) => i.toJson()).toList(),
      'summary': summary,
    };
  }

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      weekStart: DateTime.parse(json['weekStart'] as String),
      weekEnd: DateTime.parse(json['weekEnd'] as String),
      totalWorkouts: json['totalWorkouts'] as int,
      totalWorkoutMinutes: json['totalWorkoutMinutes'] as int,
      averageWaterIntake: json['averageWaterIntake'] as double,
      averageSleepHours: json['averageSleepHours'] as double,
      totalSteps: json['totalSteps'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      newAchievements: (json['newAchievements'] as List<dynamic>)
          .map((a) => Achievement.fromJson(a as Map<String, dynamic>))
          .toList(),
      insights: (json['insights'] as List<dynamic>)
          .map((i) => Insight.fromJson(i as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String,
    );
  }
}

