import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSignedIn => _currentUser != null && _currentUser!.isActive;
  bool get isInitialized => _isInitialized;

  // Initialize the auth provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    _setLoading(true);
    _clearError();

    try {
      await _authRepository.initialize();
      _currentUser = await _authRepository.getCurrentUser();
      _isInitialized = true;
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> registerUser({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.registerUser(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );

      if (result.success) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in user
  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.signInUser(
        email: email,
        password: password,
      );

      if (result.success) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Sign in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out user
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    Map<String, dynamic>? preferences,
  }) async {
    if (_currentUser == null) {
      _setError('No user signed in');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.updateUserProfile(
        userId: _currentUser!.id,
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
        preferences: preferences,
      );

      if (result.success) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      _setError('No user signed in');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.changePassword(
        userId: _currentUser!.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (result.success) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Password change failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete user account
  Future<bool> deleteUser() async {
    if (_currentUser == null) {
      _setError('No user signed in');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.deleteUser(_currentUser!.id);

      if (result.success) {
        _currentUser = null;
        notifyListeners();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Account deletion failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check if user exists
  Future<bool> userExists(String email) async {
    try {
      return await _authRepository.userExists(email);
    } catch (e) {
      _setError('Failed to check user existence: ${e.toString()}');
      return false;
    }
  }

  // Refresh current user data
  Future<void> refreshUser() async {
    if (_currentUser == null) return;

    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to refresh user data: ${e.toString()}');
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _authRepository.close();
    super.dispose();
  }
}

