import '../models/enhanced_workout_model.dart';
import '../models/enhanced_water_model.dart';
import '../models/enhanced_sleep_model.dart';

class ProgressUtils {
  // Workout Progress Calculations
  static double calculateTotalVolume(List<EnhancedWorkoutModel> workouts) {
    return workouts.fold(
      0.0,
      (sum, workout) => sum + (workout.totalVolume ?? 0.0),
    );
  }

  static int calculateTotalCalories(List<EnhancedWorkoutModel> workouts) {
    return workouts.fold(
      0,
      (sum, workout) => sum + (workout.caloriesBurned ?? 0),
    );
  }

  static int calculateTotalWorkouts(List<EnhancedWorkoutModel> workouts) {
    return workouts.where((w) => w.status == WorkoutStatus.completed).length;
  }

  static Duration calculateTotalWorkoutTime(
    List<EnhancedWorkoutModel> workouts,
  ) {
    final totalMinutes = workouts.fold(0, (sum, workout) {
      if (workout.duration != null) {
        return sum + workout.duration!.inMinutes;
      }
      return sum;
    });
    return Duration(minutes: totalMinutes);
  }

  static double calculateAverageWorkoutDuration(
    List<EnhancedWorkoutModel> workouts,
  ) {
    final completedWorkouts = workouts.where(
      (w) => w.status == WorkoutStatus.completed,
    );
    if (completedWorkouts.isEmpty) return 0.0;

    final totalMinutes = completedWorkouts.fold(0, (sum, workout) {
      if (workout.duration != null) {
        return sum + workout.duration!.inMinutes;
      }
      return sum;
    });

    return totalMinutes / completedWorkouts.length;
  }

  static int calculateWorkoutStreak(List<EnhancedWorkoutModel> workouts) {
    if (workouts.isEmpty) return 0;

    // Sort workouts by date (most recent first)
    final sortedWorkouts = List<EnhancedWorkoutModel>.from(workouts)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    int streak = 0;
    DateTime? lastWorkoutDate;

    for (final workout in sortedWorkouts) {
      if (workout.status != WorkoutStatus.completed) continue;

      final workoutDate = DateTime(
        workout.startTime.year,
        workout.startTime.month,
        workout.startTime.day,
      );

      if (lastWorkoutDate == null) {
        lastWorkoutDate = workoutDate;
        streak = 1;
      } else {
        final daysDifference = lastWorkoutDate.difference(workoutDate).inDays;
        if (daysDifference == 1) {
          streak++;
          lastWorkoutDate = workoutDate;
        } else if (daysDifference > 1) {
          break;
        }
      }
    }

    return streak;
  }

  // Water Progress Calculations
  static int calculateDailyWaterIntake(
    List<EnhancedWaterLogModel> logs,
    DateTime date,
  ) {
    return logs
        .where(
          (log) =>
              log.timestamp.year == date.year &&
              log.timestamp.month == date.month &&
              log.timestamp.day == date.day,
        )
        .fold(0, (sum, log) => sum + log.amountMl);
  }

  static double calculateWeeklyAverageWater(
    List<EnhancedWaterLogModel> logs,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekLogs = logs.where(
      (log) =>
          log.timestamp.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          log.timestamp.isBefore(weekEnd),
    );

    if (weekLogs.isEmpty) return 0.0;

    final totalMl = weekLogs.fold(0, (sum, log) => sum + log.amountMl);
    return totalMl / 7.0; // Average per day
  }

  static int calculateWaterGoalAchievementDays(
    List<EnhancedWaterLogModel> logs,
    int goalMl,
    DateTime startDate,
    int days,
  ) {
    int achievementDays = 0;

    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyIntake = calculateDailyWaterIntake(logs, date);
      if (dailyIntake >= goalMl) {
        achievementDays++;
      }
    }

