import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';

enum HomeCategory {
  all('All'),
  movies('Movies'),
  tvShows('TV Shows'),
  topRated('Top Rated'),
  upcoming('Upcoming'),
  anime('Anime');

  final String label;
  const HomeCategory(this.label);
}

class CategoryChips extends StatelessWidget {
  final HomeCategory selected;
  final ValueChanged<HomeCategory> onSelected;

  const CategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;
    const categories = HomeCategory.values;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 4),
        itemBuilder: (context, i) {
          final category = categories[i];
          final isActive = category == selected;

          return Material(
            color: isActive
                ? AppColors.tertiaryFixed
                : AppColors.surfaceContainerHigh,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onSelected(category),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    category.label,
                    style: text.labelMedium?.copyWith(
                      color: isActive
                          ? AppColors.onTertiaryFixed
                          : AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
