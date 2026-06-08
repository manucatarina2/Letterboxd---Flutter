import 'movie.dart';
import 'user_profile.dart';

class Review {
  final String id;
  final UserProfile user;
  final Movie movie;
  final double rating;
  final String comment;
  int likesCount;
  bool isLikedByMe;

  Review({
    required this.id,
    required this.user,
    required this.movie,
    required this.rating,
    required this.comment,
    this.likesCount = 0,
    this.isLikedByMe = false,
  });

  factory Review.fromJson(Map<String, dynamic> json, {UserProfile? user, Movie? movie}) {
    return Review(
      id: json['id'].toString(),
      user: user ?? UserProfile.fromJson(json['user'] ?? {}),
      movie: movie ?? Movie.fromJson(json['movie'] ?? {}),
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      isLikedByMe: json['is_liked_by_me'] ?? false,
    );
  }
}
