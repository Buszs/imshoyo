import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    this.onSearchSubmitted,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      size: 20,
                      color: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IMShoyo',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'HOME',
                          style: text.labelSmall?.copyWith(
                            color: AppColors.tertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onNotificationTap,
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.onSurface,
                    iconSize: 24,
                    tooltip: 'Notifications',
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHigh,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 22,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _SearchField(onSubmitted: onSearchSubmitted),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;

  const _SearchField({this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;

    return SizedBox(
      height: 40,
      child: TextField(
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        cursorColor: AppColors.tertiary,
        style: text.bodySmall?.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search movies, TV shows, actiors...',
          hintStyle: text.bodySmall?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.onSurface,
          ),
          filled: true,
          fillColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
