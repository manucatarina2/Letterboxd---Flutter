import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../models/user_profile.dart';
import 'package:flutter/foundation.dart';
class SupabaseService {
  final _supabase = Supabase.instance.client;

  Future<List<Movie>> getTrendingMovies() async {
    final data = await _supabase.from('movies').select().limit(10);
    return data.map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final data = await _supabase
        .from('movies')
        .select()
        .ilike('title', '%$query%')
        .limit(20);
    return data.map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Review>> getRecentReviews() async {
    final user = _supabase.auth.currentUser;
    final data = await _supabase.from('reviews').select('''
      *,
      user:profiles!reviews_user_id_fkey(*),
      movie:movies(*),
      likes:review_likes(*)
    ''').order('created_at', ascending: false).limit(20);
    return data.map((e) {
      final likes = (e['likes'] as List<dynamic>?) ?? [];
      final isLiked = user != null && likes.any((l) => l['user_id'] == user.id);
      e['is_liked_by_me'] = isLiked;
      return Review.fromJson(e);
    }).toList();
  }

  Future<List<Review>> getMovieReviews(String movieId) async {
    final user = _supabase.auth.currentUser;
    final data = await _supabase.from('reviews').select('''
      *,
      user:profiles!reviews_user_id_fkey(*),
      movie:movies(*),
      likes:review_likes(*)
    ''').eq('movie_id', movieId).order('created_at', ascending: false);
    return data.map((e) {
      final likes = (e['likes'] as List<dynamic>?) ?? [];
      final isLiked = user != null && likes.any((l) => l['user_id'] == user.id);
      e['is_liked_by_me'] = isLiked;
      return Review.fromJson(e);
    }).toList();
  }

  Future<UserProfile> getUserProfile(String userId) async {
    final data = await _supabase.from('profiles').select().eq('id', userId).single();
    return UserProfile.fromJson(data);
  }

  Future<List<Movie>> getUserMovies(String userId) async {
    final data = await _supabase.from('reviews').select('movie:movies(*)').eq('user_id', userId);
    return data.map((e) => Movie.fromJson(e['movie'])).toList();
  }

  // --- Authentication ---
  
  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String username, String email, String password) async {
    // Check if the username already exists
    final existing = await _supabase
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();
    if (existing != null) {
      throw Exception('Nome de usuário já está em uso.');
    }

    final AuthResponse res = await _supabase.auth.signUp(email: email, password: password);
    final user = res.user;
    if (user != null) {
      await _supabase.from('profiles').insert({
        'id': user.id,
        'username': username,
        'avatar_url': 'https://i.pravatar.cc/150?u=${user.id}',
        'bio': 'Novo por aqui!',
      });
    } else {
      // Sign‑up failed (e.g., email already registered)
      throw Exception('Falha ao criar conta.');
    }
  }

  Future<void> submitReview(String movieId, double rating, String comment) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Você precisa estar logado para avaliar.');
    
    await _supabase.from('reviews').insert({
      'user_id': user.id,
      'movie_id': int.parse(movieId),
      'rating': rating,
      'comment': comment,
      'likes_count': 0,
    });
  }

  Future<void> toggleLike(String reviewId, bool isLikedNow) async {
    // Toggle like for a review
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('No user logged in');
      return;
    }
    final reviewIdInt = int.parse(reviewId);
    final likeTable = _supabase.from('review_likes');
    try {
      if (isLikedNow) {
        // Add like if not exists
        final existing = await likeTable
            .select()
            .eq('user_id', user.id)
            .eq('review_id', reviewIdInt)
            .maybeSingle();
        debugPrint('Existing like: $existing');
        if (existing == null) {
          await likeTable.insert({'user_id': user.id, 'review_id': reviewIdInt});
          await _supabase.rpc('increment_like', params: {'r_id': reviewIdInt});
          debugPrint('Like inserted and count incremented');
        } else {
          debugPrint('Like already exists, no insert');
        }
      } else {
        // Remove like if present
        await likeTable
            .delete()
            .eq('user_id', user.id)
            .eq('review_id', reviewIdInt);
        await _supabase.rpc('decrement_like', params: {'r_id': reviewIdInt});
        debugPrint('Like removed and count decremented');
      }
    } catch (e) {
      debugPrint('Error in toggleLike: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReplies(String reviewId) async {
    final data = await _supabase.from('review_replies').select('''
      *,
      user:profiles(*)
    ''').eq('review_id', int.parse(reviewId)).order('created_at', ascending: true);
    return data;
  }

  Future<void> submitReply(String reviewId, String content) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Você precisa estar logado para responder.');
    await _supabase.from('review_replies').insert({
      'user_id': user.id,
      'review_id': int.parse(reviewId),
      'content': content,
    });
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
