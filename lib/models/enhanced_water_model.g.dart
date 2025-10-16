// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_water_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnhancedWaterLogModelAdapter extends TypeAdapter<EnhancedWaterLogModel> {
  @override
  final int typeId = 4;

  @override
  EnhancedWaterLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnhancedWaterLogModel(
      id: fields[0] as String,
      amountMl: fields[1] as int,
      timestamp: fields[2] as DateTime,
      notes: fields[3] as String?,
      type: fields[4] as WaterLogType,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      synced: fields[7] as bool,
      remoteId: fields[8] as String?,
      userId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EnhancedWaterLogModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amountMl)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.type)
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
      other is EnhancedWaterLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WaterLogTypeAdapter extends TypeAdapter<WaterLogType> {
  @override
  final int typeId = 5;

  @override
  WaterLogType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WaterLogType.manual;
      case 1:
        return WaterLogType.quickAdd;
      case 2:
        return WaterLogType.reminder;
      case 3:
        return WaterLogType.goal;
      default:
        return WaterLogType.manual;
    }
  }

  @override
  void write(BinaryWriter writer, WaterLogType obj) {
    switch (obj) {
      case WaterLogType.manual:
        writer.writeByte(0);
        break;
      case WaterLogType.quickAdd:
        writer.writeByte(1);
        break;
      case WaterLogType.reminder:
        writer.writeByte(2);
        break;
      case WaterLogType.goal:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLogTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WaterGoalModelAdapter extends TypeAdapter<WaterGoalModel> {
  @override
  final int typeId = 6;

  @override
  WaterGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterGoalModel(
      id: fields[0] as String,
      goalMl: fields[1] as int,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      isActive: fields[4] as bool,
      synced: fields[5] as bool,
      remoteId: fields[6] as String?,
      userId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WaterGoalModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalMl)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.synced)
      ..writeByte(6)
      ..write(obj.remoteId)
      ..writeByte(7)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterGoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

