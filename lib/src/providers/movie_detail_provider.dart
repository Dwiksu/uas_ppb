import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/data/models/movie.dart';
import 'package:uas_ril/src/providers/search_provider.dart'; // Menggunakan provider api yang sudah ada

// Provider untuk mendapatkan detail film berdasarkan ID-nya
final movieDetailProvider = FutureProvider.family<Movie, int>((
  ref,
  movieId,
) async {
  // Ambil instance API service
  final apiService = ref.watch(tmdbApiServiceProvider);
  // Panggil method untuk mendapatkan detail
  return await apiService.getMovieDetails(movieId);
});

final recommendedMoviesProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  movieId,
) async {
  final apiService = ref.watch(tmdbApiServiceProvider);
  return await apiService.getRecommendedMovies(movieId);
});

// Provider untuk mendapatkan film yang serupa
final similarMoviesProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  movieId,
) async {
  final apiService = ref.watch(tmdbApiServiceProvider);
  return await apiService.getSimilarMovies(movieId);
});
