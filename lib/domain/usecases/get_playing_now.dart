import 'package:dartz/dartz.dart';

import 'package:kenyaflix/domain/entities/app_error.dart';
import 'package:kenyaflix/domain/entities/movie_entity.dart';
import 'package:kenyaflix/domain/entities/no_params.dart';
import 'package:kenyaflix/domain/repositories/movie_repository.dart';
import 'package:kenyaflix/domain/usecases/usecase.dart';

class GetPlayingNow extends Usecase<List<MovieEntity>, NoParams> {
  GetPlayingNow(MoviesRepository movieRepository) : super(movieRepository);

  Future<Either<AppError, List<MovieEntity>>> call(NoParams noParams) async {
    return await movieRepository.getPlayingNow();
  }
}
