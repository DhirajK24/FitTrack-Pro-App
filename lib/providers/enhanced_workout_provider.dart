import 'package:flutter/material.dart';
import '../models/enhanced_workout_model.dart';
import '../repositories/enhanced_workout_repository.dart';
import '../utils/progress_utils.dart';

class EnhancedWorkoutProvider extends ChangeNotifier {
  final EnhancedWorkoutRepository _repository;

  // State
  List<EnhancedWorkoutModel> _workouts = [];
  EnhancedWorkoutModel? _currentWorkout;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<EnhancedWorkoutModel> get workouts => _workouts;
  EnhancedWorkoutModel? get currentWorkout => _currentWorkout;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered workouts
  List<EnhancedWorkoutModel> get completedWorkouts =>
      _workouts.where((w) => w.status == WorkoutStatus.completed).toList();

  List<EnhancedWorkoutModel> get inProgressWorkouts =>
      _workouts.where((w) => w.status == WorkoutStatus.inProgress).toList();

  List<EnhancedWorkoutModel> get plannedWorkouts =>
      _workouts.where((w) => w.status == WorkoutStatus.planned).toList();

  // Statistics
  double get totalVolume =>
      completedWorkouts.fold(0.0, (sum, w) => sum + (w.totalVolume ?? 0.0));

  int get totalCalories =>
      completedWorkouts.fold(0, (sum, w) => sum + (w.caloriesBurned ?? 0));

  int get totalWorkouts => completedWorkouts.length;

  int get workoutStreak =>
      ProgressUtils.calculateWorkoutStreak(completedWorkouts);

  Duration get totalWorkoutTime {
    final totalMinutes = completedWorkouts.fold(0, (sum, w) {
      if (w.duration != null) {
        return sum + w.duration!.inMinutes;
      }
      return sum;
    });
    return Duration(minutes: totalMinutes);
  }

  double get averageWorkoutDuration =>
      ProgressUtils.calculateAverageWorkoutDuration(completedWorkouts);

  EnhancedWorkoutProvider(this._repository);

