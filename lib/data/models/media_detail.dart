import '../../core/constants/api_constants.dart';

/// Detail lengkap satu film atau acara TV.
class MediaDetail {
  final int id;
  final bool isTv;
  final String title;
  final String? tagline;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? date; // tanggal rilis / tayang perdana
  final List<String> genres;
  final String? status;
  final int? runtime; // film
  final int? seasons; // TV
  final int? episodes; // TV
  final String? trailerKey; // ID video YouTube

  const MediaDetail({
    required this.id,
    required this.isTv,
    required this.title,
    required this.overview,
    this.tagline,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.date,
    this.genres = const [],
    this.status,
    this.runtime,
    this.seasons,
    this.episodes,
    this.trailerKey,
  });

  factory MediaDetail.fromJson(
    Map<String, dynamic> json, {
    required bool isTv,
  }) {
    final videos = (json['videos']?['results'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final tagline = json['tagline'] as String?;

    return MediaDetail(
      id: json['id'] as int,
      isTv: isTv,
      title: ((isTv ? json['name'] : json['title']) as String?) ?? 'Untitled',
      tagline: (tagline == null || tagline.isEmpty) ? null : tagline,
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as int?) ?? 0,
      date: (isTv ? json['first_air_date'] : json['release_date']) as String?,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((g) => (g as Map<String, dynamic>)['name'] as String)
          .toList(),
      status: json['status'] as String?,
      runtime: json['runtime'] as int?,
      seasons: json['number_of_seasons'] as int?,
      episodes: json['number_of_episodes'] as int?,
      trailerKey: pickTrailerKey(videos),
    );
  }

  /// Pilih video YouTube terbaik: Trailer resmi > Trailer > Teaser.
  static String? pickTrailerKey(List<Map<String, dynamic>> videos) {
    final youtube = videos.where((v) => v['site'] == 'YouTube').toList();
    final trailers = youtube.where((v) => v['type'] == 'Trailer').toList();
    final pool = trailers.isNotEmpty
        ? trailers
        : youtube.where((v) => v['type'] == 'Teaser').toList();
    if (pool.isEmpty) return null;

    final official = pool.where((v) => v['official'] == true).toList();
    return (official.isNotEmpty ? official.first : pool.first)['key']
        as String?;
  }

  // ---------- Getter siap pakai untuk UI ----------

  String get posterUrl => ApiConstants.poster(posterPath);
  String get backdropUrl => ApiConstants.backdrop(backdropPath, size: 'w1280');

  String get year =>
      (date != null && date!.length >= 4) ? date!.substring(0, 4) : '-';

  String get ratingText => voteAverage.toStringAsFixed(1);

  String get votesText => voteCount >= 1000
      ? '${(voteCount / 1000).toStringAsFixed(1)}k votes'
      : '$voteCount votes';

  /// "2h 46m", kosong kalau tidak ada.
  String get durationText {
    if (runtime == null || runtime == 0) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  /// Baris kecil di bawah judul: "2024 • 2h 46m" atau "2022 • 3 Seasons".
  String get metaText {
    final parts = <String>[year];
    if (isTv) {
      if (seasons != null) {
        parts.add('$seasons Season${seasons == 1 ? '' : 's'}');
      }
    } else if (durationText.isNotEmpty) {
      parts.add(durationText);
    }
    return parts.join(' • ');
  }
}