    return achievementDays;
  }

  static double calculateWaterGoalPercentage(
    List<EnhancedWaterLogModel> logs,
    int goalMl,
    DateTime date,
  ) {
    final dailyIntake = calculateDailyWaterIntake(logs, date);
    if (goalMl == 0) return 0.0;
    return (dailyIntake / goalMl * 100).clamp(0.0, 200.0); // Cap at 200%
  }

  // Sleep Progress Calculations
  static double calculateDailySleepHours(
    List<EnhancedSleepLogModel> logs,
    DateTime date,
  ) {
    final dayLogs = logs.where(
      (log) =>
          log.bedtime.year == date.year &&
          log.bedtime.month == date.month &&
          log.bedtime.day == date.day,
    );

    if (dayLogs.isEmpty) return 0.0;

    final totalMinutes = dayLogs.fold(
      0,
      (sum, log) => sum + log.duration.inMinutes,
    );
    return totalMinutes / 60.0;
  }

  static double calculateWeeklyAverageSleep(
    List<EnhancedSleepLogModel> logs,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekLogs = logs.where(
      (log) =>
          log.bedtime.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          log.bedtime.isBefore(weekEnd),
    );

    if (weekLogs.isEmpty) return 0.0;

    final totalHours = weekLogs.fold(
      0.0,
      (sum, log) => sum + log.durationHours,
    );
    return totalHours / 7.0; // Average per day
  }

  static double calculateAverageSleepQuality(
    List<EnhancedSleepLogModel> logs,
    DateTime startDate,
    int days,
  ) {
    final endDate = startDate.add(Duration(days: days));
    final periodLogs = logs.where(
      (log) =>
          log.bedtime.isAfter(startDate.subtract(const Duration(days: 1))) &&
          log.bedtime.isBefore(endDate),
    );

    if (periodLogs.isEmpty) return 0.0;

    final totalQuality = periodLogs.fold(
      0.0,
      (sum, log) => sum + log.quality.index + 1,
    );
    return totalQuality / periodLogs.length;
  }

  static int calculateSleepGoalAchievementDays(
    List<EnhancedSleepLogModel> logs,
    double targetHours,
    DateTime startDate,
    int days,
  ) {
    int achievementDays = 0;

    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyHours = calculateDailySleepHours(logs, date);
      if (dailyHours >= targetHours) {
        achievementDays++;
      }
    }

    return achievementDays;
  }

  // General Progress Calculations
  static Map<String, double> calculateWeeklyProgress({
    required List<EnhancedWorkoutModel> workouts,
    required List<EnhancedWaterLogModel> waterLogs,
    required List<EnhancedSleepLogModel> sleepLogs,
    required int waterGoalMl,
    required double sleepGoalHours,
    required DateTime weekStart,
  }) {
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Workout metrics
    final weekWorkouts = workouts.where(
      (w) =>
          w.startTime.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          w.startTime.isBefore(weekEnd),
    );

    final totalWorkouts = weekWorkouts
        .where((w) => w.status == WorkoutStatus.completed)
        .length;
    final totalVolume = calculateTotalVolume(weekWorkouts.toList());
    final totalCalories = calculateTotalCalories(weekWorkouts.toList());
    final avgWorkoutDuration = calculateAverageWorkoutDuration(
      weekWorkouts.toList(),
    );

    // Water metrics
    final avgWaterIntake = calculateWeeklyAverageWater(waterLogs, weekStart);
    final waterGoalDays = calculateWaterGoalAchievementDays(
      waterLogs,
      waterGoalMl,
      weekStart,
      7,
    );

    // Sleep metrics
    final avgSleepHours = calculateWeeklyAverageSleep(sleepLogs, weekStart);
    final sleepGoalDays = calculateSleepGoalAchievementDays(
      sleepLogs,
      sleepGoalHours,
      weekStart,
      7,
    );
    final avgSleepQuality = calculateAverageSleepQuality(
      sleepLogs,
      weekStart,
      7,
    );

    return {
      'totalWorkouts': totalWorkouts.toDouble(),
      'totalVolume': totalVolume,
      'totalCalories': totalCalories.toDouble(),
      'avgWorkoutDuration': avgWorkoutDuration,
      'avgWaterIntake': avgWaterIntake,
      'waterGoalDays': waterGoalDays.toDouble(),
      'avgSleepHours': avgSleepHours,
      'sleepGoalDays': sleepGoalDays.toDouble(),
      'avgSleepQuality': avgSleepQuality,
    };
  }

  static Map<String, double> calculateMonthlyProgress({
    required List<EnhancedWorkoutModel> workouts,
    required List<EnhancedWaterLogModel> waterLogs,
    required List<EnhancedSleepLogModel> sleepLogs,
    required int waterGoalMl,
    required double sleepGoalHours,
    required DateTime monthStart,
  }) {
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
    final daysInMonth = monthEnd.day;

    // Workout metrics
    final monthWorkouts = workouts.where(
      (w) =>
          w.startTime.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          w.startTime.isBefore(monthEnd.add(const Duration(days: 1))),
    );

    final totalWorkouts = monthWorkouts
        .where((w) => w.status == WorkoutStatus.completed)
        .length;
    final totalVolume = calculateTotalVolume(monthWorkouts.toList());
    final totalCalories = calculateTotalCalories(monthWorkouts.toList());
    final workoutStreak = calculateWorkoutStreak(monthWorkouts.toList());

    // Water metrics
    final waterGoalDays = calculateWaterGoalAchievementDays(
      waterLogs,
      waterGoalMl,
      monthStart,
      daysInMonth,
    );
    final waterGoalPercentage = (waterGoalDays / daysInMonth * 100).clamp(
      0.0,
      100.0,
    );

    // Sleep metrics
    final sleepGoalDays = calculateSleepGoalAchievementDays(
      sleepLogs,
      sleepGoalHours,
      monthStart,
      daysInMonth,
    );
    final sleepGoalPercentage = (sleepGoalDays / daysInMonth * 100).clamp(
      0.0,
      100.0,
    );
    final avgSleepQuality = calculateAverageSleepQuality(
      sleepLogs,
      monthStart,
      daysInMonth,
    );

    return {
      'totalWorkouts': totalWorkouts.toDouble(),
      'totalVolume': totalVolume,
      'totalCalories': totalCalories.toDouble(),
      'workoutStreak': workoutStreak.toDouble(),
      'waterGoalDays': waterGoalDays.toDouble(),
      'waterGoalPercentage': waterGoalPercentage,
      'sleepGoalDays': sleepGoalDays.toDouble(),
      'sleepGoalPercentage': sleepGoalPercentage,
      'avgSleepQuality': avgSleepQuality,
    };
  }

  // Personal Records Detection
  static List<Map<String, dynamic>> detectPersonalRecords(
    List<EnhancedWorkoutModel> workouts,
  ) {
    final records = <Map<String, dynamic>>[];
    final exerciseRecords = <String, Map<String, double>>{};

    for (final workout in workouts) {
      if (workout.status != WorkoutStatus.completed) continue;

      for (final exercise in workout.exercises) {
        final exerciseName = exercise.name;

        if (!exerciseRecords.containsKey(exerciseName)) {
          exerciseRecords[exerciseName] = {
            'maxWeight': 0.0,
            'maxReps': 0,
            'maxVolume': 0.0,
          };
        }

        for (final set in exercise.sets) {
          final current = exerciseRecords[exerciseName]!;

          // Max weight
          if (set.weight > current['maxWeight']!) {
            current['maxWeight'] = set.weight;
            records.add({
              'type': 'maxWeight',
              'exercise': exerciseName,
              'value': set.weight,
              'date': workout.startTime,
              'workout': workout.name,
            });
          }

          // Max reps
          if (set.reps > current['maxReps']!) {
            current['maxReps'] = set.reps.toDouble();
            records.add({
              'type': 'maxReps',
              'exercise': exerciseName,
              'value': set.reps.toDouble(),
              'date': workout.startTime,
              'workout': workout.name,
            });
          }

          // Max volume (weight * reps)
          final volume = set.weight * set.reps;
          if (volume > current['maxVolume']!) {
            current['maxVolume'] = volume;
            records.add({
              'type': 'maxVolume',
              'exercise': exerciseName,
              'value': volume,
              'date': workout.startTime,
              'workout': workout.name,
            });
          }
        }
      }
    }

    // Sort by date (most recent first)
    records.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    return records;
  }

  // Additional missing methods - these are already implemented above

  static int calculateWeeklyWorkouts(
    List<EnhancedWorkoutModel> workouts,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return workouts.where((w) {
      return w.startTime.isAfter(weekStart) &&
          w.startTime.isBefore(weekEnd) &&
          w.status == WorkoutStatus.completed;
    }).length;
  }

  static double calculateWeeklyVolume(
    List<EnhancedWorkoutModel> workouts,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekWorkouts = workouts.where((w) {
      return w.startTime.isAfter(weekStart) &&
          w.startTime.isBefore(weekEnd) &&
          w.status == WorkoutStatus.completed;
    });
    return calculateTotalVolume(weekWorkouts.toList());
  }

  static Duration calculateWeeklyWorkoutTime(
    List<EnhancedWorkoutModel> workouts,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekWorkouts = workouts.where((w) {
      return w.startTime.isAfter(weekStart) &&
          w.startTime.isBefore(weekEnd) &&
          w.status == WorkoutStatus.completed;
    });
    return calculateTotalWorkoutTime(weekWorkouts.toList());
  }

  static int calculateWaterStreak(
    List<EnhancedWaterLogModel> waterLogs,
    int goalMl,
  ) {
    if (waterLogs.isEmpty) return 0;

    // Sort logs by date (most recent first)
    final sortedLogs = List<EnhancedWaterLogModel>.from(waterLogs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    // Group logs by date
    final Map<String, int> dailyIntake = {};
    for (final log in sortedLogs) {
      final dateKey =
          '${log.timestamp.year}-${log.timestamp.month}-${log.timestamp.day}';
      dailyIntake[dateKey] = (dailyIntake[dateKey] ?? 0) + log.amountMl;
    }

    // Check consecutive days from today backwards
    while (true) {
      final dateKey =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      final dailyAmount = dailyIntake[dateKey] ?? 0;

      if (dailyAmount >= goalMl) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  static int calculateSleepStreak(
    List<EnhancedSleepLogModel> sleepLogs,
    double goalHours,
  ) {
    if (sleepLogs.isEmpty) return 0;

    // Sort logs by date (most recent first)
    final sortedLogs = List<EnhancedSleepLogModel>.from(sleepLogs)
      ..sort((a, b) => b.bedtime.compareTo(a.bedtime));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    // Group logs by date
    final Map<String, double> dailySleep = {};
    for (final log in sortedLogs) {
      final dateKey =
          '${log.bedtime.year}-${log.bedtime.month}-${log.bedtime.day}';
      dailySleep[dateKey] = (dailySleep[dateKey] ?? 0.0) + log.durationHours;
    }

    // Check consecutive days from today backwards
    while (true) {
      final dateKey =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      final dailyHours = dailySleep[dateKey] ?? 0.0;

      if (dailyHours >= goalHours) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  static Map<String, dynamic> calculateWeeklyTrends({
    required List<EnhancedWorkoutModel> workouts,
    required List<EnhancedWaterLogModel> waterLogs,
    required List<EnhancedSleepLogModel> sleepLogs,
    required DateTime weekStart,
  }) {
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Workout trends
    final weekWorkouts = workouts.where((w) {
      return w.startTime.isAfter(weekStart) && w.startTime.isBefore(weekEnd);
    }).toList();

    // Water trends
    final weekWater = waterLogs.where((w) {
      return w.timestamp.isAfter(weekStart) && w.timestamp.isBefore(weekEnd);
    }).toList();

    // Sleep trends
    final weekSleep = sleepLogs.where((s) {
      return s.bedtime.isAfter(weekStart) && s.bedtime.isBefore(weekEnd);
    }).toList();

    return {
      'workouts': {
        'count': weekWorkouts.length,
        'volume': calculateTotalVolume(weekWorkouts),
        'calories': calculateTotalCalories(weekWorkouts),
      },
      'water': {
        'totalMl': weekWater.fold(0, (sum, log) => sum + log.amountMl),
        'avgDaily': weekWater.isNotEmpty
            ? weekWater.fold(0, (sum, log) => sum + log.amountMl) / 7
            : 0,
      },
      'sleep': {
        'avgHours': weekSleep.isNotEmpty
            ? weekSleep.fold(0.0, (sum, log) => sum + log.durationHours) / 7
            : 0.0,
        'avgQuality': weekSleep.isNotEmpty
            ? weekSleep.fold(0.0, (sum, log) => sum + log.quality.index) / 7
            : 0.0,
      },
    };
  }

  static bool checkGoalAchievement({
    required String goalType,
    required double currentValue,
    required double targetValue,
  }) {
    switch (goalType.toLowerCase()) {
      case 'workout':
      case 'water':
      case 'sleep':
        return currentValue >= targetValue;
      case 'weight_loss':
        return currentValue <= targetValue;
      default:
        return false;
    }
  }

  static double calculateWeeklyAverageWaterIntake(
    List<EnhancedWaterLogModel> waterLogs,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekLogs = waterLogs.where((log) {
      return log.timestamp.isAfter(weekStart) &&
          log.timestamp.isBefore(weekEnd);
    });

    if (weekLogs.isEmpty) return 0.0;

    final totalMl = weekLogs.fold(0, (sum, log) => sum + log.amountMl);
    return totalMl / 7.0; // Average per day
  }
}
