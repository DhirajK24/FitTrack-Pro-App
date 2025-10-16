import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';
import 'base_repository.dart';

class WorkoutRepository extends BaseRepository<WorkoutModel> {
  static const String _key = 'workouts';

  WorkoutRepository(SharedPreferences prefs) : super(_key, prefs);

  @override
  Map<String, dynamic> toJson(WorkoutModel item) => item.toJson();

  @override
  WorkoutModel fromJson(Map<String, dynamic> json) =>
      WorkoutModel.fromJson(json);

  @override
  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // Workout-specific methods
  Future<List<WorkoutModel>> getWorkoutsByStatus(WorkoutStatus status) async {
    final workouts = await getAll();
    return workouts.where((workout) => workout.status == status).toList();
  }

  Future<List<WorkoutModel>> getRecentWorkouts({int limit = 10}) async {
    final workouts = await getAll();
    workouts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return workouts.take(limit).toList();
  }

  Future<List<WorkoutModel>> getWorkoutsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final workouts = await getAll();
    return workouts.where((workout) {
      return workout.createdAt.isAfter(start) &&
          workout.createdAt.isBefore(end);
    }).toList();
  }

  Future<WorkoutModel?> getActiveWorkout() async {
    final activeWorkouts = await getWorkoutsByStatus(WorkoutStatus.inProgress);
    return activeWorkouts.isNotEmpty ? activeWorkouts.first : null;
  }

  Future<void> startWorkout(WorkoutModel workout) async {
    final updatedWorkout = workout.copyWith(status: WorkoutStatus.inProgress);
    await save(updatedWorkout);
  }

  Future<void> completeWorkout(String workoutId) async {
    final workout = await getById(workoutId);
    if (workout == null) return;

    final updatedWorkout = workout.copyWith(
      status: WorkoutStatus.completed,
      completedAt: DateTime.now(),
    );
    await save(updatedWorkout);
  }

  Future<void> cancelWorkout(String workoutId) async {
    final workout = await getById(workoutId);
    if (workout == null) return;

    final updatedWorkout = workout.copyWith(status: WorkoutStatus.cancelled);
    await save(updatedWorkout);
  }

  Future<void> addExerciseToWorkout(
    String workoutId,
    ExerciseModel exercise,
  ) async {
    final workout = await getById(workoutId);
    if (workout == null) return;

    final updatedExercises = List<ExerciseModel>.from(workout.exercises)
      ..add(exercise);
    final updatedWorkout = workout.copyWith(exercises: updatedExercises);
    await save(updatedWorkout);
  }

  Future<void> updateExerciseInWorkout(
    String workoutId,
    String exerciseId,
    ExerciseModel updatedExercise,
  ) async {
    final workout = await getById(workoutId);
    if (workout == null) return;

    final updatedExercises = workout.exercises.map((exercise) {
      return exercise.id == exerciseId ? updatedExercise : exercise;
    }).toList();

    final updatedWorkout = workout.copyWith(exercises: updatedExercises);
    await save(updatedWorkout);
  }

  Future<void> removeExerciseFromWorkout(
    String workoutId,
    String exerciseId,
  ) async {
    final workout = await getById(workoutId);
    if (workout == null) return;

    final updatedExercises = workout.exercises
        .where((exercise) => exercise.id != exerciseId)
        .toList();
    final updatedWorkout = workout.copyWith(exercises: updatedExercises);
    await save(updatedWorkout);
  }

  // Exercise library methods
  Future<List<ExerciseModel>> getExerciseLibrary() async {
    final workouts = await getAll();
    final allExercises = <ExerciseModel>[];

    for (final workout in workouts) {
      allExercises.addAll(workout.exercises);
    }

    // Remove duplicates based on exercise name
    final uniqueExercises = <String, ExerciseModel>{};
    for (final exercise in allExercises) {
      uniqueExercises[exercise.name] = exercise;
    }

    return uniqueExercises.values.toList();
  }

  Future<List<ExerciseModel>> searchExercises(String query) async {
    final library = await getExerciseLibrary();
    return library.where((exercise) {
      return exercise.name.toLowerCase().contains(query.toLowerCase()) ||
          (exercise.muscleGroup?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          (exercise.category?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }

  Future<List<ExerciseModel>> getExercisesByCategory(String category) async {
    final library = await getExerciseLibrary();
    return library.where((exercise) => exercise.category == category).toList();
  }

  Future<List<ExerciseModel>> getExercisesByMuscleGroup(
    String muscleGroup,
  ) async {
    final library = await getExerciseLibrary();
    return library
        .where((exercise) => exercise.muscleGroup == muscleGroup)
        .toList();
  }
}
