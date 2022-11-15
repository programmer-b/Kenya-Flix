import 'dart:developer';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Commons/kf_extensions.dart';
import 'package:kenyaflix/Commons/kf_functions.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Commons/kf_themes.dart';
import 'package:kenyaflix/Components/kf_web_component.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class KFVideoLoadingComponent extends StatefulWidget {
  KFVideoLoadingComponent(
      {required this.homeUrl,
      required this.isMovie,
      this.currentSeason,
      this.episodeIndex,
      this.numberOfSeasons})
      : super(key: UniqueKey());
  final String homeUrl;
  final bool isMovie;
  final String? currentSeason;
  final int? episodeIndex;
  final int? numberOfSeasons;

  @override
  State<KFVideoLoadingComponent> createState() =>
      _KFVideoLoadingComponentState();
}

class _KFVideoLoadingComponentState extends State<KFVideoLoadingComponent> {
  // late AnimationController controller;

  String get homeUrl => widget.homeUrl;
  bool get isMovie => widget.isMovie;
  String? get currentSeason => widget.currentSeason;
  int? get episodeIndex => widget.episodeIndex;

  Future<String> _fetchEpisodeUrl() async {
    log("HOME URL START: $homeUrl");
    final startPage = (await fetchDataFromInternet(homeUrl)).body;

    final startDoc = startPage.document;
    // int numberOfSeasons = 2;
    // if (mounted) {
    //   numberOfSeasons = context
    //           .read<KFProvider>()
    //           .kfTMDBSearchTVResultsById
    //           ?.numberOfSeasons ??
    //       2;
    // }

    String seasonsUrl = "";
    var element = startDoc.getElementById('sesh');

    String? checkUrl;

    if (element != null) {
      checkUrl = element.getElementsByTagName('a')[0].attributes['href'];
    }

    if (checkUrl != null) {
      seasonsUrl = checkUrl;
    }

    String url = seasonsUrl == ""
        ? homeUrl
        : seasonsUrl.startsWith('/')
            ? "$kfMoviesDetailBaseUrl${seasonsUrl.substring(0, seasonsUrl.indexOf("?"))}?s=$currentSeason"
            : "${seasonsUrl.substring(0, seasonsUrl.indexOf("?"))}?s=$currentSeason";
    log("SEASON URL: $url");

    final episodesPage = (await fetchDataFromInternet(url)).body;
    // log(episodesPage);
    final document = episodesPage.document;
    final episodesList = document.getElementsByClassName("seho");

    log("EPISODES lIST: $episodesList");

    String episodeUrl = "";

    if (episodesList.isNotEmpty) {
      String url = episodesList.reversed
              .toList()[episodeIndex ?? 0]
              .getElementsByTagName('a')
              .first
              .attributes['href'] ??
          "";
      url = "$kfMoviesDetailBaseUrl$url";

      log("episode url: $url");

      episodeUrl = url;
    }

    return episodeUrl;
  }

  late Future<String>? fetchEpisodeUrl;
  @override
  void initState() {
    super.initState();
    fetchEpisodeUrl = isMovie ? null : _fetchEpisodeUrl();
  }

  bool _delayedLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KFProvider>(context);
    String? title;

    bool isTv = provider.kfTMDBSearchTVResultsById != null;
    if (isTv) {
      title = provider.kfTMDBSearchTVResultsById?.name ??
          provider.kfTMDBSearchTVResultsById?.originalName ??
          "";
      title =
          "$title Season $currentSeason Episode ${episodeIndex!.toInt() + 1}";
    } else {
      title = provider.kfTMDBSearchMovieResultsById?.title ??
          provider.kfTMDBSearchMovieResultsById?.originalTitle ??
          "";
    }
    return Scaffold(
      key: _scaffoldKey,
      body: _buidBody(title),
    );
  }

  Widget _buidBody(String title) => Builder(builder: (context) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: boldTextStyle(color: Colors.white, size: 21),
                      textAlign: TextAlign.center,
                    ),
                    32.height,
                    Visibility(
                      visible: !_delayedLoading,
                      child: const Text(
                        'Loading video...',
                      ),
                    ),
                    10.height,
                    CircularPercentIndicator(
                      animateFromLastPercent: true,
                      radius: 80,
                      animationDuration: 35000,
                      onAnimationEnd: () =>
                          setState(() => _delayedLoading = true),
                      animation: true,
                      percent: 0.97,
                      center: Countup(
                        precision: 0,
                        curve: Curves.fastOutSlowIn,
                        begin: 0,
                        end: 97,
                        duration: 35000.milliseconds,
                        style: boldTextStyle(size: 16, color: Colors.white),
                        suffix: '%',
                      ),
                      progressColor: kfPrimaryTextColor,
                    ),
                    if (_delayedLoading)
                      Column(
                        children: [
                          10.height,
                          Text(
                            "Loading this video is taking longer than expected. Please try to connect to fatser internet connection or restart the app and try again",
                            style: boldTextStyle(color: kfPrimaryTextColor),
                            textAlign: TextAlign.center,
                          ),
                          10.height,
                          ElevatedButton(
                              style: kfButtonStyle(context),
                              onPressed: () {
                                finish(context);
                                KFVideoLoadingComponent(
                                        homeUrl: homeUrl, isMovie: isMovie)
                                    .launch(context);
                              },
                              child: Text(
                                "Try Again",
                                style: boldTextStyle(color: Colors.black),
                              ))
                        ],
                      ),
                  ],
                ),
              ),
            ),
            isMovie
                ? _web()
                : FutureBuilder<String>(
                    future: fetchEpisodeUrl,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.loaded) {
                        final url = snapshot.data ?? "";
                        return _web(url: url);
                      }
                      return Container();
                    }),
          ],
        );
      });

  Widget _web({String? url}) => Offstage(
        // offstage: false,
        offstage: true,
        child: WebComponent(
            url: url ??
                (homeUrl.startsWith('/')
                    ? '$kfMoviesDetailBaseUrl$homeUrl'
                    : homeUrl)),
      );
}
