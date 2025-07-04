import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';
import 'package:uas_ril/src/data/models/movie.dart';

// State untuk search: bisa initial, loading, data, atau error
abstract class SearchState {}
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<Movie> movies;
  SearchLoaded(this.movies);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// StateNotifier untuk mengelola logika pencarian
class SearchNotifier extends StateNotifier<SearchState> {
  final TmdbApiService _apiService;
  Timer? _debounce;

  SearchNotifier(this._apiService) : super(SearchInitial());

  // Fungsi untuk menjalankan pencarian dengan debounce
  void searchMovies(String query) {
    // Jika ada debounce yang aktif, batalkan
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Jika query kosong, kembali ke state awal
    if (query.isEmpty) {
      state = SearchInitial();
      return;
    }

    // Set debounce baru
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      state = SearchLoading();
      try {
        final movies = await _apiService.searchMovies(query);
        state = SearchLoaded(movies);
      } catch (e) {
        state = SearchError(e.toString());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// Provider untuk API service (jika belum ada, tambahkan)
final tmdbApiServiceProvider = Provider((ref) => TmdbApiService());

// Provider untuk SearchNotifier
final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final api = ref.watch(tmdbApiServiceProvider);
  return SearchNotifier(api);
});