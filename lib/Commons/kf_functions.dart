import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Models/kf_tv_show_season_info_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Utils/kf_networking.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/kf_omdb_search_model.dart';
import '../Models/kf_search_tv_by_id_model.dart';
import '../Models/kf_tmdb_search_movie_by_id_model.dart';
import '../Models/kf_tmdb_search_credits_model.dart';
import '../Models/kf_tmdb_search_images_model.dart';
import '../Models/kf_tmdb_search_model.dart';
import '../Models/kf_tmdb_search_videos_model.dart';

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
      stractureAllData || trending
          ? i < alldata.length
          : i < kfGenreHorrizontalIMages;
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
    final dbValue =
        await KFMovieDatabase.instance.readMovie(moviesAndSeriesUrls[i]['id']);
    if (data == '') {
      if (dbValue == null) {
        log("setting error because both local database and fetched data for ${moviesAndSeriesUrls[i]['url']} is null");
        provider.setError(true);
      } else {
        continue;
      }
    }

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

    data == ''
        ? dbValue == null
            ? {
                log("Setting error because: Failed: ${moviesAndSeriesUrls[i]['url']}"),
                provider.setError(true)
              }
            : null
        : dbValue == null
            ? await KFMovieDatabase.instance.create(moviesData)
            : await KFMovieDatabase.instance.update(moviesData);
  }
}

Future<Map<String, dynamic>> fetchTheIDAndPosterFromTMDB(
    {required String query, String year = '', required String type}) async {
  try {
    Map<String, dynamic> dataMap = {"results": []};
    Response? data;

    num i = 0;

    while (dataMap["results"].isEmpty && i < 2) {
      final uri = Uri.parse(
          kfTMDBSearchMoviesORSeriesUrl(type: type, year: year, query: query));

      data = await http.get(uri);

      final List results = jsonDecode(data.body)["results"];
      if (results.isEmpty) {
        type == "movie" ? type = "tv" : type = "movie";
        i++;
      } else {
        dataMap["results"] = results;
      }
    }

    final rootObject = dataMap["results"][0];

    if (data?.statusCode == 200) {
      var id = rootObject["id"];
      String? backDropPath = rootObject["backdrop_path"];
      String? posterPath = rootObject["poster_path"];
      var overview = rootObject["overview"].toString();
      var releaseDate = rootObject["first_air_date"].toString();

      // /Precaching image so not to take too long at the home page

      final String imageUrl =
          "$kfOriginalTMDBImageUrl${backDropPath ?? posterPath}";
      String imageKey = basename(imageUrl);

      FileInfo? imageFile = await getImageFileFromCache(imageKey: imageKey);

      bool imageExists = imageFile != null;

      if (imageExists) {
      } else {
        DefaultCacheManager()
            .downloadFile(imageUrl, key: imageKey)
            .then((_) {});
      }

      return {
        "id": id ?? 0,
        "backdrop_path": backDropPath.toString(),
        "type": type.toString(),
        "poster_path": posterPath.toString(),
        "overview": overview,
        "release_date": releaseDate,
      };
    } else {
      log("failed to search for: $query because it got: $data");
      return {"id": null};
    }
  } catch (e) {
    log("failed to search for: $query because of $e");
    return {"id": null};
  }
}

