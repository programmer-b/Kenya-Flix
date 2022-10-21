import 'dart:convert';

import 'package:html/parser.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Utils/kf_networking.dart';
import 'package:http/http.dart' as http;

List<Map<String, String>> stractureData(
  String data, {
  bool stractureAllData = false,
  bool trending = false,
}) {
  final List<Map<String, String>> urls = [];

  final document = parse(data);

  final alldata =
      document.getElementsByClassName('dflex')[trending ? 0 : 1].children;

  for (int i = 0;
      stractureAllData || trending ? i < alldata.length : i < 10;
      i++) {
    final homeUrl = alldata[i].getElementsByTagName('a')[0].attributes['href'];
    final imageUrl =
        alldata[i].getElementsByTagName('img')[0].attributes['data-src'];
    final query = alldata[i].getElementsByClassName('mtl')[0].innerHtml;
    
    final yearElement = alldata[i].getElementsByClassName('hd hdy');
    final yearExists = yearElement.isNotEmpty;
    final year = yearExists ? yearElement[0].innerHtml : "";

    final map = {
      "imageUrl": imageUrl ?? '',
      "homeUrl": homeUrl ?? '',
      "year": year,
      "query": query
    };
    urls.insert(i, map);
  }

  return urls;
}

Stream<String> fetchData(int id) async* {
  final data = await KFMovieDatabase.instance.readMovie(id);
  yield data?.genreGeneratedMovieData ?? '';
}

Stream<KFMovieModel> fetchAllData(int id) async* {
  final data = await KFMovieDatabase.instance.readMovie(id);
  yield data ??
      const KFMovieModel(
          genreGeneratedMovieData: "null",
          tmdbID: 0,
          year: "null",
          backdropsPath: "null",
          posterPath: "null",
          releaseDate: "null",
          overview: "null",
          title: "null",
          homeUrl: "null");
}

Future<void> fetchDataAndStoreData(KFProvider provider) async {
  final moviesAndSeriesUrls = [
    ...trendingNowMovies,
    ...trendingNowSeries,
    ...movies,
    ...series,
  ];
  for (int i = 0; i < moviesAndSeriesUrls.length; i++) {
    final data = await fetchMoviesAndSeries(moviesAndSeriesUrls[i]['url']);
    if (data == '') {
      Future.delayed(Duration.zero, () => provider.setError(true));
    } else {
      final moviesData = KFMovieModel(
          id: moviesAndSeriesUrls[i]['id'],
          genreGeneratedMovieData: data,
          tmdbID: 0,
          year: "null",
          backdropsPath: "null",
          posterPath: "null",
          releaseDate: "null",
          overview: "null",
          title: "null",
          homeUrl: "null");

      final dbValue = await KFMovieDatabase.instance
          .readMovie(moviesAndSeriesUrls[i]['id']);

      dbValue == null
          ? await KFMovieDatabase.instance.create(moviesData)
          : await KFMovieDatabase.instance.update(moviesData);
    }
  }
}

Future<Map<String, dynamic>> fetchTheIDAndBackdropFromTMDB(
    {required String query, String year = '', required String type}) async {
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
      return {"id": null};
    }
  } catch (e) {
    return {"id": null};
  }
}
