import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/placeholder_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const PlaceholderPage(title: 'Home', icon: Icons.home_rounded);
  }
}