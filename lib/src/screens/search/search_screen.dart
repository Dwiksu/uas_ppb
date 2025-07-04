import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ril/src/providers/search_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchNotifierProvider);
    final searchNotifier = ref.read(searchNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Film')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                searchNotifier.searchMovies(query);
              },
              decoration: InputDecoration(
                hintText: 'Ketik judul film...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
          ),
          // Hasil Pencarian
          Expanded(child: _buildSearchResults(searchState)),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    if (state is SearchInitial) {
      return const Center(child: Text('Mulai ketik untuk mencari film.'));
    }
    if (state is SearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is SearchError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    if (state is SearchLoaded) {
      if (state.movies.isEmpty) {
        return const Center(child: Text('Film tidak ditemukan.'));
      }
      return ListView.builder(
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return ListTile(
            onTap: () {
              // Gunakan push untuk navigasi ke detail
              context.push('/home/movie/${movie.id}');
            },
            leading: SizedBox(
              width: 50,
              height: 75,
              child: CachedNetworkImage(
                imageUrl: TmdbApiService.getPosterUrl(movie.posterPath),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            title: Text(movie.title),
            subtitle: Text(
              movie.releaseDate.isNotEmpty
                  ? 'Tahun: ${movie.releaseDate.substring(0, 4)}'
                  : 'Tahun tidak diketahui',
            ),
          );
        },
      );
    }
    return Container();
  }
}
