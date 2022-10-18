import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Utils/kf_networking.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:http/http.dart' as http;

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

      final element = await _fetchTheIDAndBackdropFromTMDB(
          query: query, year: year, type: type);

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
        homeUrl: homeUrl
      );

      await KFMovieDatabase.instance.create(movie);
    }
  }

  Future<Map<String, dynamic>> _fetchTheIDAndBackdropFromTMDB(
      {required String query,
      required String year,
      required String type}) async {
    final uri = Uri.parse(
        kfTMDBSearchMoviesORSeriesUrl(type: type, year: year, query: query));
    try {
      final data = await http.get(uri);
      if (data.statusCode == 200) {
        final rootObject = jsonDecode(data.body)["results"][0];

        var id = rootObject["id"];
        var backDropPath = rootObject["backdrop_path"].toString();
        var posterPath = rootObject["poster_path"].toString();
        var overview = rootObject["overview"].toString();
        var releaseDate = rootObject["first_air_date"].toString();

        return {
          "id": id,
          "backdrop_path": backDropPath,
          "type": type,
          "poster_path": posterPath,
          "overview": overview,
          "release_date": releaseDate,
        };
      } else {
        log("FAILED BECAUSE, TRIED TO SEARCH $uri AND GOT ${data.body}");
        setError(true);
        throw ("Search Error occured");
      }
    } catch (e) {
      setError(true);
      rethrow;
    }
  }
}
