class WorkoutModel {
  final String id;
  final String name;
  final String? description;
  final List<ExerciseModel> exercises;
  final Duration? totalDuration;
  final DateTime createdAt;
  final DateTime? completedAt;
  final WorkoutStatus status;

  WorkoutModel({
    required this.id,
    required this.name,
    this.description,
    this.exercises = const [],
    this.totalDuration,
    required this.createdAt,
    this.completedAt,
    this.status = WorkoutStatus.draft,
  });

  WorkoutModel copyWith({
    String? id,
    String? name,
    String? description,
    List<ExerciseModel>? exercises,
    Duration? totalDuration,
    DateTime? createdAt,
    DateTime? completedAt,
    WorkoutStatus? status,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      totalDuration: totalDuration ?? this.totalDuration,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'totalDuration': totalDuration?.inMinutes,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.name,
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalDuration: json['totalDuration'] != null
          ? Duration(minutes: json['totalDuration'] as int)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      status: WorkoutStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => WorkoutStatus.draft,
      ),
    );
  }
}

class ExerciseModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? muscleGroup;
  final String? equipment;
  final String? imageUrl;
  final List<SetModel> sets;
  final Duration? restTime;
  final String? notes;

  ExerciseModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.muscleGroup,
    this.equipment,
    this.imageUrl,
    this.sets = const [],
    this.restTime,
    this.notes,
  });

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? muscleGroup,
    String? equipment,
    String? imageUrl,
    List<SetModel>? sets,
    Duration? restTime,
    String? notes,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      imageUrl: imageUrl ?? this.imageUrl,
      sets: sets ?? this.sets,
      restTime: restTime ?? this.restTime,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'imageUrl': imageUrl,
      'sets': sets.map((s) => s.toJson()).toList(),
      'restTime': restTime?.inSeconds,
      'notes': notes,
    };
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      muscleGroup: json['muscleGroup'] as String?,
      equipment: json['equipment'] as String?,
      imageUrl: json['imageUrl'] as String?,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((s) => SetModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      restTime: json['restTime'] != null
          ? Duration(seconds: json['restTime'] as int)
          : null,
      notes: json['notes'] as String?,
    );
  }
}

class SetModel {
  final String id;
  final int reps;
  final double? weight; // in kg
  final Duration? duration; // for time-based exercises
  final int? distance; // in meters
  final bool completed;
  final String? notes;

  SetModel({
    required this.id,
    required this.reps,
    this.weight,
    this.duration,
    this.distance,
    this.completed = false,
    this.notes,
  });

  SetModel copyWith({
    String? id,
    int? reps,
    double? weight,
    Duration? duration,
    int? distance,
    bool? completed,
    String? notes,
  }) {
    return SetModel(
      id: id ?? this.id,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'duration': duration?.inSeconds,
      'distance': distance,
      'completed': completed,
      'notes': notes,
    };
  }

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id'] as String,
      reps: json['reps'] as int,
      weight: (json['weight'] as num?)?.toDouble(),
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      distance: json['distance'] as int?,
      completed: json['completed'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}

enum WorkoutStatus { draft, inProgress, completed, cancelled }

