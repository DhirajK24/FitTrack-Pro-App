import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/enums.dart';
import '../models/enhanced_workout_model.dart';
import '../models/enhanced_water_model.dart';
import '../models/enhanced_sleep_model.dart';

class HiveStorageService {
  static const String _workoutsBox = 'workouts';
  static const String _waterLogsBox = 'water_logs';
  static const String _waterGoalsBox = 'water_goals';
  static const String _sleepLogsBox = 'sleep_logs';
  static const String _sleepGoalsBox = 'sleep_goals';

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters
    final userAdapter = UserModelAdapter();
    if (!Hive.isAdapterRegistered(userAdapter.typeId)) {
      Hive.registerAdapter(userAdapter);
    }

    final sleepQualityAdapter = SleepQualityAdapter();
    if (!Hive.isAdapterRegistered(sleepQualityAdapter.typeId)) {
      Hive.registerAdapter(sleepQualityAdapter);
    }

    final workoutAdapter = EnhancedWorkoutModelAdapter();
    if (!Hive.isAdapterRegistered(workoutAdapter.typeId)) {
      Hive.registerAdapter(workoutAdapter);
    }

    final exerciseAdapter = EnhancedExerciseModelAdapter();
    if (!Hive.isAdapterRegistered(exerciseAdapter.typeId)) {
      Hive.registerAdapter(exerciseAdapter);
    }

    final setAdapter = EnhancedSetModelAdapter();
    if (!Hive.isAdapterRegistered(setAdapter.typeId)) {
      Hive.registerAdapter(setAdapter);
    }

    final workoutStatusAdapter = WorkoutStatusAdapter();
    if (!Hive.isAdapterRegistered(workoutStatusAdapter.typeId)) {
      Hive.registerAdapter(workoutStatusAdapter);
    }

    final waterLogAdapter = EnhancedWaterLogModelAdapter();
    if (!Hive.isAdapterRegistered(waterLogAdapter.typeId)) {
      Hive.registerAdapter(waterLogAdapter);
    }

    final waterLogTypeAdapter = WaterLogTypeAdapter();
    if (!Hive.isAdapterRegistered(waterLogTypeAdapter.typeId)) {
      Hive.registerAdapter(waterLogTypeAdapter);
    }

    final waterGoalAdapter = WaterGoalModelAdapter();
    if (!Hive.isAdapterRegistered(waterGoalAdapter.typeId)) {
      Hive.registerAdapter(waterGoalAdapter);
    }

    final sleepLogAdapter = EnhancedSleepLogModelAdapter();
    if (!Hive.isAdapterRegistered(sleepLogAdapter.typeId)) {
      Hive.registerAdapter(sleepLogAdapter);
    }

    final sleepGoalAdapter = SleepGoalModelAdapter();
    if (!Hive.isAdapterRegistered(sleepGoalAdapter.typeId)) {
      Hive.registerAdapter(sleepGoalAdapter);
    }

    _initialized = true;
  }

  static Future<Box<EnhancedWorkoutModel>> getWorkoutsBox() async {
    await initialize();
    return await Hive.openBox<EnhancedWorkoutModel>(_workoutsBox);
  }

  static Future<Box<EnhancedWaterLogModel>> getWaterLogsBox() async {
    await initialize();
    return await Hive.openBox<EnhancedWaterLogModel>(_waterLogsBox);
  }

  static Future<Box<WaterGoalModel>> getWaterGoalsBox() async {
    await initialize();
    return await Hive.openBox<WaterGoalModel>(_waterGoalsBox);
  }

  static Future<Box<EnhancedSleepLogModel>> getSleepLogsBox() async {
    await initialize();
    return await Hive.openBox<EnhancedSleepLogModel>(_sleepLogsBox);
  }

  static Future<Box<SleepGoalModel>> getSleepGoalsBox() async {
    await initialize();
    return await Hive.openBox<SleepGoalModel>(_sleepGoalsBox);
  }

  static Future<void> clearAllData() async {
    await initialize();

    final workoutsBox = await getWorkoutsBox();
    final waterLogsBox = await getWaterLogsBox();
    final waterGoalsBox = await getWaterGoalsBox();
    final sleepLogsBox = await getSleepLogsBox();
    final sleepGoalsBox = await getSleepGoalsBox();

    await workoutsBox.clear();
    await waterLogsBox.clear();
    await waterGoalsBox.clear();
    await sleepLogsBox.clear();
    await sleepGoalsBox.clear();
  }

  static Future<void> closeAllBoxes() async {
    await Hive.close();
    _initialized = false;
  }
}
