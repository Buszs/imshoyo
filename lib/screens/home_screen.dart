import 'package:flutter/material.dart';
import 'package:flutter_playground/data/models/movie.dart';
import 'package:flutter_playground/data/services/tmdb_service.dart';
import 'package:flutter_playground/widgets/hero_carousel.dart';

import '../core/theme/app_colors.dart';
import '../widgets/category_chips.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = TmdbService();
  late Future<List<Movie>> _trendingFuture;
  HomeCategory _category = HomeCategory.all;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _trendingFuture = _service.getTrendingMovies();
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
          child: ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              CategoryChips(
                selected: _category,
                onSelected: (c) => setState(() => _category = c),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Movie>>(
                future: _trendingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 260,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tertiary,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return _ErrorBox(message: '${snapshot.error}', onRetry: () => setState(_load));
                  }
                  final featured = snapshot.data!
                    .where((m) => m.backdropPath != null)
                    .take(5)
                    .toList();

                  return HeroCarousel(
                    movies: featured,
                    onTrailerTap: (m) => debugPrint('Trailer: ${m.title}'),
                    onMovieTap: (m) => debugPrint('Detail: ${m.title}'),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.outline),
          const SizedBox(height: 12,),
          Text(
            message,
            textAlign: TextAlign.center,
            style: text.bodySmall,
          ),
          const SizedBox(height: 12,),
          TextButton(
            onPressed: onRetry,
            child: Text('Coba lagi', style: text.labelLarge?.copyWith(color: AppColors.tertiary)),
          )
        ],
      ),
    );
  }
}
