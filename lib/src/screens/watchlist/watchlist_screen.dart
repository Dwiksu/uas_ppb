import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';
import 'package:uas_ril/src/providers/watchlist_provider.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau provider yang berisi data lengkap film di watchlist
    final watchlistAsync = ref.watch(fullWatchlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: watchlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(child: Text('Gagal memuat watchlist: $err')),
        data: (movies) {
          // Jika watchlist kosong, tampilkan pesan
          if (movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_remove_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Watchlist Anda kosong',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Jika ada, tampilkan dalam bentuk daftar
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: TmdbApiService.getPosterUrl(movie.posterPath),
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                title: Text(
                  movie.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Rilis: ${movie.releaseDate}'),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_remove, color: Colors.red),
                  onPressed: () {
                    ref.read(watchlistProvider.notifier).removeMovie(movie.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${movie.title} dihapus')),
                    );
                  },
                ),
                onTap: () {
                  // Navigasi ke halaman detail jika di-tap
                  context.push('/home/movie/${movie.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
