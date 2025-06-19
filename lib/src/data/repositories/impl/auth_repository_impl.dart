// lib/src/data/repositories/impl/auth_repository_impl.dart

import 'dart:async';

import '../../../core/di/injection.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/auth.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient = getIt<ApiClient>();

  // Stream controller for auth state changes
  final StreamController<Auth?> _authStateController =
      StreamController<Auth?>.broadcast();

  @override
  Stream<Auth?> get authStateChanges => _authStateController.stream;

  @override
  Future<Auth> login({required String email, required String password}) async {
    try {
      // TODO: Replace with actual API call when backend is ready
      // final response = await _apiClient.post(
      //   ApiConstants.authLogin,
      //   data: {
      //     'email': email,
      //     'password': password,
      //   },
      // );

      // For now, return a mock auth object
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Create mock user
      final user = User(
        id: 'user_123',
        fullName: 'John Doe',
        email: email,
        profileImageUrl: null,
        portfolioValue: 12345.67,
        cashBalance: 5000.00,
        notificationsEnabled: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );

      // Create mock auth
      final auth = Auth(
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        tokenType: 'Bearer',
        expiresIn: 3600, // 1 hour
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        user: user,
      );

      // Store auth locally
      await storeAuth(auth);

      // Emit auth state change
      _authStateController.add(auth);

      return auth;

      /*
      TODO: When implementing with real API, use this pattern:

      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Convert response to Auth entity using converter
      final auth = AuthConverter.fromJson(response.data);

      // Store auth locally
      await storeAuth(auth);

      // Emit auth state change
      _authStateController.add(auth);

      return auth;
      */
    } catch (e) {
      // Handle different types of errors
      if (e is ApiException) {
        if (e.isUnauthorized) {
          throw Exception('Invalid email or password');
        } else if (e.isNetworkError) {
          throw Exception('Network error. Please check your connection.');
        } else {
          throw Exception(e.message);
        }
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Auth> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Validate passwords match
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      // TODO: Replace with actual API call when backend is ready
      // final response = await _apiClient.post(
      //   ApiConstants.authRegister,
      //   data: {
      //     'fullName': fullName,
      //     'email': email,
      //     'password': password,
      //     'confirmPassword': confirmPassword,
      //   },
      // );

      // For now, return a mock auth object
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Create mock user
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName,
        email: email,
        profileImageUrl: null,
        portfolioValue: 0.0,
        cashBalance: 0.0,
        notificationsEnabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create mock auth
      final auth = Auth(
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        tokenType: 'Bearer',
        expiresIn: 3600, // 1 hour
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        user: user,
      );

      // Store auth locally
      await storeAuth(auth);

      // Emit auth state change
      _authStateController.add(auth);

      return auth;

      /*
      TODO: When implementing with real API, use this pattern:

      final response = await _apiClient.post(
        ApiConstants.authRegister,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      // Convert response to Auth entity using converter
      final auth = AuthConverter.fromJson(response.data);

      // Store auth locally
      await storeAuth(auth);

      // Emit auth state change
      _authStateController.add(auth);

      return auth;
      */
    } catch (e) {
      // Handle different types of errors
      if (e is ApiException) {
        if (e.isValidationError) {
          // Extract validation errors if available
          final fieldErrors = e.errors;
          if (fieldErrors != null && fieldErrors.isNotEmpty) {
            final firstError = fieldErrors.values.first.first;
            throw Exception(firstError);
          }
          throw Exception('Validation error. Please check your input.');
        } else if (e.isNetworkError) {
          throw Exception('Network error. Please check your connection.');
        } else {
          throw Exception(e.message);
        }
      }
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // TODO: Call logout endpoint when backend is ready
      // await _apiClient.post(ApiConstants.authLogout);

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear stored auth
      await clearAuth();

      // Emit auth state change
      _authStateController.add(null);

      /*
      TODO: When implementing with real API, use this pattern:

      try {
        await _apiClient.post(ApiConstants.authLogout);
      } catch (e) {
        // Continue with logout even if API call fails
        print('Logout API call failed: $e');
      }

      await clearAuth();
      _authStateController.add(null);
      */
    } catch (e) {
      // Always clear local auth even if logout API fails
      await clearAuth();
      _authStateController.add(null);
    }
  }

  @override
  Future<Auth> refreshToken(String refreshToken) async {
    try {
      // TODO: Replace with actual API call when backend is ready
      // final response = await _apiClient.post(
      //   ApiConstants.authRefresh,
      //   data: {'refreshToken': refreshToken},
      // );

      // For now, return a mock refreshed auth
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get current auth to preserve user data
      final currentAuth = await getCurrentAuth();
      if (currentAuth == null) {
        throw Exception('No current authentication found');
      }

      // Create new auth with refreshed tokens
      final auth = currentAuth.copyWith(
        accessToken:
            'mock_refreshed_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_new_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      // Store refreshed auth
      await storeAuth(auth);

      // Emit auth state change
      _authStateController.add(auth);

      return auth;

      /*
      TODO: When implementing with real API, use this pattern:

      final response = await _apiClient.post(
        ApiConstants.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final auth = AuthConverter.fromJson(response.data);
      await storeAuth(auth);
      _authStateController.add(auth);

      return auth;
      */
    } catch (e) {
      // If refresh fails, clear auth and force re-login
      await clearAuth();
      _authStateController.add(null);
      throw Exception('Token refresh failed. Please login again.');
    }
  }

  @override
  Future<Auth?> getCurrentAuth() async {
    try {
      // TODO: Implement SharedPreferences storage
      // For now, return null (no stored auth)

      // Simulate getting from storage
      await Future.delayed(const Duration(milliseconds: 100));

      // TODO: Get from SharedPreferences and convert to Auth entity
      // final authJson = sharedPreferences.getString(ApiConstants.storageKeyAuth);
      // if (authJson != null) {
      //   return AuthConverter.fromJson(jsonDecode(authJson));
      // }

      return null;

      /*
      TODO: When implementing with SharedPreferences:

      final sharedPreferences = getIt<SharedPreferences>();
      final authJson = sharedPreferences.getString(ApiConstants.storageKeyAuthToken);

      if (authJson != null) {
        final authData = jsonDecode(authJson);
        return AuthConverter.fromJson(authData);
      }

      return null;
      */
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final auth = await getCurrentAuth();
      return auth != null && auth.isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> storeAuth(Auth auth) async {
    try {
      // TODO: Implement SharedPreferences storage
      // For now, just simulate storage
      await Future.delayed(const Duration(milliseconds: 50));

      /*
      TODO: When implementing with SharedPreferences:

      final sharedPreferences = getIt<SharedPreferences>();
      final authJson = jsonEncode(AuthConverter.toJson(auth));

      await sharedPreferences.setString(
        ApiConstants.storageKeyAuthToken,
        authJson,
      );

      // Also store individual tokens for easy access
      if (auth.accessToken != null) {
        await sharedPreferences.setString(
          ApiConstants.storageKeyAccessToken,
          auth.accessToken!,
        );
      }

      if (auth.refreshToken != null) {
        await sharedPreferences.setString(
          ApiConstants.storageKeyRefreshToken,
          auth.refreshToken!,
        );
      }
      */
    } catch (e) {
      throw Exception('Failed to store authentication data');
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      // TODO: Implement SharedPreferences clearing
      // For now, just simulate clearing
      await Future.delayed(const Duration(milliseconds: 50));

      /*
      TODO: When implementing with SharedPreferences:

      final sharedPreferences = getIt<SharedPreferences>();

      await Future.wait([
        sharedPreferences.remove(ApiConstants.storageKeyAuthToken),
        sharedPreferences.remove(ApiConstants.storageKeyAccessToken),
        sharedPreferences.remove(ApiConstants.storageKeyRefreshToken),
        sharedPreferences.remove(ApiConstants.storageKeyUserProfile),
      ]);

      // Also clear API client auth header
      _apiClient.clearAuthToken();
      */
    } catch (e) {
      // Don't throw error for clearing - best effort
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      // Validate passwords
      if (newPassword != confirmPassword) {
        throw Exception('New passwords do not match');
      }

      if (newPassword.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }

      // TODO: Replace with actual API call when backend is ready
      // await _apiClient.put(
      //   ApiConstants.authChangePassword,
      //   data: {
      //     'currentPassword': currentPassword,
      //     'newPassword': newPassword,
      //     'confirmPassword': confirmPassword,
      //   },
      // );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      /*
      TODO: When implementing with real API:

      await _apiClient.put(
        ApiConstants.authChangePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      */
    } catch (e) {
      if (e is ApiException) {
        if (e.isUnauthorized) {
          throw Exception('Current password is incorrect');
        } else if (e.isValidationError) {
          throw Exception('Password validation failed');
        } else {
          throw Exception(e.message);
        }
      }
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      // TODO: Replace with actual API call when backend is ready
      // await _apiClient.post(
      //   ApiConstants.authForgotPassword,
      //   data: {'email': email},
      // );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      /*
      TODO: When implementing with real API:

      await _apiClient.post(
        ApiConstants.authForgotPassword,
        data: {'email': email},
      );
      */
    } catch (e) {
      if (e is ApiException) {
        throw Exception(e.message);
      }
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      // Validate passwords
      if (newPassword != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      // TODO: Replace with actual API call when backend is ready
      // await _apiClient.post(
      //   ApiConstants.authResetPassword,
      //   data: {
      //     'token': token,
      //     'newPassword': newPassword,
      //     'confirmPassword': confirmPassword,
      //   },
      // );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      /*
      TODO: When implementing with real API:

      await _apiClient.post(
        ApiConstants.authResetPassword,
        data: {
          'token': token,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      */
    } catch (e) {
      if (e is ApiException) {
        if (e.statusCode == 400) {
          throw Exception('Invalid or expired reset token');
        } else {
          throw Exception(e.message);
        }
      }
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final auth = await getCurrentAuth();
      if (auth?.user != null) {
        return auth!.user!;
      }

      // TODO: Fetch user from API if not in auth
      // final response = await _apiClient.get(ApiConstants.authProfile);
      // return UserConverter.fromJson(response.data);

      throw Exception('No authenticated user found');
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<User> updateProfile({
    String? fullName,
    String? email,
    String? profileImageUrl,
    bool? notificationsEnabled,
  }) async {
    try {
      // TODO: Replace with actual API call when backend is ready
      // final response = await _apiClient.put(
      //   ApiConstants.userUpdate,
      //   data: {
      //     if (fullName != null) 'fullName': fullName,
      //     if (email != null) 'email': email,
      //     if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      //     if (notificationsEnabled != null) 'notificationsEnabled': notificationsEnabled,
      //   },
      // );

      // For now, return updated mock user
      final currentAuth = await getCurrentAuth();
      if (currentAuth?.user == null) {
        throw Exception('No authenticated user found');
      }

      final updatedUser = currentAuth!.user!.copyWith(
        fullName: fullName,
        email: email,
        profileImageUrl: profileImageUrl,
        notificationsEnabled: notificationsEnabled,
        updatedAt: DateTime.now(),
      );

      // Update stored auth with new user data
      final updatedAuth = currentAuth.copyWith(user: updatedUser);
      await storeAuth(updatedAuth);

      // Emit auth state change
      _authStateController.add(updatedAuth);

      return updatedUser;

      /*
      TODO: When implementing with real API:

      final response = await _apiClient.put(
        ApiConstants.userUpdate,
        data: {
          if (fullName != null) 'fullName': fullName,
          if (email != null) 'email': email,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
          if (notificationsEnabled != null) 'notificationsEnabled': notificationsEnabled,
        },
      );

      final updatedUser = UserConverter.fromJson(response.data);

      // Update stored auth with new user data
      final currentAuth = await getCurrentAuth();
      if (currentAuth != null) {
        final updatedAuth = currentAuth.copyWith(user: updatedUser);
        await storeAuth(updatedAuth);
        _authStateController.add(updatedAuth);
      }

      return updatedUser;
      */
    } catch (e) {
      if (e is ApiException) {
        throw Exception(e.message);
      }
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // TODO: Replace with actual API call when backend is ready
      // await _apiClient.delete(ApiConstants.userDelete);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Clear local auth after account deletion
      await clearAuth();
      _authStateController.add(null);

      /*
      TODO: When implementing with real API:

      await _apiClient.delete(ApiConstants.userDelete);
      await clearAuth();
      _authStateController.add(null);
      */
    } catch (e) {
      if (e is ApiException) {
        throw Exception(e.message);
      }
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  // Clean up resources
  void dispose() {
    _authStateController.close();
  }
}
