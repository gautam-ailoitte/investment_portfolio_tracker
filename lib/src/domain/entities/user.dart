class User {
  final String? id;
  final String? fullName;
  final String? email;
  final String? profileImageUrl;
  final double? portfolioValue;
  final double? cashBalance;
  final bool? notificationsEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.fullName,
    this.email,
    this.profileImageUrl,
    this.portfolioValue,
    this.cashBalance,
    this.notificationsEnabled,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    double? portfolioValue,
    double? cashBalance,
    bool? notificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      cashBalance: cashBalance ?? this.cashBalance,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
