import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: text.headlineLarge),
            const Spacer(),
            Center(
              child: Text(
                'This product uses the TMDB API but is not endorsed '
                'or certified by TMDB.',
                textAlign: TextAlign.center,
                style: text.bodySmall?.copyWith(color: AppColors.outline),
              ),
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}