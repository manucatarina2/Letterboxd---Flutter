import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../services/supabase_service.dart';
import '../widgets/highlight_carousel.dart';
import '../widgets/review_card.dart';
import '../screens/settings_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Movie> _trendingMovies = [];
  List<Review> _recentReviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final supabase = context.read<SupabaseService>();
      final trending = await supabase.getTrendingMovies();
      final reviews = await supabase.getRecentReviews();
      
      if (mounted) {
        setState(() {
          _trendingMovies = trending;
          _recentReviews = reviews;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('ERRO DETALHADO DO SUPABASE: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letterboxd', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
                },
              ),
            ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E054)))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: const Color(0xFF00E054),
              child: ListView(
                children: [
                  HighlightCarousel(movies: _trendingMovies),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'Avaliações Recentes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._recentReviews.map((review) => ReviewCard(review: review)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
