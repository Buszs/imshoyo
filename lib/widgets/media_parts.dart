import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';

class TmdbImage extends StatelessWidget {
  final String url;

  const TmdbImage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const ColoredBox(
        color: AppColors.surfaceContainer,
        child: Center(
          child: Icon(Icons.movie_outlined, color: AppColors.outline),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_,__) => const ColoredBox(color: AppColors.surfaceContainer),
      errorWidget: (_,__,___) => const ColoredBox(
        color: AppColors.surfaceContainer,
        child: Center(
          child: Icon(Icons.movie_outlined, color: AppColors.outline),
        ),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final String rating;

  const RatingBadge(this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 13, color: AppColors.tertiary),
          const SizedBox(width: 2),
          Text(
            rating,
            style: text.labelSmall?.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w700
            ),
          )
        ],
      ),
    );
  }
}
