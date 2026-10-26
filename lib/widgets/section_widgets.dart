import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.tertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (trailing != null) Text(trailing!, style: text.labelSmall),
        ],
      ),
    );
  }
}

class AsyncSection<T> extends StatelessWidget {
  final Future<T> future;
  final double loadingHeight;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;

  const AsyncSection({
    super.key,
    required this.future,
    required this.loadingHeight,
    required this.onRetry,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: loadingHeight,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.tertiary),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: loadingHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 36,
                      color: AppColors.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: text.bodySmall,
                    ),
                    TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'Coba lagi',
                        style: text.labelLarge?.copyWith(
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final data = snapshot.data as T;
        if (data is List && data.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text('Tidak ada data.', style: text.bodySmall),
            ),
          );
        }
        return builder(context, data);
      },
    );
  }
}

class HorizontalShelf extends StatelessWidget {
  final double height;
  final List<Widget> children;

  const HorizontalShelf({
    super.key,
    required this.height,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (_, i) => children[i],
      ),
    );
  }
}
