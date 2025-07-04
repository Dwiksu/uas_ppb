import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
import 'package:uas_ril/src/providers/movie_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsyncValue = ref.watch(pagedMoviesProvider);
    final currentPage = ref.watch(currentPageProvider);
    final authNotifier = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Populer'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fungsi pencarian belum ada.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authNotifier.logout();
            },
          ),
        ],
      ),
      // Body tidak lagi menggunakan Column, langsung SingleChildScrollView
      body: moviesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat film: $err')),
        data: (movies) {
          if (movies.isEmpty && currentPage > 1) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ini adalah halaman terakhir.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        () =>
                            ref.read(currentPageProvider.notifier).state =
                                currentPage - 1,
                    child: const Text('Kembali ke halaman sebelumnya'),
                  ),
                ],
              ),
            );
          }
          if (movies.isEmpty) {
            return const Center(child: Text('Tidak ada film yang ditemukan.'));
          }

          // Gunakan CustomScrollView untuk menggabungkan konten dan paginasi
          return SingleChildScrollView(
            // Padding bawah untuk memberi ruang dari tepi layar
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Column(
              children: [
                Wrap(
                  spacing: 12.0,
                  runSpacing: 16.0,
                  children:
                      movies.map((movie) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final itemWidth = (screenWidth - 12 * 3) / 2;
                        return SizedBox(
                          width: itemWidth,
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 2 / 3,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  child: CachedNetworkImage(
                                    imageUrl: TmdbApiService.getPosterUrl(
                                      movie.posterPath,
                                    ),
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) => const Center(
                                          child: Icon(
                                            Icons.movie_creation_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                movie.title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(
                  height: 32,
                ), // Jarak antara film terakhir dan paginasi
                // Panggil widget paginasi di sini, di dalam Column
                _buildPaginationControls(ref, currentPage),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget untuk kontrol paginasi yang lebih kecil dan rata kanan.
  Widget _buildPaginationControls(WidgetRef ref, int currentPage) {
    Widget pageButton(int pageNumber, bool isCurrentPage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ElevatedButton(
          onPressed:
              isCurrentPage
                  ? null
                  : () =>
                      ref.read(currentPageProvider.notifier).state = pageNumber,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(36, 36), // Ukuran tombol diperkecil
            padding: EdgeInsets.zero, // Padding di dalam tombol dihilangkan
            backgroundColor: isCurrentPage ? Colors.orange : Colors.grey[200],
            foregroundColor: isCurrentPage ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Sudut lebih kecil
            ),
          ),
          child: Text(
            '$pageNumber',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );
    }

    List<int> getPageList() {
      if (currentPage == 1) return [1, 2, 3];
      return [currentPage - 1, currentPage, currentPage + 1];
    }

    final pageList = getPageList();

    // Gunakan Align untuk membuat posisinya rata kanan
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Agar Row hanya memakan tempat seperlunya
        children: [
          ElevatedButton(
            onPressed:
                currentPage > 1
                    ? () =>
                        ref.read(currentPageProvider.notifier).state =
                            currentPage - 1
                    : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Icon(Icons.chevron_left, size: 20),
          ),
          ...pageList
              .map((number) => pageButton(number, number == currentPage))
              .toList(),
          ElevatedButton(
            onPressed:
                () =>
                    ref.read(currentPageProvider.notifier).state =
                        currentPage + 1,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Icon(Icons.chevron_right, size: 20),
          ),
        ],
      ),
    );
  }
}
