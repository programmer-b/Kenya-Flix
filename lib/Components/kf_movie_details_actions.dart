import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../Commons/kf_colors.dart';
import '../Provider/kf_provider.dart';
import 'kf_build_details_action_bar.dart';
import 'kf_common_components.dart';
import 'kf_web_component.dart';

class kFMovieDetailActions extends StatelessWidget {
  const kFMovieDetailActions(this.isMovie, {required this.homeUrl});

  final bool isMovie;
  final String homeUrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<KFProvider>(builder: (context, value, child) {
      return value.tmdbSearchVideoLoaded
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => _loadingWidget(context, homeUrl),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            MdiIcons.play,
                            color: Colors.black,
                          ),
                          8.width,
                          Text(
                            "Watch Now ${isMovie ? "" : "S1 E1"}",
                            style: primaryTextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  8.height,
                  SizedBox(
                    width: width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white30,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                          ),
                          4.width,
                          Text(
                            "Download ${isMovie ? "" : "S1 E1"}",
                            style: primaryTextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.height,
                  const KFBuildDetailsActionBar(),
                  16.height,
                  _movieDescriptionBar(width, value),
                  8.height,
                  _movieGenreDetailsBar(width, value)
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                children: [
                  _buttonPlaceHolder(width),
                  8.height,
                  _movieDetailsActionBarPlaceHolder(width),
                  16.height,
                  _movieDescriptionPlaceHolder(width),
                ],
              ),
            );
    });
  }

  final _spinkit = const SpinKitFadingCircle(
    color: Colors.white,
  );

  Widget _loadingWidget(context, url) => Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: _spinkit.center(),
          ).center(),
          _web(url)
        ],
      );

  Widget _web(String url) => Offstage(
        offstage: false,
        child: WebComponent(url: url),
      );

  Widget _movieDetailsActionBarPlaceHolder(width) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(
            3,
            (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _downloadButtonPlaceHolder(),
                    8.height,
                    _textPlaceHolder(width),
                  ],
                )),
      );

  Widget _downloadButtonPlaceHolder() => FadeShimmer.round(
        size: 55,
        fadeTheme: FadeTheme.dark,
      );
  Widget _textPlaceHolder(width) => FadeShimmer(
        radius: 8,
        height: 18,
        width: width * 0.22,
        fadeTheme: FadeTheme.dark,
      );

  Widget _buttonPlaceHolder(double width) => FadeShimmer(
        radius: 8,
        width: width,
        height: 28,
        fadeTheme: FadeTheme.dark,
      );
  Widget _movieDescriptionPlaceHolder(double width) {
    List<Widget> descriptionShimmers = [
      ...smallTextShimmers(5),
      ...mediumTextShimmers(4),
      ...largeTextShimmers(3)
    ];
    descriptionShimmers.shuffle();
    return SizedBox(
        height: 100,
        width: width,
        child: Wrap(spacing: 8, runSpacing: 8, children: descriptionShimmers));
  }

  _movieDescriptionBar(double width, KFProvider value) {
    return ReadMoreText(
      value.tmdbSearchMoviesByIdLoaded
          ? value.kfTMDBSearchMovieResultsById?.overview == ""
              ? value.kfOMDBSearchResults?.plot ?? ""
              : value.kfTMDBSearchMovieResultsById?.overview ?? ""
          : value.kfTMDBSearchTVResultsById?.overview ?? "",
      trimLength: 120,
      style: boldTextStyle(color: Colors.white, size: 15),
    );
  }

  _movieGenreDetailsBar(double width, KFProvider value) => Container(
      width: width,
      height: 25,
      margin: const EdgeInsets.only(top: 5),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) => Builder(builder: (context) {
                final genre = value.tmdbSearchMoviesByIdLoaded
                    ? {
                        value.kfTMDBSearchMovieResultsById?.genres?[i].name ??
                            ""
                      }
                    : {value.kfTMDBSearchTVResultsById?.genres?[i].name ?? ""};
                return Text(
                  genre.elementAt(0),
                  style: boldTextStyle(color: kfPrimaryTextColor, size: 16),
                );
              }),
          separatorBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
              ),
          itemCount: value.tmdbSearchMoviesByIdLoaded
              ? value.kfTMDBSearchMovieResultsById?.genres?.length ?? 0
              : value.kfTMDBSearchTVResultsById?.genres?.length ?? 0));
}