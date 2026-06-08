class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String? summary;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    this.summary,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? 'Unknown',
      posterUrl: json['poster_url'] ?? '',
      summary: json['summary'],
    );
  }
}
