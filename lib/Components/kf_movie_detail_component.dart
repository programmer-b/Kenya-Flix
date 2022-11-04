import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Models/kf_tmdb_search_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

import 'kf_common_components.dart';

class KFMovieDetailComponent extends StatefulWidget {
  const KFMovieDetailComponent({super.key, required this.isMovie});
  final bool isMovie;

  @override
  State<KFMovieDetailComponent> createState() => _KFMovieDetailComponentState();
}

class _KFMovieDetailComponentState extends State<KFMovieDetailComponent> {
  KFTMDBSearchModel? searchedTMDBData;
  late bool isMovie;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // searchedTMDBData = context.read<KFProvider>().kfTMDBSearchResults;
    isMovie = widget.isMovie;
  }

  int get id => kfmovieDetailSecondaryID;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              _delegates(isMovie)[index].paddingSymmetric(horizontal: 5),
          childCount: _delegates(isMovie).length),
    );
  }

  List<Widget> _delegates(bool isMovie) => [
        const _ImageBuilder(),
        const _TitleBuilder(),
        _MovieDetailActions(isMovie),
        const _OptionalDetailsBar(),
      ];
}

class _ImageBuilder extends StatelessWidget {
  const _ImageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 0.3;

    return Consumer<KFProvider>(
        builder: (context, value, child) => value.tmdbSearchResultsLoaded
            ? CachedNetworkImage(
                key: UniqueKey(),
                imageUrl:
                    "$kfOriginalTMDBImageUrl${value.kfTMDBSearchResults?.results?[0]?.backdropPath ?? value.kfTMDBSearchResults?.results?[0]?.profilePath}",
                height: height,
                width: width,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  );
                },
                placeholder: (context, url) => _imagePlaceHolder(width, height),
                errorWidget: (context, url, error) =>
                    _imagePlaceHolder(width, height),
              )
            : _imagePlaceHolder(width, height));
  }

  Widget _imagePlaceHolder(double width, double height) => FadeShimmer(
        width: width,
        height: height,
        fadeTheme: FadeTheme.dark,
        radius: 18,
      );
}

class _TitleBuilder extends StatelessWidget {
  const _TitleBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<KFProvider>(
        builder: (context, value, child) => SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                value.tmdbSearchResultsLoaded
                    ? Text(
                        value.kfTMDBSearchResults?.results?[0]?.name ??
                            value.kfTMDBSearchResults?.results?[0]
                                ?.originalName ??
                            value.kfTMDBSearchResults?.results?[0]?.title ??
                            value.kfTMDBSearchResults?.results?[0]
                                ?.originalTitle ??
                            "",
                        style: boldTextStyle(
                          color: kfPrimaryTextColor,
                          size: 28,
                        ),
                      )
                    : _titlePlaceHolder(width),
                4.height,
                if (value.tmdbSearchResultsLoaded) _buildSmallDetails(value)
              ],
            )).paddingSymmetric(vertical: 10, horizontal: 8));
  }

  Widget _titlePlaceHolder(double width) => FadeShimmer(
        radius: 8,
        width: width,
        height: 28,
        fadeTheme: FadeTheme.dark,
      );

  Widget _buildSmallDetails(KFProvider value) => Row(
        children: [
          RichText(
            text: TextSpan(
                text: value.kfTMDBSearchResults?.results?[0]?.firstAirDate ??
                    value.kfTMDBSearchResults?.results?[0]?.releaseDate ??
                    ""),
          ),
          8.width,
          if (value.tmdbSearchMoviesByIdLoaded ||
              value.tmdbSearchSeriesByIdLoaded)
            Builder(builder: (context) {
              bool isAdult = false;

              if (value.tmdbSearchMoviesByIdLoaded) {
                isAdult =
                    value.kfTMDBSearchMovieResultsById?.adult.toString() ==
                        "true";
              } else {
                isAdult =
                    value.kfTMDBSearchTVResultsById?.adult.toString() == "true";
              }
              return Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    isAdult ? "18+" : "16+",
                    style: primaryTextStyle(size: 14, color: Colors.white),
                  ));
            }),
          8.width,
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: value.kfTMDBSearchMovieResultsById?.runtime == null
                    ? value.kfTMDBSearchTVResultsById == null
                        ? ""
                        : "${value.kfTMDBSearchTVResultsById?.numberOfSeasons} Season${value.kfTMDBSearchTVResultsById?.numberOfSeasons == 1 ? "" : "s"}"
                    : "${value.kfTMDBSearchMovieResultsById?.runtime} min"),
            TextSpan(
                text: value.kfOMDBSearchResults?.imdbRating == null
                    ? ""
                    : " : IMDb ${value.kfOMDBSearchResults?.imdbRating ?? ""}")
          ])),
        ],
      );
}

