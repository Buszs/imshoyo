import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_theme.dart';
import 'package:flutter_playground/data/services/tmdb_service.dart';

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
      home: const _ApiTestScreen(),
    );
  }
}

class _ApiTestScreen extends StatefulWidget {
  const _ApiTestScreen();

  @override
  State<_ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<_ApiTestScreen> {
  final _service = TmdbService();
  late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getTrendingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tes API TMDB')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, i) {
              final m = movies[i];
              return ListTile(
                title: Text(m['title'] ?? '-'),
                subtitle: Text('Rating: ${m['vote_average']}'),
              );
            }
          );
        },
      )
    );
  }
}