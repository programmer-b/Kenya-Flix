import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_error_screen_component.dart';
import 'package:kenyaflix/Components/kf_movie_detail_component.dart';
import 'package:kenyaflix/Components/kf_sliver_app_bar_component.dart';
import 'package:kenyaflix/Database/kf_movie_database.dart';
import 'package:kenyaflix/Models/kf_movie_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:provider/provider.dart';

import '../Utils/kf_networking.dart';

class KFMovieDetailScreen extends StatefulWidget {
  const KFMovieDetailScreen(
      {Key? key,
      required this.homeUrl,
      required this.type,
      this.year,
      required this.query})
      : super(key: key);
  final String homeUrl;
  final String query;
  final String type;
  final String? year;

  @override
  State<KFMovieDetailScreen> createState() => _KFMovieDetailScreenState();
}

class _KFMovieDetailScreenState extends State<KFMovieDetailScreen> {
  late ScrollController? controller;
  late final String url;

  int get id => kfmovieDetailSecondaryID;
  String get baseUrl => kfMoviesDetailBaseUrl;

  Future<void> _downloadAndStoreMovieDatailsOnID() async {
    log('HOME URL: $url');
    await KFMovieDatabase.instance.delete(id);
    final data =
        await fetchMoviesAndSeries(url.startsWith('/') ? '$baseUrl$url' : url);
    log(url.startsWith('/') ? '$baseUrl$url' : url);
    if (data != '') {
      final details = KFMovieModel(
          id: id,
          genreGeneratedMovieData: data,
          tmdbID: 0,
          year: "null",
          backdropsPath: "null",
          posterPath: "null",
          releaseDate: "null",
          overview: "null",
          title: "null",
          homeUrl: "null");
      await KFMovieDatabase.instance.create(details);
    } else {
      if (mounted) context.read<KFProvider>().setError(true);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    controller = ScrollController();
    url = widget.homeUrl;
    await _downloadAndStoreMovieDatailsOnID();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          body: Consumer<KFProvider>(
            builder: (context, provider, child) {
              return provider.contentLoadError
                  ? const KFErrorScreenComponent()
                  : CustomScrollView(
                      controller: controller,
                      slivers: <Widget>[
                        _appBar(),
                        const KFMovieDetailComponent()
                      ],
                    );
            },
          ),
        ));
  }

  Widget _appBar() => const KFSliverAppBarComponent(
        pinned: true,
        snap: false,
        floating: true,
        expandedHeight: 90,
        automaticallyImplyLeading: true,
      );
}
