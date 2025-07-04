import 'dart:convert'; // Untuk mengelola JSON
import 'package:http/http.dart' as http; // Untuk HTTP requests
import 'package:uas_ril/src/data/models/actor.dart';
import 'package:uas_ril/src/data/models/cast.dart';
import '../data/models/movie.dart'; // Import model Movie yang akan kita buat nanti

// Pastikan untuk mengganti ini dengan API Key TMDb kamu yang sebenarnya!
// Disarankan untuk tidak menyimpan API Key langsung di kode (misalnya, gunakan .env),
// tetapi untuk proyek cepat dan demo, ini bisa diterima.
const String _kApiKey = 'b34fa64819301d2a927d49e20b4c0b68';
const String _kBaseUrl = 'https://api.themoviedb.org/3';

class TmdbApiService {
  // Method untuk mendapatkan daftar film populer
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final url = Uri.parse(
      '$_kBaseUrl/movie/popular?api_key=$_kApiKey&page=$page',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load popular movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Method untuk mencari film berdasarkan query
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return []; // Jika query kosong, kembalikan list kosong
    }
    final url = Uri.parse(
      '$_kBaseUrl/search/movie?api_key=$_kApiKey&query=$query',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Method untuk mendapatkan detail film berdasarkan ID
  Future<Movie> getMovieDetails(int movieId) async {
    final url = Uri.parse('$_kBaseUrl/movie/$movieId?api_key=$_kApiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Movie.fromJson(data); // Langsung dari JSON root
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Utility method untuk mendapatkan URL gambar poster
  static String getPosterUrl(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return 'https://via.placeholder.com/150x225?text=No+Image'; // Placeholder jika tidak ada gambar
    }
    // Ukuran w500 adalah ukuran yang umum digunakan untuk poster
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  // Method untuk mendapatkan daftar pemeran dari sebuah film
  Future<List<Cast>> getMovieCredits(int movieId) async {
    final url = Uri.parse(
      '$_kBaseUrl/movie/$movieId/credits?api_key=$_kApiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['cast'];
        return results.map((json) => Cast.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movie credits');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Method untuk mendapatkan detail seorang aktor
  Future<Actor> getActorDetails(int personId) async {
    final url = Uri.parse('$_kBaseUrl/person/$personId?api_key=$_kApiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Actor.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load actor details');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Method untuk mendapatkan daftar film dari seorang aktor (filmografi)
  Future<List<Movie>> getActorMovieCredits(int personId) async {
    final url = Uri.parse(
      '$_kBaseUrl/person/$personId/movie_credits?api_key=$_kApiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['cast'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load actor movie credits');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Method untuk mendapatkan film yang direkomendasikan
  Future<List<Movie>> getRecommendedMovies(int movieId) async {
    final url = Uri.parse(
      '$_kBaseUrl/movie/$movieId/recommendations?api_key=$_kApiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommended movies');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }

  // Method untuk mendapatkan film yang serupa
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final url = Uri.parse(
      '$_kBaseUrl/movie/$movieId/similar?api_key=$_kApiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (e) {
      throw Exception('Failed to connect to TMDb API: $e');
    }
  }
}
