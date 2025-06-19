// lib/src/presentation/cubits/auth/auth_cubit.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/auth.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = getIt<AuthRepository>();

  AuthCubit() : super(AuthInitial());

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final auth = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthSuccess(auth: auth));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Register new user account
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    try {
      final auth = await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(AuthSuccess(auth: auth));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Logout current user
  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Check if user is currently authenticated
  Future<void> checkAuthStatus() async {
    try {
      final auth = await _authRepository.getCurrentAuth();
      if (auth != null && auth.isAuthenticated) {
        emit(AuthSuccess(auth: auth));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    try {
      final currentAuth = await _authRepository.getCurrentAuth();
      if (currentAuth?.refreshToken != null) {
        final auth = await _authRepository.refreshToken(
          currentAuth!.refreshToken!,
        );
        emit(AuthSuccess(auth: auth));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      // Keep current auth state but show success
      if (state is AuthSuccess) {
        final currentState = state as AuthSuccess;
        emit(AuthPasswordChanged(auth: currentState.auth));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Send password reset email
  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());

    try {
      await _authRepository.forgotPassword(email);
      emit(AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    try {
      await _authRepository.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(AuthPasswordReset());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Get current user
  User? get currentUser {
    if (state is AuthSuccess) {
      return (state as AuthSuccess).auth.user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    return state is AuthSuccess && (state as AuthSuccess).auth.isAuthenticated;
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      emit(AuthInitial());
    }
  }
}
