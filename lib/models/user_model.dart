import 'package:hive/hive.dart';
import 'enums.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? password; // Hashed password

  @HiveField(3)
  final String? displayName;

  @HiveField(4)
  final String? photoUrl;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final bool isEmailVerified;

  @HiveField(8)
  final String? phoneNumber;

  @HiveField(9)
  final DateTime? lastLoginAt;

  @HiveField(10)
  final bool isActive;

  @HiveField(11)
  final Map<String, dynamic>? preferences;

  // Additional user profile fields
  @HiveField(12)
  final DateTime? dateOfBirth;

  @HiveField(13)
  final Gender? gender;

  @HiveField(14)
  final double? weight; // in kg

  @HiveField(15)
  final double? height; // in cm

  @HiveField(16)
  final FitnessLevel? fitnessLevel;

  @HiveField(17)
  final List<String>? goals;

  const UserModel({
    required this.id,
    required this.email,
    this.password,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isEmailVerified = false,
    this.phoneNumber,
    this.lastLoginAt,
    this.isActive = true,
    this.preferences,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.height,
    this.fitnessLevel,
    this.goals,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    String? phoneNumber,
    DateTime? lastLoginAt,
    bool? isActive,
    Map<String, dynamic>? preferences,
    DateTime? dateOfBirth,
    Gender? gender,
    double? weight,
    double? height,
    FitnessLevel? fitnessLevel,
    List<String>? goals,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goals: goals ?? this.goals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
      'preferences': preferences,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender?.name,
      'weight': weight,
      'height': height,
      'fitnessLevel': fitnessLevel?.name,
      'goals': goals,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      preferences: json['preferences'] as Map<String, dynamic>?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] != null
          ? Gender.values.firstWhere((e) => e.name == json['gender'])
          : null,
      weight: json['weight'] as double?,
      height: json['height'] as double?,
      fitnessLevel: json['fitnessLevel'] != null
          ? FitnessLevel.values.firstWhere(
              (e) => e.name == json['fitnessLevel'],
            )
          : null,
      goals: json['goals'] != null
          ? List<String>.from(json['goals'] as List)
          : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