Future<KFOMDBSearchModel?> fetchOMDBData(
    {required String query,
    required String? year,
    required String type}) async {
  final url =
      kfOMDBSearchMoviesOrSeriesUrl(query: query, year: year, type: type);
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    return KFOMDBSearchModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

Future<KFTMDBSearchMovieByIdModel?> fetchTMDBSearchMovieByIdData(
    {required String id, String type = 'movie'}) async {
  final url = kfTMDBSearchByIdUrl(type: type, id: id);
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    return KFTMDBSearchMovieByIdModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

Future<KFTMDBSearchTvByIdModel?> fetchTMDBSearchTvByIdData(
    {required String id, String type = 'tv'}) async {
  final url = kfTMDBSearchByIdUrl(type: type, id: id);
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    return KFTMDBSearchTvByIdModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

Future<KFTMDBSearchCreditsModel?> fetchTMDBCreditdata(
    {required String id, required String type}) async {
  final url = kfTMDBSearchCreditsUrl(type: type, id: id);
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    return KFTMDBSearchCreditsModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

Future<KFTMDBSearchImagesModel?> fetchTMDBImagesData(
    {required String id, required String type}) async {
  final url = kfTMDBSearchImagesUrl(id: id, type: type);
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    return KFTMDBSearchImagesModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

Future<KFTMDBSearchVideosModel?> fetchTMDBVideosData(
    {required String id, required String type}) async {
  final url = kfTMDBSearchVideosUrl(id: id, type: type);
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    return KFTMDBSearchVideosModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

Future<KFTMDBSearchModel?> fetchTMDBSearchData(
    {required String query,
    required String? year,
    required String type}) async {
  final url =
      kfTMDBSearchMoviesORSeriesUrl(type: type, year: year, query: query);
  log("SEARCHING FOR: $url");
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    final json = jsonDecode(data);
    if (json['results'].isNotEmpty) {
      final results = KFTMDBSearchModel.fromJson(json);
      return results;
    } else {
      return null;
    }
  } else {
    return null;
  }

  ///Download images from TMDB
  ///using below function
}

Future<KFTVShowSeasonInfoModel?> fetchTVSeasonEpisodesInfo(
    {required String id, required String currentSeason}) async {
  final url = kfGetEpisodesUrl(id: id, currentSeason: currentSeason);
  log("SEARCHING FOR EPISODES: $url");
  final data = await fetchMoviesAndSeries(url);
  if (data != '') {
    final json = jsonDecode(data);
    final results = KFTVShowSeasonInfoModel.fromJson(json);
    return results;
  } else {
    return null;
  }

  ///Download images from TMDB
  ///using below function
}

Future<String> localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File?> downloadImage({required String url}) async {
  log("DOWNLOADING $url");
  try {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFiles(url, bytes);
  } catch (exception) {
    return null;
  }
}

Future<File> _storeFiles(String url, List<int> bytes) async {
  final filename = basename(url);
  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file;
}

String imageFileName({required String url}) {
  String name = basename(url);
  return name;
}

Future<File> getLocalImage({required String url}) async {
  String filename = basename(url);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File f = File('$dir/$filename');
  return f;
}

Future<bool> directoryExists({required String url}) async {
  String name = basename(url);
  String path = await localPath();

  bool fileExists = await File("$path/$name").exists();
  bool exists = fileExists;
  return exists;
}

Map<String, double> getScreenContraints(context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return {"height": height, "width": width};
}

Future<Response> fetchDataFromInternet(String url) async {
  try {
    final res = await http.get(Uri.parse(url));
    return res;
  } catch (e) {
    rethrow;
  }
}

Future<FileInfo?> getImageFileFromCache({required String imageKey}) async {
  FileInfo? imageFile = await DefaultCacheManager().getFileFromCache(imageKey);
  return imageFile;
}

Future<String?> downloadFile(
    {required String url, required String fileName}) async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    final savedDir = await getCustomPath('movie');
    return await FlutterDownloader.enqueue(
        url: url, savedDir: savedDir, fileName: fileName);
  } else {
    return null;
  }
}

Future<String> getCustomPath(String type) async {
  Directory rootDir = (await getDownloadsDirectory())!;

  String rootPath = rootDir.path;
  String path = "$rootPath/$type";

  return (await generateDir(path)).path;
}

Future<Directory> generateDir(String path) async {
  if (await Directory(path).exists()) {
    return Directory(path);
  } else {
    final newDir = await Directory(path).create();
    return newDir;
  }
}
