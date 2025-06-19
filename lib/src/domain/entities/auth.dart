import 'package:personal/src/domain/entities/user.dart';

class Auth {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final DateTime? expiresAt;
  final User? user;

  const Auth({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.expiresAt,
    this.user,
  });

  Auth copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    DateTime? expiresAt,
    User? user,
  }) {
    return Auth(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      expiresAt: expiresAt ?? this.expiresAt,
      user: user ?? this.user,
    );
  }

  /// Check if token is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if token will expire soon (within 5 minutes)
  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return expiresAt!.isBefore(fiveMinutesFromNow);
  }

  /// Check if authenticated
  bool get isAuthenticated => accessToken != null && !isExpired;

  /// Get authorization header value
  String? get authorizationHeader {
    if (accessToken == null) return null;
    final type = tokenType ?? 'Bearer';
    return '$type $accessToken';
  }

  @override
  String toString() {
    return 'Auth(tokenType: $tokenType, isAuthenticated: $isAuthenticated, user: ${user?.email})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Auth && other.accessToken == accessToken;
  }

  @override
  int get hashCode => accessToken.hashCode;
}
