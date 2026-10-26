import 'package:flutter/material.dart';
import 'package:flutter_playground/data/models/movie.dart';
import 'package:flutter_playground/data/models/tv_show.dart';
import 'package:flutter_playground/data/services/tmdb_service.dart';
import 'package:flutter_playground/widgets/hero_carousel.dart';
import 'package:flutter_playground/widgets/movie_poster_card.dart';
import 'package:flutter_playground/widgets/ranked_movie_tile.dart';
import 'package:flutter_playground/widgets/section_widgets.dart';
import 'package:flutter_playground/widgets/tv_show_card.dart';

import '../widgets/category_chips.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = TmdbService();
  HomeCategory _category = HomeCategory.all;

  final Map<String, Future<dynamic>> _cache = {};

  Future<T> _cached<T>(String key, Future<T> Function() load) =>
      _cache.putIfAbsent(key, load) as Future<T>;

  void _retry() => setState(_cache.clear);

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Widget _hero() {
    return AsyncSection(
      future: _cached('trending', _service.getTrendingMovies),
      loadingHeight: 260,
      onRetry: _retry,
      builder: (context, movies) {
        final featured = movies
            .where((m) => m.backdropPath != null)
            .take(5)
            .toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HeroCarousel(
            movies: featured,
            onTrailerTap: (m) => debugPrint('Trailer: ${m.title}'),
            onMovieTap: (m) => debugPrint('Detail: ${m.title}'),
          ),
        );
      },
    );
  }

  Widget _movieShelf({
    required String key,
    required String title,
    required IconData icon,
    required Future<List<Movie>> Function() load,
    bool showRank = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, icon: icon),
          AsyncSection<List<Movie>>(
            future: _cached(key, load),
            loadingHeight: 312,
            onRetry: _retry,
            builder: (context, movies) {
              final items = movies.take(10).toList();

              return HorizontalShelf(
                height: 312,
                children: [
                  for (var i = 0; i < items.length; i++)
                    MoviePosterCard(
                      movie: items[i],
                      rank: showRank ? i + 1 : null,
                      onTap: () => debugPrint('Detail: ${items[i].title}'),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tvShelf({
    required String key,
    required String title,
    required IconData icon,
    required Future<List<TvShow>> Function() load,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, icon: icon),
          AsyncSection<List<TvShow>>(
            future: _cached(key, load),
            loadingHeight: 236,
            onRetry: _retry,
            builder: (context, shows) {
              final items = shows.take(10).toList();

              return HorizontalShelf(
                height: 236,
                children: [
                  for (final show in items)
                    TvShowCard(
                      show: show,
                      onTap: () => debugPrint('Detail TV: ${show.name}'),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _rankedList({
    required String key,
    required String title,
    required IconData icon,
    required String trailing,
    required Future<List<Movie>> Function() load,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, icon: icon, trailing: trailing),
          AsyncSection<List<Movie>>(
            future: _cached(key, load),
            loadingHeight: 200,
            onRetry: _retry,
            builder: (context, movies) {
              final items = movies.take(5).toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RankedMovieTile(
                          movie: items[i],
                          rank: i + 1,
                          onTap: () => debugPrint('Detail: ${items[i].title}'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _content() {
    final trending = _movieShelf(
      key: 'trending',
      title: 'Trending Movies',
      icon: Icons.local_fire_department_rounded,
      load: _service.getTrendingMovies,
      showRank: true,
    );
    final popularTv = _tvShelf(
      key: 'popularTv',
      title: 'Popular TV Shows',
      icon: Icons.tv_rounded,
      load: _service.getPopularTvShows,
    );
    final nowPlaying = _rankedList(
      key: 'nowPlaying',
      title: 'Now Playing',
      icon: Icons.leaderboard_rounded,
      trailing: 'This Week',
      load: _service.getNowPlayingMovies,
    );

    switch (_category) {
      case HomeCategory.all:
        return [_hero(), trending, popularTv, nowPlaying];
      case HomeCategory.movies:
        return [_hero(), trending, nowPlaying];
      case HomeCategory.tvShows:
        return [
          popularTv,
          _tvShelf(
            key: 'topRatedTv',
            title: 'Top Rated TV Shows',
            icon: Icons.star_rounded,
            load: _service.getTopRatedTvShows,
          ),
        ];
      case HomeCategory.topRated:
        return [
          _movieShelf(
            key: 'topRatedMovies',
            title: 'Top Rated Movies',
            icon: Icons.star_rounded,
            load: _service.getTopRatedMovies,
            showRank: true,
          ),
          _tvShelf(
            key: 'topRatedTv',
            title: 'Top Rated TV Shows',
            icon: Icons.tv_rounded,
            load: _service.getTopRatedTvShows,
          ),
        ];
      case HomeCategory.upcoming:
        return [
          _movieShelf(
            key: 'upcoming',
            title: 'Upcoming Movies',
            icon: Icons.upcoming_rounded,
            load: _service.getUpcomingMovies,
          ),
        ];
      case HomeCategory.anime:
        return [
          _movieShelf(
            key: 'animeMovies',
            title: 'Anime Movies',
            icon: Icons.movie_filter_rounded,
            load: _service.getAnimeMovies,
          ),
          _tvShelf(
            key: 'animeTv',
            title: 'Anime Series',
            icon: Icons.live_tv_rounded,
            load: _service.getAnimeTvShows,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeader(
          onSearchSubmitted: (query) {
            debugPrint('Cari: $query');
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                children: [
                  CategoryChips(
                    selected: _category,
                    onSelected: (c) => setState(() => _category = c),
                  ),
                  const SizedBox(height: 8),
                  ..._content()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
