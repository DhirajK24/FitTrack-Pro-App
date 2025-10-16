// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenderAdapter extends TypeAdapter<Gender> {
  @override
  final int typeId = 1;

  @override
  Gender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Gender.male;
      case 1:
        return Gender.female;
      case 2:
        return Gender.other;
      default:
        return Gender.male;
    }
  }

  @override
  void write(BinaryWriter writer, Gender obj) {
    switch (obj) {
      case Gender.male:
        writer.writeByte(0);
        break;
      case Gender.female:
        writer.writeByte(1);
        break;
      case Gender.other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FitnessLevelAdapter extends TypeAdapter<FitnessLevel> {
  @override
  final int typeId = 2;

  @override
  FitnessLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FitnessLevel.beginner;
      case 1:
        return FitnessLevel.intermediate;
      case 2:
        return FitnessLevel.advanced;
      default:
        return FitnessLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, FitnessLevel obj) {
    switch (obj) {
      case FitnessLevel.beginner:
        writer.writeByte(0);
        break;
      case FitnessLevel.intermediate:
        writer.writeByte(1);
        break;
      case FitnessLevel.advanced:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WaterSourceAdapter extends TypeAdapter<WaterSource> {
  @override
  final int typeId = 3;

  @override
  WaterSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WaterSource.tap;
      case 1:
        return WaterSource.bottled;
      case 2:
        return WaterSource.filtered;
      case 3:
        return WaterSource.sparkling;
      case 4:
        return WaterSource.other;
      default:
        return WaterSource.tap;
    }
  }

  @override
  void write(BinaryWriter writer, WaterSource obj) {
    switch (obj) {
      case WaterSource.tap:
        writer.writeByte(0);
        break;
      case WaterSource.bottled:
        writer.writeByte(1);
        break;
      case WaterSource.filtered:
        writer.writeByte(2);
        break;
      case WaterSource.sparkling:
        writer.writeByte(3);
        break;
      case WaterSource.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepQualityAdapter extends TypeAdapter<SleepQuality> {
  @override
  final int typeId = 4;

  @override
  SleepQuality read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SleepQuality.poor;
      case 1:
        return SleepQuality.fair;
      case 2:
        return SleepQuality.average;
      case 3:
        return SleepQuality.good;
      case 4:
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
      case SleepQuality.average:
        writer.writeByte(2);
        break;
      case SleepQuality.good:
        writer.writeByte(3);
        break;
      case SleepQuality.excellent:
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
