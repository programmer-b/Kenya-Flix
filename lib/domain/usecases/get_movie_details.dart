import 'package:dartz/dartz.dart';

import 'package:kenyaflix/data/models/movie_details.dart';
import 'package:kenyaflix/domain/entities/app_error.dart';
import 'package:kenyaflix/domain/entities/movie_params.dart';
import 'package:kenyaflix/domain/repositories/movie_repository.dart';
import 'package:kenyaflix/domain/usecases/usecase.dart';

class GetMovieDetails extends Usecase<MovieDetailsModel, MovieParams> {
  GetMovieDetails(MoviesRepository movieRepository) : super(movieRepository);

  @override
  Future<Either<AppError, MovieDetailsModel>> call(MovieParams params) {
    return movieRepository.getMovieDetails(params.id);
  }
}
