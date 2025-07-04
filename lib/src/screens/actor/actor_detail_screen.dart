import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ril/src/api/tmdb_api_service.dart';
import 'package:uas_ril/src/providers/actor_provider.dart';

class ActorDetailScreen extends ConsumerWidget {
  final int personId;
  const ActorDetailScreen({super.key, required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorDetailAsync = ref.watch(actorDetailProvider(personId));
    final actorMoviesAsync = ref.watch(actorMoviesProvider(personId));

    return Scaffold(
      appBar: AppBar(
        title: actorDetailAsync.when(
          data: (actor) => Text(actor.name),
          loading: () => const Text('Loading...'),
          error: (e,s) => const Text('Error'),
        ),
      ),
      body: SingleChildScrollView(
        child: actorDetailAsync.when(
          loading: () => const Center(heightFactor: 10, child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Gagal memuat detail aktor: $err')),
          data: (actor) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: TmdbApiService.getPosterUrl(actor.profilePath),
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(width: 120, height: 180, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (actor.birthday != null) Text('Lahir: ${actor.birthday}'),
                            if (actor.placeOfBirth != null) Text('Tempat Lahir: ${actor.placeOfBirth}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (actor.biography != null && actor.biography!.isNotEmpty) ...[
                    Text('Biografi', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(actor.biography!),
                    const SizedBox(height: 24),
                  ],

                  Text('Dikenal Lewat Film', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),

                  actorMoviesAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const Text('Gagal memuat filmografi'),
                    data: (movies) {
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
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: TmdbApiService.getPosterUrl(movie.posterPath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(movie.title, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}