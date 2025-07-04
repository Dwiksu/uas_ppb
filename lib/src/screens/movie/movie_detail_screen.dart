import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';
import 'package:uas_ril/src/data/models/movie.dart';
import 'package:uas_ril/src/providers/movie_detail_provider.dart';
import 'package:uas_ril/src/providers/watchlist_provider.dart';
import 'package:uas_ril/src/providers/actor_provider.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      body: movieDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat detail: $err')),
        data: (movie) {
          return CustomScrollView(
            slivers: [
              // AppBar yang bisa collapse
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movie.title,
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  background: CachedNetworkImage(
                    imageUrl: TmdbApiService.getPosterUrl(movie.backdropPath),
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) => Container(color: Colors.grey),
                  ),
                ),
                // ==== TAMBAHKAN TOMBOL WATCHLIST DI SINI ====
                actions: [
                  Consumer(
                    builder: (context, ref, child) {
                      final watchlistAsync = ref.watch(watchlistProvider);
                      final isInWatchlist =
                          watchlistAsync.asData?.value.contains(movie.id) ??
                          false;
                      final watchlistNotifier = ref.read(
                        watchlistProvider.notifier,
                      );

                      // Tampilkan ikon yang sesuai
                      return IconButton(
                        icon: Icon(
                          isInWatchlist
                              ? Icons.bookmark_added
                              : Icons.bookmark_add_outlined,
                          size: 28,
                        ),
                        onPressed: () {
                          if (isInWatchlist) {
                            watchlistNotifier.removeMovie(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dihapus dari watchlist'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            watchlistNotifier.addMovie(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ditambahkan ke watchlist'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              // Konten detail di bawah AppBar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating dan Tanggal Rilis
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.voteAverage.toStringAsFixed(1)} / 10',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            movie.releaseDate,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Sinopsis
                      Text(
                        'Sinopsis',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Pemeran Utama',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildCastList(movieId), // Panggil widget baru
                      const SizedBox(height: 24),
                      // Carousel untuk Rekomendasi
                      _buildMovieCarousel(
                        context: context,
                        title: 'Rekomendasi Untuk Anda',
                        provider: recommendedMoviesProvider(movieId),
                      ),
                      const SizedBox(height: 24),
                      // Carousel untuk Film Serupa
                      _buildMovieCarousel(
                        context: context,
                        title: 'Film Serupa',
                        provider: similarMoviesProvider(movieId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildCastList(int movieId) {
  return Consumer(
    builder: (context, ref, child) {
      final creditsAsync = ref.watch(movieCreditsProvider(movieId));
      return creditsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Text('Gagal memuat daftar pemeran'),
        data: (cast) {
          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length > 10 ? 10 : cast.length, // Batasi 10 orang
              itemBuilder: (context, index) {
                final member = cast[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/home/actor/${member.id}');
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: TmdbApiService.getPosterUrl(
                              member.profilePath,
                            ),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorWidget:
                                (context, u, e) => Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey,
                                  child: const Icon(Icons.person),
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          member.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}

// ==== WIDGET UNTUK MEMBUAT CAROUSEL FILM ====
Widget _buildMovieCarousel({
  required BuildContext context,
  required String title,
  required FutureProvider<List<Movie>> provider,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Consumer(
        builder: (context, ref, child) {
          final moviesAsync = ref.watch(provider);
          return moviesAsync.when(
            loading:
                () => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
            error: (e, s) => const Text('Gagal memuat film'),
            data: (movies) {
              if (movies.isEmpty) {
                return const SizedBox(
                  height: 50,
                  child: Center(child: Text('Tidak ada data.')),
                );
              }
              return SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () => context.push('/home/movie/${movie.id}'),
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: TmdbApiService.getPosterUrl(
                                    movie.posterPath,
                                  ),
                                  fit: BoxFit.cover,
                                  errorWidget:
                                      (context, url, error) => Container(
                                        color: Colors.grey.shade300,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    ],
  );
}
