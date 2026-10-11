class ApiConstants {
  ApiConstants._();

  static const host = 'api.themoviedb.org';
  static const basePath = '/3';
  static const imageBaseUrl = 'https://image.tmdb.org/t/p';

  static String poster(String? path, {String size = 'w500'}) =>
      path == null ? '' : '$imageBaseUrl/$size$path';

  static String backdrop(String? path, {String size = 'w780'}) =>
      path == null ? '' : '$imageBaseUrl/$size$path';
}
