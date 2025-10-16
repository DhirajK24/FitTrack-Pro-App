import 'package:hive/hive.dart';
import 'enums.dart';

part 'enhanced_water_model.g.dart';

@HiveType(typeId: 4)
class EnhancedWaterLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int amountMl;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String? notes;

  @HiveField(4)
  final WaterLogType type;

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

  @HiveField(10)
  final WaterSource? source;

  EnhancedWaterLogModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.notes,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.remoteId,
    this.userId,
    this.source,
  });

  double get amountLiters => amountMl / 1000.0;

  String get formattedAmount {
    if (amountMl >= 1000) {
      return '${(amountMl / 1000).toStringAsFixed(1)}L';
    }
    return '${amountMl}ml';
  }

  EnhancedWaterLogModel copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? notes,
    WaterLogType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    String? remoteId,
    String? userId,
    WaterSource? source,
  }) {
    return EnhancedWaterLogModel(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'synced': synced,
      'remoteId': remoteId,
      'userId': userId,
      'source': source?.name,
    };
  }

  factory EnhancedWaterLogModel.fromJson(Map<String, dynamic> json) {
    return EnhancedWaterLogModel(
      id: json['id'] as String,
      amountMl: json['amountMl'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
      type: WaterLogType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WaterLogType.manual,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      synced: json['synced'] as bool? ?? false,
      remoteId: json['remoteId'] as String?,
      userId: json['userId'] as String?,
      source: json['source'] != null
          ? WaterSource.values.firstWhere((e) => e.name == json['source'])
          : null,
    );
  }
}

@HiveType(typeId: 5)
enum WaterLogType {
  @HiveField(0)
  manual,

  @HiveField(1)
  quickAdd,

  @HiveField(2)
  reminder,

  @HiveField(3)
  goal,
}

@HiveType(typeId: 6)
class WaterGoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int goalMl;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  @HiveField(4)
  final bool isActive;

  // Sync fields
  @HiveField(5)
  final bool synced;

  @HiveField(6)
  final String? remoteId;

  @HiveField(7)
  final String? userId;

  // Additional properties
  @HiveField(8)
  final DateTime? startDate;

  @HiveField(9)
  final DateTime? endDate;

  @HiveField(10)
  final int dailyGoalMl;

  WaterGoalModel({
    required this.id,
    required this.goalMl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.synced = false,
    this.remoteId,
    this.userId,
    this.startDate,
    this.endDate,
    this.dailyGoalMl = 2000, // Default 2L
  });

  double get goalLiters => goalMl / 1000.0;

  String get formattedGoal {
    if (goalMl >= 1000) {
      return '${(goalMl / 1000).toStringAsFixed(1)}L';
    }
    return '${goalMl}ml';
  }

  WaterGoalModel copyWith({
    String? id,
    int? goalMl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? synced,
    String? remoteId,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? dailyGoalMl,
  }) {
    return WaterGoalModel(
      id: id ?? this.id,
      goalMl: goalMl ?? this.goalMl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalMl': goalMl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'synced': synced,
      'remoteId': remoteId,
      'userId': userId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'dailyGoalMl': dailyGoalMl,
    };
  }

  factory WaterGoalModel.fromJson(Map<String, dynamic> json) {
    return WaterGoalModel(
      id: json['id'] as String,
      goalMl: json['goalMl'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      synced: json['synced'] as bool? ?? false,
      remoteId: json['remoteId'] as String?,
      userId: json['userId'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2000,
    );
  }
}
