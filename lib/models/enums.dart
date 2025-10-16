// Enums for FitTrack Pro app

enum Gender { male, female, other }

enum FitnessLevel { beginner, intermediate, advanced }

enum WaterSource { tap, bottled, filtered, sparkling, other }

enum SleepQuality { poor, fair, average, good, excellent }

// Extension methods for enum display names
extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

extension FitnessLevelExtension on FitnessLevel {
  String get displayName {
    switch (this) {
      case FitnessLevel.beginner:
        return 'Beginner';
      case FitnessLevel.intermediate:
        return 'Intermediate';
      case FitnessLevel.advanced:
        return 'Advanced';
    }
  }
}

extension WaterSourceExtension on WaterSource {
  String get displayName {
    switch (this) {
      case WaterSource.tap:
        return 'Tap Water';
      case WaterSource.bottled:
        return 'Bottled Water';
      case WaterSource.filtered:
        return 'Filtered Water';
      case WaterSource.sparkling:
        return 'Sparkling Water';
      case WaterSource.other:
        return 'Other';
    }
  }
}

extension SleepQualityExtension on SleepQuality {
  String get displayName {
    switch (this) {
      case SleepQuality.poor:
        return 'Poor';
      case SleepQuality.fair:
        return 'Fair';
      case SleepQuality.average:
        return 'Average';
      case SleepQuality.good:
        return 'Good';
      case SleepQuality.excellent:
        return 'Excellent';
    }
  }
}
