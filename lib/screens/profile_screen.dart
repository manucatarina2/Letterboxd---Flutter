import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/user_profile.dart';
import '../services/supabase_service.dart';
import '../widgets/movie_grid.dart';
import '../widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  List<Movie> _watchedMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final supabase = context.read<SupabaseService>();
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    final profile = await supabase.getUserProfile(currentUserId);
    final movies = await supabase.getUserMovies(currentUserId);

    if (mounted) {
      setState(() {
        _profile = profile;
        _watchedMovies = movies;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<SupabaseService>().signOut();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E054)))
          : Column(
              children: [
                if (_profile != null) ProfileHeader(profile: _profile!),
                const Divider(color: Colors.white24, height: 1),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Filmes Avaliados',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: MovieGrid(movies: _watchedMovies),
                ),
              ],
            ),
    );
  }
}
