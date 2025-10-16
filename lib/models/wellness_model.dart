class WaterLogModel {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String? notes;

  WaterLogModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.notes,
  });

  WaterLogModel copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? notes,
  }) {
    return WaterLogModel(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory WaterLogModel.fromJson(Map<String, dynamic> json) {
    return WaterLogModel(
      id: json['id'] as String,
      amountMl: json['amountMl'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }
}

class SleepLogModel {
  final String id;
  final DateTime bedtime;
  final DateTime wakeTime;
  final Duration duration;
  final SleepQuality quality;
  final String? notes;
  final int? sleepScore; // 0-100

  SleepLogModel({
    required this.id,
    required this.bedtime,
    required this.wakeTime,
    required this.duration,
    required this.quality,
    this.notes,
    this.sleepScore,
  });

  SleepLogModel copyWith({
    String? id,
    DateTime? bedtime,
    DateTime? wakeTime,
    Duration? duration,
    SleepQuality? quality,
    String? notes,
    int? sleepScore,
  }) {
    return SleepLogModel(
      id: id ?? this.id,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      duration: duration ?? this.duration,
      quality: quality ?? this.quality,
      notes: notes ?? this.notes,
      sleepScore: sleepScore ?? this.sleepScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bedtime': bedtime.toIso8601String(),
      'wakeTime': wakeTime.toIso8601String(),
      'duration': duration.inMinutes,
      'quality': quality.name,
      'notes': notes,
      'sleepScore': sleepScore,
    };
  }

  factory SleepLogModel.fromJson(Map<String, dynamic> json) {
    return SleepLogModel(
      id: json['id'] as String,
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wakeTime'] as String),
      duration: Duration(minutes: json['duration'] as int),
      quality: SleepQuality.values.firstWhere(
        (e) => e.name == json['quality'],
        orElse: () => SleepQuality.good,
      ),
      notes: json['notes'] as String?,
      sleepScore: json['sleepScore'] as int?,
    );
  }
}

class NutritionLogModel {
  final String id;
  final DateTime timestamp;
  final String mealType; // breakfast, lunch, dinner, snack
  final String foodName;
  final double calories;
  final double protein; // in grams
  final double carbs; // in grams
  final double fat; // in grams
  final double fiber; // in grams
  final double sugar; // in grams
  final double sodium; // in mg
  final int quantity; // in grams or ml
  final String? notes;

  NutritionLogModel({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0.0,
    this.sugar = 0.0,
    this.sodium = 0.0,
    required this.quantity,
    this.notes,
  });

  NutritionLogModel copyWith({
    String? id,
    DateTime? timestamp,
    String? mealType,
    String? foodName,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sugar,
    double? sodium,
    int? quantity,
    String? notes,
  }) {
    return NutritionLogModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      mealType: mealType ?? this.mealType,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory NutritionLogModel.fromJson(Map<String, dynamic> json) {
    return NutritionLogModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mealType: json['mealType'] as String,
      foodName: json['foodName'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int,
      notes: json['notes'] as String?,
    );
  }
}

enum SleepQuality { excellent, good, fair, poor }

enum MealType { breakfast, lunch, dinner, snack }

