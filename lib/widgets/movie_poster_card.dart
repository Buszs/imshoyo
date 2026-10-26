import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';
import 'package:flutter_playground/data/models/movie.dart';
import 'package:flutter_playground/widgets/media_parts.dart';

class MoviePosterCard extends StatefulWidget {
  static const double width = 148;

  final Movie movie;

  final int? rank;
  final VoidCallback? onTap;

  const MoviePosterCard({
    super.key,
    required this.movie,
    this.rank,
    this.onTap
  });

  @override
  State<MoviePosterCard> createState() => _MoviePosterCardState();
}

class _MoviePosterCardState extends State<MoviePosterCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final movie = widget.movie;

    return SizedBox(
      width: MoviePosterCard.width,
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
                aspectRatio: 2 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TmdbImage(movie.posterUrl),
                    if (widget.rank != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#${widget.rank}',
                            style: text.labelSmall?.copyWith(color: AppColors.tertiary),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
                        shape: CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => setState(() => _saved = !_saved),
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: Icon(
                              _saved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                              size: 16,
                              color: _saved
                                  ? AppColors.tertiary
                                  : AppColors.onSurface
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: RatingBadge(movie.ratingText),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelMedium ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.genreText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          movie.year,
                          style: text.bodySmall?.copyWith(fontSize: 11),
                        ),
                        Flexible(
                          child: Text(
                            movie.votesText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              fontSize: 11,
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
