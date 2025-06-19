import '../entities/user.dart';

abstract class UserRepository {
  /// Get user by ID
  Future<User> getUserById(String userId);

  /// Get current user profile
  Future<User> getCurrentUserProfile();

  /// Update user profile
  Future<User> updateUserProfile({
    String? fullName,
    String? email,
    String? profileImageUrl,
    bool? notificationsEnabled,
  });

  /// Upload profile image
  Future<String> uploadProfileImage(String imagePath);

  /// Update notification settings
  Future<void> updateNotificationSettings(bool enabled);

  /// Get user preferences
  Future<Map<String, dynamic>> getUserPreferences();

  /// Update user preferences
  Future<void> updateUserPreferences(Map<String, dynamic> preferences);

  /// Update cash balance
  Future<User> updateCashBalance(double newBalance);

  /// Add to cash balance
  Future<User> addCashBalance(double amount);

  /// Subtract from cash balance
  Future<User> subtractCashBalance(double amount);

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics();

  /// Delete user account
  Future<void> deleteUser();

  /// Search users (for admin purposes)
  Future<List<User>> searchUsers({String? query, int? limit, int? offset});
}
