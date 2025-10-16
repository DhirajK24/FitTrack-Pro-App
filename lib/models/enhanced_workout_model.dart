import 'package:hive/hive.dart';

part 'enhanced_workout_model.g.dart';

@HiveType(typeId: 0)
class EnhancedWorkoutModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime? endTime;

  @HiveField(4)
  final List<EnhancedExerciseModel> exercises;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final WorkoutStatus status;

  @HiveField(7)
  final int? caloriesBurned;

  @HiveField(8)
  final double? totalVolume; // Total weight lifted

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  // Sync fields for future cloud integration
  @HiveField(11)
  final bool synced;

  @HiveField(12)
  final String? remoteId;

  @HiveField(13)
  final String? userId;

  EnhancedWorkoutModel({
    required this.id,
    required this.name,
    required this.startTime,
    this.endTime,
    required this.exercises,
    this.notes,
    required this.status,
    this.caloriesBurned,
    this.totalVolume,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.remoteId,
    this.userId,
  });

  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  int get totalSets {
    return exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);
  }

  int get totalReps {
    return exercises.fold(0, (sum, exercise) {
      return sum + exercise.sets.fold(0, (setSum, set) => setSum + set.reps);
    });
  }

  double get averageWeight {
    if (exercises.isEmpty) return 0.0;
    final totalWeight = exercises.fold(0.0, (sum, exercise) {
      return sum +
          exercise.sets.fold(0.0, (setSum, set) => setSum + set.weight);
    });
    final totalSets = exercises.fold(
      0,
      (sum, exercise) => sum + exercise.sets.length,
    );
    return totalSets > 0 ? totalWeight / totalSets : 0.0;
  }

  EnhancedWorkoutModel copyWith({
    String? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    List<EnhancedExerciseModel>? exercises,
    String? notes,
    WorkoutStatus? status,
    int? caloriesBurned,
    double? totalVolume,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    String? remoteId,
    String? userId,
  }) {
    return EnhancedWorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      totalVolume: totalVolume ?? this.totalVolume,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'notes': notes,
      'status': status.name,
      'caloriesBurned': caloriesBurned,
      'totalVolume': totalVolume,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'synced': synced,
      'remoteId': remoteId,
      'userId': userId,
    };
  }

  factory EnhancedWorkoutModel.fromJson(Map<String, dynamic> json) {
    return EnhancedWorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => EnhancedExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      status: WorkoutStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => WorkoutStatus.planned,
      ),
      caloriesBurned: json['caloriesBurned'] as int?,
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      synced: json['synced'] as bool? ?? false,
      remoteId: json['remoteId'] as String?,
      userId: json['userId'] as String?,
    );
  }
}

@HiveType(typeId: 1)
class EnhancedExerciseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final List<EnhancedSetModel> sets;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final int? restSeconds;

  EnhancedExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.sets,
    this.notes,
    this.restSeconds,
  });

  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + (set.weight * set.reps));
  }

  int get totalReps {
    return sets.fold(0, (sum, set) => sum + set.reps);
  }

  double get averageWeight {
    if (sets.isEmpty) return 0.0;
    final totalWeight = sets.fold(0.0, (sum, set) => sum + set.weight);
    return totalWeight / sets.length;
  }

  EnhancedExerciseModel copyWith({
    String? id,
    String? name,
    String? category,
    List<EnhancedSetModel>? sets,
    String? notes,
    int? restSeconds,
  }) {
    return EnhancedExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'sets': sets.map((s) => s.toJson()).toList(),
      'notes': notes,
      'restSeconds': restSeconds,
    };
  }

  factory EnhancedExerciseModel.fromJson(Map<String, dynamic> json) {
    return EnhancedExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((s) => EnhancedSetModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      restSeconds: json['restSeconds'] as int?,
    );
  }
}

@HiveType(typeId: 2)
class EnhancedSetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int reps;

  @HiveField(2)
  final double weight;

  @HiveField(3)
  final int? restSeconds;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final bool completed;

  EnhancedSetModel({
    required this.id,
    required this.reps,
    required this.weight,
    this.restSeconds,
    this.notes,
    this.completed = true,
  });

  double get volume => weight * reps;

  EnhancedSetModel copyWith({
    String? id,
    int? reps,
    double? weight,
    int? restSeconds,
    String? notes,
    bool? completed,
  }) {
    return EnhancedSetModel(
      id: id ?? this.id,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'restSeconds': restSeconds,
      'notes': notes,
      'completed': completed,
    };
  }

  factory EnhancedSetModel.fromJson(Map<String, dynamic> json) {
    return EnhancedSetModel(
      id: json['id'] as String,
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
      restSeconds: json['restSeconds'] as int?,
      notes: json['notes'] as String?,
      completed: json['completed'] as bool? ?? true,
    );
  }
}

@HiveType(typeId: 3)
enum WorkoutStatus {
  @HiveField(0)
  planned,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  cancelled,
}
