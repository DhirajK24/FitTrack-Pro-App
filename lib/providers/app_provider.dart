import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enums.dart';
import '../repositories/user_repository.dart';
import '../repositories/workout_repository.dart';
import '../repositories/wellness_repository.dart';
import '../repositories/analytics_repository.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  // Repositories
  late final UserRepository _userRepository;
  late final WorkoutRepository _workoutRepository;
  late final WaterRepository _waterRepository;
  late final SleepRepository _sleepRepository;
  late final NutritionRepository _nutritionRepository;
  late final AnalyticsRepository _analyticsRepository;

  // State
  UserModel? _currentUser;
  bool _isInitialized = false;
  bool _isLoading = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isOnboardingComplete =>
      _currentUser != null && _isOnboardingComplete();

  // Repositories getters
  UserRepository get userRepository => _userRepository;
  WorkoutRepository get workoutRepository => _workoutRepository;
  WaterRepository get waterRepository => _waterRepository;
  SleepRepository get sleepRepository => _sleepRepository;
  NutritionRepository get nutritionRepository => _nutritionRepository;
  AnalyticsRepository get analyticsRepository => _analyticsRepository;

  // Initialize the provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Set loading without notifying listeners during initialization
    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Initialize repositories
      _userRepository = UserRepository(prefs);
      _workoutRepository = WorkoutRepository(prefs);
      _waterRepository = WaterRepository(prefs);
      _sleepRepository = SleepRepository(prefs);
      _nutritionRepository = NutritionRepository(prefs);
      _analyticsRepository = AnalyticsRepository(prefs);

      // Load current user
      _currentUser = await _userRepository.getCurrentUser();

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing AppProvider: $e');
    } finally {
      _isLoading = false;
      // Only notify listeners after initialization is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // User management
  Future<void> login(UserModel user) async {
    _setLoading(true);

    try {
      await _userRepository.saveCurrentUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging in: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
    DateTime? dateOfBirth,
    Gender? gender,
    double? weight,
    double? height,
    FitnessLevel? fitnessLevel,
    List<String>? goals,
  }) async {
    if (_currentUser == null) return;

    _setLoading(true);

    try {
      await _userRepository.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        dateOfBirth: dateOfBirth,
        gender: gender,
        weight: weight,
        height: height,
        fitnessLevel: fitnessLevel,
        goals: goals,
      );

      _currentUser = await _userRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeOnboarding(UserModel user) async {
    _setLoading(true);

    try {
      await _userRepository.completeOnboarding(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _userRepository.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool _isOnboardingComplete() {
    if (_currentUser == null) return false;

    return _currentUser!.displayName != null &&
        _currentUser!.dateOfBirth != null &&
        _currentUser!.gender != null &&
        _currentUser!.weight != null &&
        _currentUser!.height != null &&
        _currentUser!.fitnessLevel != null;
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (_currentUser == null) return;

    try {
      _currentUser = await _userRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }
}
