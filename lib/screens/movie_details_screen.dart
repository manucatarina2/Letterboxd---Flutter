import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../services/supabase_service.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form.dart';
import '../widgets/highlight_carousel.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  List<Review> _reviews = [];
  List<Movie> _trendingMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final supabase = context.read<SupabaseService>();
    final reviews = await supabase.getMovieReviews(widget.movie.id);
    final trending = await supabase.getTrendingMovies();
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _trendingMovies = trending;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Poster with gradient
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: CachedNetworkImage(
                    imageUrl: widget.movie.posterUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xFF14181C)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                ),
              ],
            ),
            
            // Resumo do Filme
            if (widget.movie.summary != null && widget.movie.summary!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Text(
                  widget.movie.summary!,
                  style: const TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ),

            // Avaliação Fixa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF14181C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: ReviewForm(movie: widget.movie, onSubmitted: _loadData),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Avaliações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF00E054)))
            else if (_reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Nenhuma avaliação ainda. Seja o primeiro!', style: TextStyle(color: Colors.white54)),
              )
            else
              ..._reviews.map((r) => ReviewCard(review: r)),
              
            const SizedBox(height: 20),
            if (!_isLoading && _trendingMovies.isNotEmpty)
              HighlightCarousel(movies: _trendingMovies),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
