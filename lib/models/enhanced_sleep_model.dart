import 'package:hive/hive.dart';

part 'enhanced_sleep_model.g.dart';

@HiveType(typeId: 7)
class EnhancedSleepLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime bedtime;

  @HiveField(2)
  final DateTime wakeTime;

  @HiveField(3)
  final SleepQuality quality;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  // Sync fields for future cloud integration
  @HiveField(7)
  final bool synced;

  @HiveField(8)
  final String? remoteId;

  @HiveField(9)
  final String? userId;

  EnhancedSleepLogModel({
    required this.id,
    required this.bedtime,
    required this.wakeTime,
    required this.quality,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.remoteId,
    this.userId,
  });

  Duration get duration => wakeTime.difference(bedtime);

  double get durationHours => duration.inMinutes / 60.0;

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get bedtimeFormatted {
    return '${bedtime.hour.toString().padLeft(2, '0')}:${bedtime.minute.toString().padLeft(2, '0')}';
  }

  String get wakeTimeFormatted {
    return '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}';
  }

  bool get isSameDay {
    return bedtime.day == wakeTime.day &&
        bedtime.month == wakeTime.month &&
        bedtime.year == wakeTime.year;
  }

  EnhancedSleepLogModel copyWith({
    String? id,
    DateTime? bedtime,
    DateTime? wakeTime,
    SleepQuality? quality,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    String? remoteId,
    String? userId,
  }) {
    return EnhancedSleepLogModel(
      id: id ?? this.id,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      quality: quality ?? this.quality,
      notes: notes ?? this.notes,
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
      'bedtime': bedtime.toIso8601String(),
      'wakeTime': wakeTime.toIso8601String(),
      'quality': quality.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'synced': synced,
      'remoteId': remoteId,
      'userId': userId,
    };
  }

  factory EnhancedSleepLogModel.fromJson(Map<String, dynamic> json) {
    return EnhancedSleepLogModel(
      id: json['id'] as String,
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wakeTime'] as String),
      quality: SleepQuality.values.firstWhere(
        (e) => e.name == json['quality'],
        orElse: () => SleepQuality.average,
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      synced: json['synced'] as bool? ?? false,
      remoteId: json['remoteId'] as String?,
      userId: json['userId'] as String?,
    );
  }
}

@HiveType(typeId: 8)
enum SleepQuality {
  @HiveField(0)
  poor,

  @HiveField(1)
  fair,

  @HiveField(4)
  average,

  @HiveField(2)
  good,

  @HiveField(3)
  excellent,
}

@HiveType(typeId: 9)
class SleepGoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double targetHours;

  @HiveField(2)
  final DateTime bedtime;

  @HiveField(3)
  final DateTime wakeTime;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final bool isActive;

  // Sync fields
  @HiveField(7)
  final bool synced;

  @HiveField(8)
  final String? remoteId;

  @HiveField(9)
  final String? userId;

  SleepGoalModel({
    required this.id,
    required this.targetHours,
    required this.bedtime,
    required this.wakeTime,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.synced = false,
    this.remoteId,
    this.userId,
  });

  String get formattedTarget {
    final hours = targetHours.floor();
    final minutes = ((targetHours - hours) * 60).round();
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get bedtimeFormatted {
    return '${bedtime.hour.toString().padLeft(2, '0')}:${bedtime.minute.toString().padLeft(2, '0')}';
  }

  String get wakeTimeFormatted {
    return '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}';
  }

  SleepGoalModel copyWith({
    String? id,
    double? targetHours,
    DateTime? bedtime,
    DateTime? wakeTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? synced,
    String? remoteId,
    String? userId,
  }) {
    return SleepGoalModel(
      id: id ?? this.id,
      targetHours: targetHours ?? this.targetHours,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetHours': targetHours,
      'bedtime': bedtime.toIso8601String(),
      'wakeTime': wakeTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'synced': synced,
      'remoteId': remoteId,
      'userId': userId,
    };
  }

  factory SleepGoalModel.fromJson(Map<String, dynamic> json) {
    return SleepGoalModel(
      id: json['id'] as String,
      targetHours: (json['targetHours'] as num).toDouble(),
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wakeTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      synced: json['synced'] as bool? ?? false,
      remoteId: json['remoteId'] as String?,
      userId: json['userId'] as String?,
    );
  }
}
