// Future<String> _fetchMovies(String url, int id) async {
//   final data = await fetchMoviesAndSeries(url);
//   if (data != '') {
//     final moviesData = KFMovieModel(genreGeneratedMovieData: data, id: id);
//     await KFMovieDatabase.instance.create(moviesData);
//     return data;
//   } else {
//     final dbValue = await KFMovieDatabase.instance.readMovie(id);
//     final genreValue = dbValue?.genreGeneratedMovieData ?? '';
//     if (genreValue != '') {
//       return genreValue;
//     } else {
//       if (mounted) context.read<KFProvider>().setError(true);
//       throw 'Something went wrong';
//     }
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Utils/kf_networking.dart';
import 'package:nb_utils/nb_utils.dart';

List<Map<String, String>> stractureData(String data) {
  final List<Map<String, String>> urls = [];

  final document = parse(data);
  final alldata = document.getElementsByClassName('dflex')[1].children;
  for (int i = 0; i < 10; i++) {
    final homeUrl = alldata[i].getElementsByTagName('a')[0].attributes['href'];
    final imageUrl =
        alldata[i].getElementsByTagName('img')[0].attributes['data-src'];
    final map = {"imageUrl": imageUrl ?? '', "homeUrl": homeUrl ?? ''};
    urls.insert(i, map);
  }

  return urls;
}

Widget loadingWidget() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        genreTitlePlaceHolder(),
        6.height,
        HorizontalList(
            itemCount: 10,
            itemBuilder: (context, index) {
              return imagePlaceHolder();
            }),
      ],
    ).paddingSymmetric(vertical: 5, horizontal: 8);

Widget horrizontalImageListBuilder({required List<Map<String, String>> urls}) =>
    HorizontalList(
        itemCount: 10,
        itemBuilder: (context, index) {
          final imageUrl = urls[index]['imageUrl'];
          final homeUrl = urls[index]['homeUrl'];
          final urlImage = 'https:$imageUrl';
          return GestureDetector(
              onTap: () => log("$homeUrl"),
              child: buildImageContainer(urlImage, index));
        });

Widget genreTitleWidget(String genre, {required bool isMovie}) => Row(
      children: [
        RichText(
            text: TextSpan(
                text: 'Rock Flix - ',
                children: <TextSpan>[
                  TextSpan(
                      text: "$genre ${isMovie ? 'Movies' : 'Series'} ",
                      style: boldTextStyle(color: Colors.white))
                ],
                style: boldTextStyle(color: Colors.blue))),
        4.width,
        const Icon(Icons.chevron_right)
      ],
    );
Widget genreTitlePlaceHolder() => const FadeShimmer(
      height: 25,
      width: 100,
      fadeTheme: FadeTheme.dark,
    );
Widget buildImageContainer(String urlImage, int index) {
  log(urlImage);
  return CachedNetworkImage(
    key: UniqueKey(),
    imageUrl: urlImage,
    height: 150,
    placeholder: (context, url) => imagePlaceHolder(),
    errorWidget: (context, url, error) => imagePlaceHolder(),
  );
}

Widget imagePlaceHolder() => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: FadeShimmer(
        width: 100,
        height: 150,
        fadeTheme: FadeTheme.dark,
      ),
    );

Stream<String> fetchData(int id) async* {
  final data = await KFMovieDatabase.instance.readMovie(id);
  yield data?.genreGeneratedMovieData ?? '';
}

Future<void> fetchDataAndStoreData(KFProvider provider) async {
  final moviesAndSeriesUrls = [...movies, ...series];
  for (int i = 0; i < moviesAndSeriesUrls.length; i++) {
    final data = await fetchMoviesAndSeries(moviesAndSeriesUrls[i]['url']);
    if (data == '') {
      Future.delayed(Duration.zero, () => provider.setError(true));
    } else {
      final moviesData = KFMovieModel(
          genreGeneratedMovieData: data, id: moviesAndSeriesUrls[i]['id']);
      await KFMovieDatabase.instance.create(moviesData);
    }
  }
}