  // Initialize provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _repository.initialize();
      await _loadWorkouts();
    } catch (e) {
      _setError('Failed to initialize workout provider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load workouts
  Future<void> _loadWorkouts() async {
    try {
      _workouts = await _repository.getAllWorkouts();
      _workouts.sort((a, b) => b.startTime.compareTo(a.startTime));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load workouts: $e');
    }
  }

  // CRUD Operations
  Future<String> createWorkout({
    required String name,
    String? notes,
    List<EnhancedExerciseModel> exercises = const [],
  }) async {
    try {
      final now = DateTime.now();
      final workout = EnhancedWorkoutModel(
        id: _generateId(),
        name: name,
        startTime: now,
        exercises: exercises,
        notes: notes,
        status: WorkoutStatus.planned,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveWorkout(workout);
      _workouts.insert(0, workout);
      notifyListeners();
      return workout.id;
    } catch (e) {
      _setError('Failed to create workout: $e');
      rethrow;
    }
  }

  Future<void> startWorkout(String workoutId) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final updatedWorkout = workout.copyWith(
        status: WorkoutStatus.inProgress,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      _currentWorkout = updatedWorkout;
      notifyListeners();
    } catch (e) {
      _setError('Failed to start workout: $e');
    }
  }

  Future<void> finishWorkout(
    String workoutId, {
    int? caloriesBurned,
    String? notes,
  }) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final now = DateTime.now();

      // Calculate total volume
      final totalVolume = workout.exercises.fold(
        0.0,
        (sum, exercise) => sum + exercise.totalVolume,
      );

      // Estimate calories if not provided
      final estimatedCalories = caloriesBurned ?? _estimateCalories(workout);

      final updatedWorkout = workout.copyWith(
        status: WorkoutStatus.completed,
        endTime: now,
        caloriesBurned: estimatedCalories,
        totalVolume: totalVolume,
        notes: notes ?? workout.notes,
        updatedAt: now,
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      _currentWorkout = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to finish workout: $e');
    }
  }

  Future<void> cancelWorkout(String workoutId) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final updatedWorkout = workout.copyWith(
        status: WorkoutStatus.cancelled,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      _currentWorkout = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to cancel workout: $e');
    }
  }

  Future<void> addExerciseToWorkout(
    String workoutId,
    EnhancedExerciseModel exercise,
  ) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final updatedExercises = List<EnhancedExerciseModel>.from(
        workout.exercises,
      )..add(exercise);

      final updatedWorkout = workout.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add exercise: $e');
    }
  }

  Future<void> updateExerciseInWorkout(
    String workoutId,
    String exerciseId,
    EnhancedExerciseModel exercise,
  ) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final updatedExercises = workout.exercises
          .map((e) => e.id == exerciseId ? exercise : e)
          .toList();

      final updatedWorkout = workout.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update exercise: $e');
    }
  }

  Future<void> addSetToExercise(
    String workoutId,
    String exerciseId,
    EnhancedSetModel set,
  ) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final updatedExercises = workout.exercises.map((exercise) {
        if (exercise.id == exerciseId) {
          final updatedSets = List<EnhancedSetModel>.from(exercise.sets)
            ..add(set);
          return exercise.copyWith(sets: updatedSets);
        }
        return exercise;
      }).toList();

      final updatedWorkout = workout.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add set: $e');
    }
  }

  Future<void> updateSetInExercise(
    String workoutId,
    String exerciseId,
    String setId,
    EnhancedSetModel set,
  ) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final updatedExercises = workout.exercises.map((exercise) {
        if (exercise.id == exerciseId) {
          final updatedSets = exercise.sets
              .map((s) => s.id == setId ? set : s)
              .toList();
          return exercise.copyWith(sets: updatedSets);
        }
        return exercise;
      }).toList();

      final updatedWorkout = workout.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      await _repository.updateWorkout(updatedWorkout);
      _updateWorkoutInList(updatedWorkout);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update set: $e');
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _repository.deleteWorkout(workoutId);
      _workouts.removeWhere((w) => w.id == workoutId);
      if (_currentWorkout?.id == workoutId) {
        _currentWorkout = null;
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete workout: $e');
    }
  }

  // Search and Filter
  Future<List<EnhancedWorkoutModel>> searchWorkouts(String query) async {
    try {
      return await _repository.searchWorkouts(query);
    } catch (e) {
      _setError('Failed to search workouts: $e');
      return [];
    }
  }

  Future<List<EnhancedWorkoutModel>> getWorkoutsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _repository.getWorkoutsByDateRange(start, end);
    } catch (e) {
      _setError('Failed to get workouts by date range: $e');
      return [];
    }
  }

  Future<List<EnhancedWorkoutModel>> getWorkoutsByExercise(
    String exerciseName,
  ) async {
    try {
      return await _repository.getWorkoutsByExercise(exerciseName);
    } catch (e) {
      _setError('Failed to get workouts by exercise: $e');
      return [];
    }
  }

  // Statistics
  Future<Map<String, dynamic>> getWorkoutStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _repository.getWorkoutStats(startDate, endDate);
    } catch (e) {
      _setError('Failed to get workout stats: $e');
      return {};
    }
  }

  // Personal Records
  List<Map<String, dynamic>> getPersonalRecords() {
    try {
      return ProgressUtils.detectPersonalRecords(completedWorkouts);
    } catch (e) {
      _setError('Failed to get personal records: $e');
      return [];
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadWorkouts();
  }

  // Helper methods
  void _updateWorkoutInList(EnhancedWorkoutModel updatedWorkout) {
    final index = _workouts.indexWhere((w) => w.id == updatedWorkout.id);
    if (index != -1) {
      _workouts[index] = updatedWorkout;
    }
  }

  int _estimateCalories(EnhancedWorkoutModel workout) {
    // Simple calorie estimation based on workout duration and exercises
    if (workout.duration == null) return 0;

    final durationHours = workout.duration!.inMinutes / 60.0;
    final exerciseCount = workout.exercises.length;

    // Base calories per hour + bonus for exercise count
    return (durationHours * 300 + exerciseCount * 50).round();
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

