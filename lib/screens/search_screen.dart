import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/placeholder_page.dart';

class SearchScreen extends StatelessWidget{
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const PlaceholderPage(title: 'Serach', icon: Icons.explore_rounded);
  }
}