class UserProfile {
  const UserProfile({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.bio,
    this.avatarUrl,
  });

  final String userId;
  final String email;
  final String displayName;
  final String bio;
  final String? avatarUrl;

  UserProfile copyWith({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) {
    return UserProfile(
      userId: userId,
      email: email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
