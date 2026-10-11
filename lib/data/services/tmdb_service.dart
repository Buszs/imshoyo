import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/secrets.dart';
import '../../core/constants/api_constants.dart';

class TmdbException implements Exception {
  final String message;
  final int? statusCode;

  TmdbException(this.message, {this.statusCode});

  @override
  String toString() => 'TmdbException($statusCode): $message';
}

class TmdbService {
  final http.Client _client;

  TmdbService({http.Client? client}) : _client = client ?? http.Client();

  /// Fungsi dasar: semua request lewat sini.
  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, String>? params,
  ]) async {
    final uri = Uri.https(ApiConstants.host, '${ApiConstants.basePath}$path', {
      'api_key': Secrets.tmdbApiKey,
      'language': 'en-US',
      ...?params,
    });

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      if (response.statusCode == 401) {
        throw TmdbException(
          'API key tidak valid. Cek secrets.dart',
          statusCode: 401,
        );
      }
      throw TmdbException('Gagal memuat data', statusCode: response.statusCode);
    } on TmdbException {
      rethrow;
    } catch (e) {
      throw TmdbException('Tidak bisa terhubung ke server: $e');
    }
  }

  /// Ambil list "results" dari respons.
  Future<List<Map<String, dynamic>>> _getList(
    String path, [
    Map<String, String>? params,
  ]) async {
    final data = await _get(path, params);
    final results = data['results'] as List<dynamic>? ?? [];
    return results.cast<Map<String, dynamic>>();
  }

  // ---------- Movies ----------
  Future<List<Map<String, dynamic>>> getTrendingMovies() =>
      _getList('/trending/movie/day');

  Future<List<Map<String, dynamic>>> getTopRatedMovies() =>
      _getList('/movie/top_rated');

  Future<List<Map<String, dynamic>>> getUpcomingMovies() =>
      _getList('/movie/upcoming');

  Future<List<Map<String, dynamic>>> getNowPlayingMovies() =>
      _getList('/movie/now_playing');

  // ---------- TV Shows ----------
  Future<List<Map<String, dynamic>>> getPopularTvShows() =>
      _getList('/tv/popular');

  Future<List<Map<String, dynamic>>> getTopRatedTvShows() =>
      _getList('/tv/top_rated');

  // ---------- Search ----------
  /// Cari film, TV, dan orang sekaligus.
  Future<List<Map<String, dynamic>>> searchMulti(String query) =>
      _getList('/search/multi', {'query': query});

  // ---------- Detail ----------
  Future<Map<String, dynamic>> getMovieDetail(int id) => _get('/movie/$id');

  Future<Map<String, dynamic>> getTvDetail(int id) => _get('/tv/$id');

  void dispose() => _client.close();
}
