import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';
import 'package:flutter_playground/core/theme/app_theme.dart';

void main() {
  runApp(const IMShoyo());
}

class IMShoyo extends StatelessWidget {
  const IMShoyo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'IMShoyo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _PlaceholderScreen(),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('IMShoyo', style: text.headlineLarge),
            const SizedBox(height: 8),
            Text('Movies, TV Shows, Actors', style: text.bodySmall),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Watch Trailer',
                style: text.labelLarge?.copyWith(
                  color: AppColors.onTertiaryFixed,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}