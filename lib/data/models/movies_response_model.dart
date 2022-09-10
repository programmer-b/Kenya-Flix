import 'package:kenyaflix/data/models/movie_model.dart';

class MoviesResponseModel {
  late List<MovieModel> movies;

  MoviesResponseModel.fromJson(Map<String, dynamic> decodedJson) {
    if (decodedJson['results'] != null) {
      movies = <MovieModel>[];
      decodedJson['results'].forEach((result) {
        movies.add(MovieModel.fromJson(result));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['results'] = this.movies.map((result) => result.toJson()).toList();
    return data;
  }
}
