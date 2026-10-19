import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';
import 'package:flutter_playground/data/models/movie.dart';

class HeroCarousel extends StatefulWidget {
  final List<Movie> movies;
  final ValueChanged<Movie>? onTrailerTap;
  final ValueChanged<Movie>? onMovieTap;

  const HeroCarousel({
    super.key,
    required this.movies,
    this.onTrailerTap,
    this.onMovieTap,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final _controller = PageController();
  int _page = 0;

  final Set<int> _saved = {};

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWith = constraints.maxWidth - 32;
            final height = cardWith / 1.6 + _HeroCard.contentHeight;

            return Column(
              children: [
                SizedBox(
                  height: height,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: widget.movies.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (context, i) {
                      final movie = widget.movies[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _HeroCard(
                          movie: movie,
                          saved: _saved.contains(movie.id),
                          onSaveTap: () => setState(() {
                            _saved.contains(movie.id)
                                ? _saved.remove(movie.id)
                                : _saved.add(movie.id);
                          }),
                          onTrailerTap: () => widget.onTrailerTap?.call(movie),
                          onTap: () => widget.onMovieTap?.call(movie),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _Dots(count: widget.movies.length, index: _page),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  static const double contentHeight = 208;

  final Movie movie;
  final bool saved;
  final VoidCallback onSaveTap;
  final VoidCallback onTrailerTap;
  final VoidCallback onTap;

  const _HeroCard({
    required this.movie,
    required this.saved,
    required this.onSaveTap,
    required this.onTrailerTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: AppColors.surfaceContainerHigh,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: movie.backdropUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const ColoredBox(color: AppColors.surfaceContainer),
                      errorWidget: (_, __, ___) => const ColoredBox(
                        color: AppColors.surfaceContainer,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.surfaceContainerHigh,
                            AppColors.surfaceContainerHigh.withValues(
                              alpha: 0.4,
                            ),
                            Colors.transparent,
                          ],
                          stops: const [0, 0.35, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _FeaturedBadge(textStyle: text.labelSmall),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _SavedButton(saved: saved, onTap: onSaveTap),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: contentHeight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.headlineMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${movie.year} • ${movie.votesText}',
                                  style: text.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _RatingCapsule(rating: movie.ratingText),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 22,
                        child: ClipRect(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final g in movie.genres.take(3))
                                _GenreChip(label: g),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isEmpty
                            ? 'Belum ada sinopsi.'
                            : movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(height: 1.5),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: FilledButton.icon(
                                onPressed: onTrailerTap,
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 22,
                                ),
                                label: const Text('Watch Trailer'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.tertiaryFixed,
                                  foregroundColor: AppColors.onTertiaryFixed,
                                  shape: const StadiumBorder(),
                                  textStyle: text.labelLarge,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: onSaveTap,
                            tooltip: 'Add to watchlist',
                            icon: const Icon(Icons.playlist_add_rounded),
                            color: AppColors.onSurface,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surfaceContainer,
                              fixedSize: const Size(44, 44),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  final TextStyle? textStyle;
  const _FeaturedBadge({this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'FEATURE TODAY',
            style: textStyle?.copyWith(
              color: AppColors.tertiary,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedButton extends StatelessWidget {
  final bool saved;
  final VoidCallback onTap;

  const _SavedButton({required this.saved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            saved ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
            size: 20,
            color: saved ? AppColors.tertiary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _RatingCapsule extends StatelessWidget {
  final String rating;

  const _RatingCapsule({required this.rating});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 18, color: AppColors.tertiary),
          const SizedBox(width: 4),
          Text(
            rating,
            style: text.headlineSmall?.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;

  const _GenreChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: text.labelSmall),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 24 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index
                  ? AppColors.tertiary
                  : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
