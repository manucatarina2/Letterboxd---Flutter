import 'package:supabase/supabase.dart';

Future<void> main() async {
  final supabase = SupabaseClient(
    'https://zqvnoyjcfxwtirphgeud.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpxdm5veWpjZnh3dGlycGhnZXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4ODg1ODAsImV4cCI6MjA5NjQ2NDU4MH0.adm2NgbsjKLrCF_-IxCL0UvRXxRLrMRBQ11JU0ia4RY',
  );

  print('Limpando dados antigos...');
  // Apagar dados antigos (opcional, mas bom pra evitar duplicados)
  try {
    await supabase.from('reviews').delete().neq('id', 0);
    await supabase.from('movies').delete().neq('id', 0);
    await supabase.from('profiles').delete().neq('id', '00000000-0000-0000-0000-000000000000');
  } catch (e) {
    print('Erro ao limpar (ignorar se tabelas vazias): \$e');
  }

  print('Inserindo filmes...');
  final moviesData = [
    {'title': 'Dune: Part Two', 'poster_url': 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2JGqqUT1O.jpg'},
    {'title': 'Oppenheimer', 'poster_url': 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg'},
    {'title': 'Barbie', 'poster_url': 'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg'},
    {'title': 'Poor Things', 'poster_url': 'https://image.tmdb.org/t/p/w500/kCGlIMHnOm8PhbO3VFYkOweqf8s.jpg'},
    {'title': 'Spider-Man: Across the Spider-Verse', 'poster_url': 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg'},
    {'title': 'Killers of the Flower Moon', 'poster_url': 'https://image.tmdb.org/t/p/w500/dB6Krk806zeie0Z1rvq3B8iEhoA.jpg'},
  ];

  final insertedMovies = await supabase.from('movies').insert(moviesData).select();
  print('Filmes inseridos!');

  print('Inserindo perfil de teste...');
  final profileId = '11111111-1111-1111-1111-111111111111';
  final profile2Id = '22222222-2222-2222-2222-222222222222';

  await supabase.from('profiles').insert([
    {
      'id': profileId,
      'username': 'Cinephile99',
      'avatar_url': 'https://i.pravatar.cc/150?img=11',
      'bio': 'Lover of cinema, mostly sci-fi and drama. I rate everything I watch!',
      'watched_count': 342,
      'followers_count': 120,
      'following_count': 85,
    },
    {
      'id': profile2Id,
      'username': 'NolanFan',
      'avatar_url': 'https://i.pravatar.cc/150?img=12',
      'bio': 'Christopher Nolan is a genius.',
      'watched_count': 150,
      'followers_count': 30,
      'following_count': 40,
    }
  ]);
  print('Perfis inseridos!');

  print('Inserindo avaliações...');
  await supabase.from('reviews').insert([
    {
      'user_id': profileId,
      'movie_id': insertedMovies[0]['id'],
      'rating': 5.0,
      'comment': 'An absolute masterpiece. Villeneuve has done it again.',
      'likes_count': 15,
    },
    {
      'user_id': profile2Id,
      'movie_id': insertedMovies[1]['id'],
      'rating': 4.5,
      'comment': 'Visually stunning and historically complex.',
      'likes_count': 32,
    },
    {
      'user_id': profileId,
      'movie_id': insertedMovies[2]['id'],
      'rating': 4.0,
      'comment': 'So fun, vibrant and surprisingly deep.',
      'likes_count': 8,
    }
  ]);
  print('Avaliações inseridas!');
  print('Banco de dados povoado com sucesso!');
}
