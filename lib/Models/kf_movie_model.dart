class KFMovieModel {
  final int? id;

  final String genreGeneratedMovieData;

  const KFMovieModel({
    this.id,
    required this.genreGeneratedMovieData,
  });

  KFMovieModel copy({
    int? id,
    String? imageLink,
    String? homeLink,
    DateTime? createdTime,
    String? genreGeneratedMovieData,
  }) =>
      KFMovieModel(
          id: id ?? this.id,
          genreGeneratedMovieData:
              genreGeneratedMovieData ?? this.genreGeneratedMovieData);

  static KFMovieModel fromJson(Map<String, Object?> json) => KFMovieModel(
        id: json[MovieFields.id] as int?,
        genreGeneratedMovieData:
            json[MovieFields.genreGeneratedMovieData] as String,
      );

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.genreGeneratedMovieData: genreGeneratedMovieData
      };
}

class MovieFields {
  static final List<String> values = [
    id,
    genreGeneratedMovieData,
  ];

  static const String id = '_id';

  static const String genreGeneratedMovieData = 'genreGeneratedMovieData';
}

const String tableMovies = 'movies';
