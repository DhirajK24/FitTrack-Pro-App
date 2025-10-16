// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_workout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnhancedWorkoutModelAdapter extends TypeAdapter<EnhancedWorkoutModel> {
  @override
  final int typeId = 0;

  @override
  EnhancedWorkoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnhancedWorkoutModel(
      id: fields[0] as String,
      name: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      exercises: (fields[4] as List).cast<EnhancedExerciseModel>(),
      notes: fields[5] as String?,
      status: fields[6] as WorkoutStatus,
      caloriesBurned: fields[7] as int?,
      totalVolume: fields[8] as double?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      synced: fields[11] as bool,
      remoteId: fields[12] as String?,
      userId: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EnhancedWorkoutModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.exercises)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.caloriesBurned)
      ..writeByte(8)
      ..write(obj.totalVolume)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.synced)
      ..writeByte(12)
      ..write(obj.remoteId)
      ..writeByte(13)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnhancedWorkoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnhancedExerciseModelAdapter extends TypeAdapter<EnhancedExerciseModel> {
  @override
  final int typeId = 1;

  @override
  EnhancedExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnhancedExerciseModel(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      sets: (fields[3] as List).cast<EnhancedSetModel>(),
      notes: fields[4] as String?,
      restSeconds: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EnhancedExerciseModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.sets)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.restSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnhancedExerciseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnhancedSetModelAdapter extends TypeAdapter<EnhancedSetModel> {
  @override
  final int typeId = 2;

  @override
  EnhancedSetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnhancedSetModel(
      id: fields[0] as String,
      reps: fields[1] as int,
      weight: fields[2] as double,
      restSeconds: fields[3] as int?,
      notes: fields[4] as String?,
      completed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EnhancedSetModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.restSeconds)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnhancedSetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutStatusAdapter extends TypeAdapter<WorkoutStatus> {
  @override
  final int typeId = 3;

  @override
  WorkoutStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WorkoutStatus.planned;
      case 1:
        return WorkoutStatus.inProgress;
      case 2:
        return WorkoutStatus.completed;
      case 3:
        return WorkoutStatus.cancelled;
      default:
        return WorkoutStatus.planned;
    }
  }

  @override
  void write(BinaryWriter writer, WorkoutStatus obj) {
    switch (obj) {
      case WorkoutStatus.planned:
        writer.writeByte(0);
        break;
      case WorkoutStatus.inProgress:
        writer.writeByte(1);
        break;
      case WorkoutStatus.completed:
        writer.writeByte(2);
        break;
      case WorkoutStatus.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

