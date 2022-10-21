import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Utils/kf_networking.dart';
import 'package:nb_utils/nb_utils.dart' hide log;

import '../Commons/kf_functions.dart';

class KFProvider with ChangeNotifier {
  /// Here is a boolean value indicating when the app is loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// change loading state for the app
  void load() {
    _isLoading = true;
    notifyListeners();
  }

  /// A method to update the category in the home fragment
  int _selectedHomeCategory = 0;
  int get selectedHomeCategory => _selectedHomeCategory;

  void updateHomeCategory(index) {
    _selectedHomeCategory = index;
    notifyListeners();
  }

  bool _contentLoadError = false;
  bool get contentLoadError => _contentLoadError;

  Future<void> setError(error) async {
    await 500.milliseconds.delay;
    _contentLoadError = error;
    notifyListeners();
  }

  /// Future method that will fetch and
  /// stracture popular movies data, get their names in a List and
  /// then search them from the TMDB to get IDs
  /// We will then use this IDs to get the image backdrop
  /// of the particular  movie or tv show
  Future<void> stracturePopularMoviesAndSeriesData() async {
    final movies = await fetchMoviesAndSeries(kfPopularMoviesUrl);
    final series = await fetchMoviesAndSeries(kfPopularSeriesUrl);

    if ('' == movies || '' == series) setError(true);

    await _getPopularData(movies, type: 'movie');
    await _getPopularData(series, type: 'tv');
  }

  Future<void> _getPopularData(String data, {required String type}) async {
    final document = parse(data);
    var dataCohot = document.getElementsByClassName('dflex')[1].children;

    for (var i = 0; i < 10; i++) {
      final query = dataCohot[i].getElementsByClassName('mtl')[0].innerHtml;
      final year = dataCohot[i].getElementsByClassName('hd hdy')[0].innerHtml;
      final homeUrl = dataCohot[i]
          .getElementsByTagName('a')[0]
          .attributes['href']
          .toString();

      if (query == '' || year == '' || homeUrl == '') setError(true);

      final element = await fetchTheIDAndBackdropFromTMDB(
          query: query, year: year, type: type);

      if (element["id"] == null) {
        setError(true);
        return;
      }

      final movie = KFMovieModel(
          id: type == "movie" ? kfPopularMoviesIDs[i] : kfPopularSeriesIDs[i],
          genreGeneratedMovieData: '',
          tmdbID: element["id"] ?? 'null',
          year: year,
          backdropsPath: element["backdrop_path"],
          posterPath: element["poster_path"],
          overview: element["overview"],
          title: query,
          releaseDate: element["release_date"],
          homeUrl: homeUrl);

      final dbValue = await KFMovieDatabase.instance.readMovie(
          type == "movie" ? kfPopularMoviesIDs[i] : kfPopularSeriesIDs[i]);

      dbValue == null
          ? await KFMovieDatabase.instance.create(movie)
          : await KFMovieDatabase.instance.update(movie);
    }
  }
}
