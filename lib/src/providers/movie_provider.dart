import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/data/models/movie.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';

// StateProvider untuk menyimpan page saat ini
final currentPageProvider = StateProvider<int>((ref) => 1);

// Provider untuk instance TMDb API service
final tmdbApiServiceProvider = Provider((ref) => TmdbApiService());

// FutureProvider untuk fetch data berdasarkan halaman
final pagedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final api = ref.watch(tmdbApiServiceProvider);
  final page = ref.watch(currentPageProvider);
  return await api.getPopularMovies(page: page);
});
