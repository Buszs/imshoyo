import 'package:flutter_playground/core/constants/api_constants.dart';
import 'package:flutter_playground/core/constants/genres.dart';

class TvShow {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? firstAirDate;
  final List<String> genres;

  final int? numberOfSeasons;
  final int? numberOfEpisodes;

  const TvShow({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.firstAirDate,
    this.genres = const [],
    this.numberOfSeasons,
    this.numberOfEpisodes,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? 'untitled',
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as int?) ?? 0,
      firstAirDate: json['first_air_date'] as String?,
      genres: _parseGenres(json),
      numberOfSeasons: json['number_of_seasons'] as int?,
      numberOfEpisodes: json['number_of_episodes'] as int?,
    );
  }

  static List<String> _parseGenres(Map<String, dynamic> json) {
    if (json['genres'] is List) {
      return (json['genres'] as List).map((g) => (g as Map<String, dynamic>)['name'] as String).toList();
    }
    final ids = (json['genre_ids'] as List <dynamic>? ?? []).cast<int>();
    return Genres.fromIds(ids);
  }

  String get posterUrl => ApiConstants.poster(posterPath);
  String get backdropUrl => ApiConstants.backdrop(backdropPath);

  String get year => (firstAirDate != null && firstAirDate!.length >= 4)
      ? firstAirDate!.substring(0, 4)
      : '-';

  String get ratingText => voteAverage.toStringAsFixed(1);

  String get genreText => genres.take(2).join(' • ');

  String get seasonText =>
      numberOfSeasons == null ? '' : 'Season $numberOfSeasons';
}
