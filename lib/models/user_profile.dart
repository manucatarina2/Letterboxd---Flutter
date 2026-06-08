class UserProfile {
  final String id;
  final String username;
  final String avatarUrl;
  final String bio;
  final int watchedCount;
  final int followersCount;
  final int followingCount;

  UserProfile({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.bio,
    this.watchedCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      username: json['username'] ?? 'User',
      avatarUrl: json['avatar_url'] ?? '',
      bio: json['bio'] ?? '',
      watchedCount: json['watched_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
    );
  }
}
