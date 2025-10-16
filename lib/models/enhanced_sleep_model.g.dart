// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_sleep_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnhancedSleepLogModelAdapter extends TypeAdapter<EnhancedSleepLogModel> {
  @override
  final int typeId = 7;

  @override
  EnhancedSleepLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnhancedSleepLogModel(
      id: fields[0] as String,
      bedtime: fields[1] as DateTime,
      wakeTime: fields[2] as DateTime,
      quality: fields[3] as SleepQuality,
      notes: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      synced: fields[7] as bool,
      remoteId: fields[8] as String?,
      userId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EnhancedSleepLogModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bedtime)
      ..writeByte(2)
      ..write(obj.wakeTime)
      ..writeByte(3)
      ..write(obj.quality)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.synced)
      ..writeByte(8)
      ..write(obj.remoteId)
      ..writeByte(9)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnhancedSleepLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepQualityAdapter extends TypeAdapter<SleepQuality> {
  @override
  final int typeId = 8;

  @override
  SleepQuality read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SleepQuality.poor;
      case 1:
        return SleepQuality.fair;
      case 2:
        return SleepQuality.good;
      case 3:
        return SleepQuality.excellent;
      default:
        return SleepQuality.average;
    }
  }

  @override
  void write(BinaryWriter writer, SleepQuality obj) {
    switch (obj) {
      case SleepQuality.poor:
        writer.writeByte(0);
        break;
      case SleepQuality.fair:
        writer.writeByte(1);
        break;
      case SleepQuality.good:
        writer.writeByte(2);
        break;
      case SleepQuality.excellent:
        writer.writeByte(3);
        break;
      case SleepQuality.average:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepQualityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepGoalModelAdapter extends TypeAdapter<SleepGoalModel> {
  @override
  final int typeId = 9;

  @override
  SleepGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepGoalModel(
      id: fields[0] as String,
      targetHours: fields[1] as double,
      bedtime: fields[2] as DateTime,
      wakeTime: fields[3] as DateTime,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      isActive: fields[6] as bool,
      synced: fields[7] as bool,
      remoteId: fields[8] as String?,
      userId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SleepGoalModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.targetHours)
      ..writeByte(2)
      ..write(obj.bedtime)
      ..writeByte(3)
      ..write(obj.wakeTime)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.synced)
      ..writeByte(8)
      ..write(obj.remoteId)
      ..writeByte(9)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepGoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
