import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';
import 'package:flutter_playground/data/models/movie.dart';
import 'package:flutter_playground/widgets/media_parts.dart';

class RankedMovieTile extends StatelessWidget {
  final Movie movie;
  final int rank;
  final VoidCallback? onTap;

  const RankedMovieTile({
    super.key,
    required this.movie,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  rank.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  style: text.headlineMedium?.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 48,
                  height: 64,
                  child: TmdbImage(movie.posterUrl),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      movie.genreText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${movie.year} • ${movie.votesText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall?.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              RatingBadge(movie.ratingText),
            ],
          ),
        ),
      ),
    );
  }
}
