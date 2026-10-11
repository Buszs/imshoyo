import 'package:flutter_playground/core/constants/api_constants.dart';
import 'package:flutter_playground/core/constants/genres.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<String> genres;

  final int? runtime;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.releaseDate,
    this.genres = const [],
    this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? 'Untitled',
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as int?) ?? 0,
      releaseDate: json['release_date'] as String?,
      genres: _parseGenres(json),
      runtime: json['runtime'] as int?,
    );
  }

  static List<String> _parseGenres(Map<String, dynamic> json) {
    if (json['genres'] is List) {
      return (json['genres'] as List)
          .map((g) => (g as Map<String, dynamic>)['name'] as String)
          .toList();
    }
    final ids = (json['genre_ids'] as List<dynamic>? ?? []).cast<int>();
    return Genres.fromIds(ids);
  }

  String get posterUrl => ApiConstants.poster(posterPath);
  String get backdropUrl => ApiConstants.backdrop(backdropPath);

  String get year => (releaseDate != null && releaseDate!.length >= 4)
      ? releaseDate!.substring(0, 4)
      : '-';

  String get ratingText => voteAverage.toStringAsFixed(1);

  String get durationText {
    if (runtime == null || runtime == 0) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  /// "Sci-Fi • Thriller" (maksimal 2 genre, seperti di kartu desain)
  String get genreText => genres.take(2).join(' • ');

  /// "4.8k votes"
  String get votesText => voteCount >= 1000
      ? '${(voteCount / 1000).toStringAsFixed(1)}k votes'
      : '$voteCount votes';
}