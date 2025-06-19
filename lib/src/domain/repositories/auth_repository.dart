import '../entities/auth.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Auth> login({required String email, required String password});

  /// Register new user account
  Future<Auth> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  });

  /// Logout current user
  Future<void> logout();

  /// Refresh access token using refresh token
  Future<Auth> refreshToken(String refreshToken);

  /// Get currently stored authentication
  Future<Auth?> getCurrentAuth();

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated();

  /// Store authentication data locally
  Future<void> storeAuth(Auth auth);

  /// Clear stored authentication data
  Future<void> clearAuth();

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// Send password reset email
  Future<void> forgotPassword(String email);

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });

  /// Get current user profile
  Future<User> getCurrentUser();

  /// Update user profile
  Future<User> updateProfile({
    String? fullName,
    String? email,
    String? profileImageUrl,
    bool? notificationsEnabled,
  });

  /// Delete user account
  Future<void> deleteAccount();

  /// Stream of authentication state changes
  Stream<Auth?> get authStateChanges;
}
