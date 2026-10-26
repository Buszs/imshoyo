import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';
import 'package:flutter_playground/data/models/tv_show.dart';
import 'package:flutter_playground/widgets/media_parts.dart';

class TvShowCard extends StatefulWidget {
  static const double width = 200;

  final TvShow show;
  final VoidCallback? onTap;

  const TvShowCard({super.key, required this.show, this.onTap});

  @override
  State<TvShowCard> createState() => _TvShowCardState();
}

class _TvShowCardState extends State<TvShowCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final show = widget.show;

    final imageUrl = show.backdropUrl.isNotEmpty
        ? show.backdropUrl
        : show.posterUrl;
    final label = show.seasonText.isEmpty ? show.year : show.seasonText;

    return SizedBox(
      width: TvShowCard.width,
      child: Material(
        color: AppColors.surfaceContainerHigh,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TmdbImage(imageUrl),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.surfaceContainerHigh.withValues(
                              alpha: 0.8,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: RatingBadge(show.ratingText),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(label, style: text.labelSmall),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      show.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.headlineSmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      show.genreText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => setState(() => _saved = !_saved),
                        child: SizedBox(
                          height: 32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _saved
                                    ? Icons.check_rounded
                                    : Icons.playlist_add_rounded,
                                size: 16,
                                color: _saved
                                    ? AppColors.tertiary
                                    : AppColors.onSurface,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _saved ? 'Saved' : 'Add to Watchlist',
                                style: text.labelSmall?.copyWith(
                                  color: _saved
                                      ? AppColors.tertiary
                                      : AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
