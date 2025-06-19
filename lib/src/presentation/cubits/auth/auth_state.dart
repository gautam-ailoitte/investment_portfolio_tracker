// lib/src/presentation/cubits/auth/auth_state.dart

part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - user not authenticated
class AuthInitial extends AuthState {}

/// Loading state - authentication operation in progress
class AuthLoading extends AuthState {}

/// Success state - user authenticated
class AuthSuccess extends AuthState {
  final Auth auth;

  const AuthSuccess({required this.auth});

  @override
  List<Object?> get props => [auth];
}

/// Error state - authentication failed
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Password reset email sent
class AuthPasswordResetSent extends AuthState {}

/// Password reset successful
class AuthPasswordReset extends AuthState {}

/// Password changed successfully
class AuthPasswordChanged extends AuthState {
  final Auth auth;

  const AuthPasswordChanged({required this.auth});

  @override
  List<Object?> get props => [auth];
}
