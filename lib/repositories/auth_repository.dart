import 'dart:convert';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const String _usersBox = 'users';
  static const String _currentUserKey = 'current_user_id';
  static const String _sessionKey = 'user_session';

  Box<UserModel>? _usersBoxInstance;
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _usersBoxInstance = await Hive.openBox<UserModel>(_usersBox);
    _prefs = await SharedPreferences.getInstance();
  }

  // Generate a simple hash for password (in production, use proper hashing)
  String _hashPassword(String password) {
    // Simple hash for demo - in production use bcrypt or similar
    return base64Encode(utf8.encode(password));
  }

  // Verify password
  bool _verifyPassword(String password, String hashedPassword) {
    return _hashPassword(password) == hashedPassword;
  }

  // Generate unique user ID
  String _generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return 'user_${timestamp}_$random';
  }

  // Check if user exists by email
  Future<bool> userExists(String email) async {
    await ensureInitialized();
    final users = _usersBoxInstance!.values;
    return users.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  // Register new user
  Future<AuthResult> registerUser({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    try {
      await ensureInitialized();

      // Check if user already exists
      if (await userExists(email)) {
        return AuthResult(
          success: false,
          message: 'User with this email already exists',
        );
      }

      // Validate email format
      if (!_isValidEmail(email)) {
        return AuthResult(
          success: false,
          message: 'Please enter a valid email address',
        );
      }

      // Validate password
      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'Password must be at least 6 characters long',
        );
      }

      // Create new user
      final now = DateTime.now();
      final user = UserModel(
        id: _generateUserId(),
        email: email.toLowerCase(),
        password: _hashPassword(password),
        displayName: displayName,
        phoneNumber: phoneNumber,
        createdAt: now,
        updatedAt: now,
        isEmailVerified: false,
        isActive: true,
        preferences: {},
      );

      // Save user to Hive
      await _usersBoxInstance!.put(user.id, user);

      // Set as current user
      await _setCurrentUser(user);

      return AuthResult(
        success: true,
        message: 'Account created successfully',
        user: user,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  // Sign in user
  Future<AuthResult> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await ensureInitialized();

      // Find user by email
      final users = _usersBoxInstance!.values;
      final user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      // Check if user is active
      if (!user.isActive) {
        return AuthResult(success: false, message: 'Account is deactivated');
      }

      // Verify password
      if (!_verifyPassword(password, user.password ?? '')) {
        return AuthResult(success: false, message: 'Invalid email or password');
      }

      // Update last login
      final updatedUser = user.copyWith(
        lastLoginAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _usersBoxInstance!.put(updatedUser.id, updatedUser);

      // Set as current user
      await _setCurrentUser(updatedUser);

      return AuthResult(
        success: true,
        message: 'Signed in successfully',
        user: updatedUser,
      );
    } catch (e) {
      return AuthResult(success: false, message: 'Invalid email or password');
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _prefs?.remove(_currentUserKey);
    await _prefs?.remove(_sessionKey);
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    await ensureInitialized();
    final userId = _prefs?.getString(_currentUserKey);
    if (userId == null) return null;

    return _usersBoxInstance!.get(userId);
  }

  // Update user profile
  Future<AuthResult> updateUserProfile({
    required String userId,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      await ensureInitialized();

      final user = _usersBoxInstance!.get(userId);
      if (user == null) {
        return AuthResult(success: false, message: 'User not found');
      }

      final updatedUser = user.copyWith(
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
        preferences: preferences,
        updatedAt: DateTime.now(),
      );

      await _usersBoxInstance!.put(userId, updatedUser);

      return AuthResult(
        success: true,
        message: 'Profile updated successfully',
        user: updatedUser,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Profile update failed: ${e.toString()}',
      );
    }
  }

  // Change password
  Future<AuthResult> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await ensureInitialized();

      final user = _usersBoxInstance!.get(userId);
      if (user == null) {
        return AuthResult(success: false, message: 'User not found');
      }

      // Verify current password
      if (!_verifyPassword(currentPassword, user.password ?? '')) {
        return AuthResult(
          success: false,
          message: 'Current password is incorrect',
        );
      }

      // Validate new password
      if (newPassword.length < 6) {
        return AuthResult(
          success: false,
          message: 'New password must be at least 6 characters long',
        );
      }

      final updatedUser = user.copyWith(
        password: _hashPassword(newPassword),
        updatedAt: DateTime.now(),
      );

      await _usersBoxInstance!.put(userId, updatedUser);

      return AuthResult(
        success: true,
        message: 'Password changed successfully',
        user: updatedUser,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Password change failed: ${e.toString()}',
      );
    }
  }

  // Delete user account
  Future<AuthResult> deleteUser(String userId) async {
    try {
      await ensureInitialized();

      final user = _usersBoxInstance!.get(userId);
      if (user == null) {
        return AuthResult(success: false, message: 'User not found');
      }

      // Deactivate user instead of deleting
      final deactivatedUser = user.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );

      await _usersBoxInstance!.put(userId, deactivatedUser);
      await signOut();

      return AuthResult(success: true, message: 'Account deleted successfully');
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Account deletion failed: ${e.toString()}',
      );
    }
  }

  // Helper methods
  Future<void> ensureInitialized() async {
    if (_usersBoxInstance == null || _prefs == null) {
      await initialize();
    }
  }

  Future<void> _setCurrentUser(UserModel user) async {
    await _prefs?.setString(_currentUserKey, user.id);
    await _prefs?.setString(_sessionKey, DateTime.now().toIso8601String());
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Check if user is signed in
  Future<bool> isSignedIn() async {
    final userId = _prefs?.getString(_currentUserKey);
    if (userId == null) return false;

    final user = await getCurrentUser();
    return user != null && user.isActive;
  }

  // Get all users (for admin purposes)
  Future<List<UserModel>> getAllUsers() async {
    await ensureInitialized();
    return _usersBoxInstance!.values.toList();
  }

  // Close repository
  Future<void> close() async {
    await _usersBoxInstance?.close();
  }
}

// Auth result class
class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;

  const AuthResult({required this.success, required this.message, this.user});
}

