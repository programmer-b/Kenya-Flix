import 'dart:developer';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Commons/kf_extensions.dart';
import 'package:kenyaflix/Commons/kf_functions.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_web_component.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class KFVideoLoadingComponent extends StatefulWidget {
  const KFVideoLoadingComponent(
      {super.key,
      required this.homeUrl,
      required this.isMovie,
      this.currentSeason,
      this.episodeIndex,
      this.numberOfSeasons});
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
    final startPage = (await fetchDataFromInternet(homeUrl)).body;

    final startDoc = startPage.document;
    int numberOfSeasons = 2;
    if (mounted) {
      numberOfSeasons = context
              .read<KFProvider>()
              .kfTMDBSearchTVResultsById
              ?.numberOfSeasons ??
          2;
    }

    var seasonsUrl = numberOfSeasons == 1
        ? ""
        : (startDoc
            .getElementById('sesh')!
            .getElementsByTagName('a')[0]
            .attributes['href'] ??
        "");

    String url = numberOfSeasons == 1
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Loading video...',
                  ),
                  10.height,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularPercentIndicator(
                      animateFromLastPercent: true,
                      radius: 80,
                      animationDuration: 35000,
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
                  ),
                  10.height,
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
      ),
    );
  }

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
