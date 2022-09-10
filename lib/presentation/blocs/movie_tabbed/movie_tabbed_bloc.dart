import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:kenyaflix/domain/entities/app_error.dart';
import 'package:kenyaflix/domain/entities/movie_entity.dart';
import 'package:kenyaflix/domain/entities/no_params.dart';
import 'package:kenyaflix/domain/usecases/get_coming_soon.dart';
import 'package:kenyaflix/domain/usecases/get_playing_now.dart';
import 'package:kenyaflix/domain/usecases/get_popular.dart';

part './movie_tabbed_event.dart';
part './movie_tabbed_state.dart';

class MovieTabbedBloc extends Bloc<MovieTabbedEvent, MovieTabbedState> {
  final GetPopular getPopular;
  final GetPlayingNow getPlayinNow;
  final GetComingSoon getComingSoon;

  MovieTabbedBloc({
    required this.getPopular,
    required this.getPlayinNow,
    required this.getComingSoon,
  }) : super(MovieTabbedInitial(0));

  Stream<MovieTabbedState> mapEventToState(
    MovieTabbedEvent event,
  ) async* {
    if (event is MovieTabbedChangeEvent) {
      final eitherMovies = await _getEitherMovies(event.currentIndex);
      yield eitherMovies.fold(
        (appError) => MovieTabbedLoadError(appError.appErrorType),
        (movies) => MovieTabbedChanged(
          movies: movies,
          currentIndex: event.currentIndex,
        ),
      );
    }
  }

  Future<Either<AppError, List<MovieEntity>>> _getEitherMovies(
    int tabIndex,
  ) async {
    switch (tabIndex) {
      case 0:
        return await getPopular(NoParams());
      case 1:
        return await getPlayinNow(NoParams());
      case 2:
        return await getComingSoon(NoParams());
      default:
        throw UnimplementedError('movie tab $tabIndex is not implemented');
    }
  }
}
