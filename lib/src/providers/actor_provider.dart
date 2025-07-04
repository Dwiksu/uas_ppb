import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/data/models/actor.dart';
import 'package:uas_ril/src/data/models/cast.dart';
import 'package:uas_ril/src/data/models/movie.dart';
import 'package:uas_ril/src/providers/search_provider.dart';

// Provider untuk mengambil daftar pemeran sebuah film
final movieCreditsProvider = FutureProvider.family<List<Cast>, int>((ref, movieId) async {
  final apiService = ref.watch(tmdbApiServiceProvider);
  return await apiService.getMovieCredits(movieId);
});

// Provider untuk mengambil detail seorang aktor
final actorDetailProvider = FutureProvider.family<Actor, int>((ref, personId) async {
  final apiService = ref.watch(tmdbApiServiceProvider);
  return await apiService.getActorDetails(personId);
});

// Provider untuk mengambil filmografi seorang aktor
final actorMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, personId) async {
  final apiService = ref.watch(tmdbApiServiceProvider);
  return await apiService.getActorMovieCredits(personId);
});