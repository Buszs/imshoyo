import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_playground/data/models/movie.dart';
import 'package:flutter_playground/data/models/tv_show.dart';
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
  Future<List<Movie>> _movies(String path) async {
    final list = await _getList(path);
    return list.map(Movie.fromJson).toList();
  }

  Future<List<Movie>> getTrendingMovies() => _movies('/trending/movie/day');
  Future<List<Movie>> getTopRatedMovies() => _movies('/movie/top_rated');
  Future<List<Movie>> getUpcomingMovies() => _movies('/movie/upcoming');
  Future<List<Movie>> getNowPlayingMovies() => _movies('/movie/now_playing');

  Future<Movie> getMovieDetail(int id) async => Movie.fromJson(await _get('/movie/$id'));

  // ---------- TV Shows ----------
  Future<List<TvShow>> _tvShows(String path) async {
    final list = await _getList(path);
    return list.map(TvShow.fromJson).toList();
  }

  Future<List<TvShow>> getPopularTvShows() => _tvShows('/tv/popular');
  Future<List<TvShow>> getTopRatedTvShows() => _tvShows('/tv/top_rated');

  Future<TvShow> getTvDetail(int id) async =>
      TvShow.fromJson(await _get('/tv/$id'));

  // ---------- Search ----------
  Future<List<Map<String, dynamic>>> searchMulti(String query) =>
      _getList('/search/multi', {'query': query});

  void dispose() => _client.close();
}
