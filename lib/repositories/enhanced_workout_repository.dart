import 'package:hive/hive.dart';
import '../models/enhanced_workout_model.dart';
import '../services/hive_storage_service.dart';

class EnhancedWorkoutRepository {
  Box<EnhancedWorkoutModel>? _box;

  Future<void> initialize() async {
    _box = await HiveStorageService.getWorkoutsBox();
  }

  Future<void> ensureInitialized() async {
    if (_box == null) {
      await initialize();
    }
  }

  // CRUD Operations
  Future<String> saveWorkout(EnhancedWorkoutModel workout) async {
    await ensureInitialized();
    await _box!.put(workout.id, workout);
    return workout.id;
  }

  Future<EnhancedWorkoutModel?> getWorkout(String id) async {
    await ensureInitialized();
    return _box!.get(id);
  }

  Future<List<EnhancedWorkoutModel>> getAllWorkouts() async {
    await ensureInitialized();
    return _box!.values.toList();
  }

  Future<List<EnhancedWorkoutModel>> getWorkoutsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    await ensureInitialized();
    return _box!.values.where((workout) {
      return workout.startTime.isAfter(
            start.subtract(const Duration(days: 1)),
          ) &&
          workout.startTime.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<List<EnhancedWorkoutModel>> getWorkoutsByStatus(
    WorkoutStatus status,
  ) async {
    await ensureInitialized();
    return _box!.values.where((workout) => workout.status == status).toList();
  }

  Future<List<EnhancedWorkoutModel>> getRecentWorkouts(int limit) async {
    await ensureInitialized();
    final workouts = _box!.values.toList();
    workouts.sort((a, b) => b.startTime.compareTo(a.startTime));
    return workouts.take(limit).toList();
  }

  Future<void> updateWorkout(EnhancedWorkoutModel workout) async {
    await ensureInitialized();
    final updatedWorkout = workout.copyWith(updatedAt: DateTime.now());
    await _box!.put(workout.id, updatedWorkout);
  }

  Future<void> deleteWorkout(String id) async {
    await ensureInitialized();
    await _box!.delete(id);
  }

  // Statistics
  Future<Map<String, dynamic>> getWorkoutStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await ensureInitialized();
    final workouts = await getWorkoutsByDateRange(startDate, endDate);
    final completedWorkouts = workouts
        .where((w) => w.status == WorkoutStatus.completed)
        .toList();

    if (completedWorkouts.isEmpty) {
      return {
        'totalWorkouts': 0,
        'totalVolume': 0.0,
        'totalCalories': 0,
        'totalDuration': Duration.zero,
        'averageWorkoutDuration': Duration.zero,
        'workoutStreak': 0,
      };
    }

    final totalVolume = completedWorkouts.fold(
      0.0,
      (sum, w) => sum + (w.totalVolume ?? 0.0),
    );
    final totalCalories = completedWorkouts.fold(
      0,
      (sum, w) => sum + (w.caloriesBurned ?? 0),
    );
    final totalDuration = completedWorkouts.fold<Duration>(Duration.zero, (
      sum,
      w,
    ) {
      if (w.duration != null) {
        return sum + w.duration!;
      }
      return sum;
    });

    return {
      'totalWorkouts': completedWorkouts.length,
      'totalVolume': totalVolume,
      'totalCalories': totalCalories,
      'totalDuration': totalDuration,
      'averageWorkoutDuration': Duration(
        minutes: totalDuration.inMinutes ~/ completedWorkouts.length,
      ),
      'workoutStreak': _calculateStreak(completedWorkouts),
    };
  }

  int _calculateStreak(List<EnhancedWorkoutModel> workouts) {
    if (workouts.isEmpty) return 0;

    // Sort by date (most recent first)
    final sortedWorkouts = List<EnhancedWorkoutModel>.from(workouts)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    int streak = 0;
    DateTime? lastWorkoutDate;

    for (final workout in sortedWorkouts) {
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

  // Search and Filter
  Future<List<EnhancedWorkoutModel>> searchWorkouts(String query) async {
    await ensureInitialized();
    final lowercaseQuery = query.toLowerCase();
    return _box!.values.where((workout) {
      return workout.name.toLowerCase().contains(lowercaseQuery) ||
          (workout.notes?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  Future<List<EnhancedWorkoutModel>> getWorkoutsByExercise(
    String exerciseName,
  ) async {
    await ensureInitialized();
    return _box!.values.where((workout) {
      return workout.exercises.any(
        (exercise) =>
            exercise.name.toLowerCase().contains(exerciseName.toLowerCase()),
      );
    }).toList();
  }

  // Sync operations for future cloud integration
  Future<List<EnhancedWorkoutModel>> getUnsyncedWorkouts() async {
    await ensureInitialized();
    return _box!.values.where((workout) => !workout.synced).toList();
  }

  Future<void> markAsSynced(String id, String remoteId) async {
    await ensureInitialized();
    final workout = await getWorkout(id);
    if (workout != null) {
      final syncedWorkout = workout.copyWith(
        synced: true,
        remoteId: remoteId,
        updatedAt: DateTime.now(),
      );
      await updateWorkout(syncedWorkout);
    }
  }

  Future<void> markAsUnsynced(String id) async {
    await ensureInitialized();
    final workout = await getWorkout(id);
    if (workout != null) {
      final unsyncedWorkout = workout.copyWith(
        synced: false,
        updatedAt: DateTime.now(),
      );
      await updateWorkout(unsyncedWorkout);
    }
  }

  // Cleanup
  Future<void> close() async {
    await _box?.close();
  }
}