class _MovieDetailActions extends StatelessWidget {
  const _MovieDetailActions(this.isMovie);

  final bool isMovie;

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
                    child: ElevatedButton(
                      onPressed: () {},
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
                          4.width,
                          Text(
                            "Watch Now ${isMovie ? "" : "S1 E1"}",
                            style: boldTextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.height,
                  const _BuildDetailsActionBar(),
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

class _BuildDetailsActionBar extends StatelessWidget {
  const _BuildDetailsActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<KFProvider>(builder: (context, value, child) {
      final List<Widget> actions = _actions(value);

      if (value.kfTMDBSearchVideoResults == null) {
        log("Video data is actually not available");
        actions.removeRange(1, 2);
      }

      return HorizontalList(
          itemCount: actions.length,
          itemBuilder: (context, index) => actions[index]);
    });
  }

  List<Widget> _actions(KFProvider value) => [
        _MovieDetailActionButtonBuilder(
            onTap: () {}, icon: Icons.file_download_outlined, text: "Download"),
        6.width,
        _MovieDetailActionButtonBuilder(
            onTap: () {}, icon: MdiIcons.playOutline, text: "Trailer"),
        6.width,
        _MovieDetailActionButtonBuilder(
            onTap: () {}, icon: Icons.add_outlined, text: "Watchlist"),
        6.width,
        _MovieDetailActionButtonBuilder(
            onTap: () {}, icon: Icons.more_vert_sharp, text: "More")
      ];
}

class _MovieDetailActionButtonBuilder extends StatelessWidget {
  const _MovieDetailActionButtonBuilder(
      {Key? key, required this.onTap, required this.icon, required this.text})
      : super(key: key);
  final Function()? onTap;
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        width: width * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            8.height,
            Text(
              text,
              style: secondaryTextStyle(color: Colors.white, size: 12),
            )
          ],
        ),
      ),
    );
  }
}

class _OptionalDetailsBar extends StatelessWidget {
  const _OptionalDetailsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<KFProvider>(
        builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final originalCountriesList =
                        value.tmdbSearchMoviesByIdLoaded
                            ? value.kfTMDBSearchMovieResultsById
                                    ?.productionCountries ??
                                []
                            : value.kfTMDBSearchTVResultsById
                                    ?.productionCountries ??
                                [];
                    final originalCountry = originalCountriesList.isNotEmpty
                        ? value.tmdbSearchMoviesByIdLoaded
                            ? value.kfTMDBSearchMovieResultsById
                                    ?.productionCountries![0].name ??
                                ""
                            : value.kfTMDBSearchTVResultsById
                                    ?.productionCountries![0].name ??
                                ""
                        : "";
                    return value.omdbDataloaded && originalCountry != ""
                        ? Column(
                            children: [
                              Text(
                                "Country: $originalCountry",
                                style: boldTextStyle(color: Colors.white60),
                              ),
                              4.height,
                            ],
                          )
                        : Container();
                  },
                ),
                Builder(
                  builder: (context) {
                    final originalLanguage = value.tmdbSearchMoviesByIdLoaded
                        ? value.kfTMDBSearchMovieResultsById
                                ?.originalLanguage ??
                            ""
                        : value.kfTMDBSearchTVResultsById?.originalLanguage ??
                            "";
                    return value.omdbDataloaded && originalLanguage != ""
                        ? Text(
                            "Language: $originalLanguage",
                            style: boldTextStyle(color: Colors.white60),
                          )
                        : Container();
                  },
                )
              ],
            ).paddingSymmetric(horizontal: 8));
  }
}
