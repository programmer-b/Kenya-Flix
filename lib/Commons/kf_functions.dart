import 'package:html/parser.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Utils/kf_networking.dart';

List<Map<String, String>> stractureData(String data,
    {bool stractureAllData = false, bool trending = false}) {
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
    final map = {"imageUrl": imageUrl ?? '', "homeUrl": homeUrl ?? ''};
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
      await KFMovieDatabase.instance.create(moviesData);
    }
  }
}
