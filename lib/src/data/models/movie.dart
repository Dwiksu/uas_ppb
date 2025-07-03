class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath; // Bisa null
  final String? backdropPath; // Bisa null
  final double voteAverage;
  final String releaseDate; // Akan kita parse jadi String saja dari API
  final List<int> genreIds; // List ID genre

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  // Factory constructor untuk membuat objek Movie dari JSON Map
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath:
          json['poster_path'] as String?, // Gunakan 'as String?' untuk nullable
      backdropPath:
          json['backdrop_path']
              as String?, // Gunakan 'as String?' untuk nullable
      voteAverage:
          (json['vote_average'] as num)
              .toDouble(), // TMDb bisa kirim int/double, konversi ke double
      releaseDate: json['release_date'] as String,
      genreIds: List<int>.from(
        json['genre_ids'] ?? [],
      ), // Pastikan ini list of int
    );
  }

  // Method to convert Movie object to JSON Map (berguna jika ingin disimpan ke lokal nanti)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
    };
  }
}

