// lib/src/providers/watchlist_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/data/local/db_helper.dart';
import 'package:uas_ril/src/data/models/movie.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
import 'package:uas_ril/src/providers/movie_detail_provider.dart';

class WatchlistNotifier extends StateNotifier<AsyncValue<List<int>>> {
  final Ref _ref;
  WatchlistNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = const AsyncValue.data(
        [],
      ); // Jika tidak ada user, watchlist kosong
      return;
    }
    try {
      state = const AsyncValue.loading();
      final watchlistIds = await DbHelper.getWatchlist(user.id!);
      state = AsyncValue.data(watchlistIds);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addMovie(int movieId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final currentWatchlist = state.valueOrNull ?? [];
    if (!currentWatchlist.contains(movieId)) {
      state = AsyncValue.data([...currentWatchlist, movieId]);
      await DbHelper.addMovieToWatchlist(user.id!, movieId);
    }
  }

  Future<void> removeMovie(int movieId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final currentWatchlist = state.valueOrNull ?? [];
    state = AsyncValue.data(
      currentWatchlist.where((id) => id != movieId).toList(),
    );
    await DbHelper.removeMovieFromWatchlist(user.id!, movieId);
  }
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, AsyncValue<List<int>>>((ref) {
      // Provider ini akan otomatis re-build saat user login/logout
      ref.watch(currentUserProvider);
      return WatchlistNotifier(ref);
    });

final fullWatchlistProvider = FutureProvider<List<Movie>>((ref) async {
  final watchlistIdsValue = ref.watch(watchlistProvider);

  // Tunggu sampai ID watchlist selesai dimuat
  return watchlistIdsValue.when(
    data: (ids) async {
      if (ids.isEmpty) return [];
      final movieFutures =
          ids.map((id) => ref.watch(movieDetailProvider(id).future)).toList();
      return await Future.wait(movieFutures);
    },
    loading: () => [], // Saat loading, tampilkan list kosong
    error: (e, s) => throw e, // Jika error, lempar error
  );
});
