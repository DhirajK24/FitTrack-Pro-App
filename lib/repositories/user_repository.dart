import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/enums.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository<UserModel> {
  static const String _key = 'user_data';

  UserRepository(SharedPreferences prefs) : super(_key, prefs);

  @override
  Map<String, dynamic> toJson(UserModel item) => item.toJson();

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

  @override
  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // User-specific methods
  Future<UserModel?> getCurrentUser() async {
    final users = await getAll();
    return users.isNotEmpty ? users.first : null;
  }

  Future<void> saveCurrentUser(UserModel user) async {
    // Clear existing users and save the new one
    await deleteAll();
    await save(user);
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
    final currentUser = await getCurrentUser();
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      displayName: displayName,
      photoUrl: photoUrl,
      dateOfBirth: dateOfBirth,
      gender: gender,
      weight: weight,
      height: height,
      fitnessLevel: fitnessLevel,
      goals: goals,
      updatedAt: DateTime.now(),
    );

    await save(updatedUser);
  }

  Future<bool> isOnboardingComplete() async {
    final user = await getCurrentUser();
    return user != null &&
        user.displayName != null &&
        user.dateOfBirth != null &&
        user.gender != null &&
        user.weight != null &&
        user.height != null &&
        user.fitnessLevel != null;
  }

  Future<void> completeOnboarding(UserModel user) async {
    await saveCurrentUser(user);
  }

  Future<void> logout() async {
    await deleteAll();
  }
}
