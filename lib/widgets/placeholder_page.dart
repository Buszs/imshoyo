import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.tertiary),
            const SizedBox(height: 12),
            Text(title, style: text.headlineMedium),
            const SizedBox(height: 4),
            Text('Segera hadir', style: text.bodySmall),
          ],
        ),
      ),
    );
  }
}