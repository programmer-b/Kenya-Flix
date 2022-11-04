import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_extensions.dart';
import 'package:kenyaflix/Commons/kf_functions.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_cast_image_component.dart';
import 'package:kenyaflix/Components/kf_common_components.dart';
import 'package:kenyaflix/Components/kf_episode_image_build_component.dart';
import 'package:kenyaflix/Components/kf_more_info_build.dart';
import 'package:kenyaflix/Components/kf_tv_season_selection_screen_component.dart';
import 'package:kenyaflix/Fragments/kf_cast_information_fragment.dart';
import 'package:kenyaflix/Models/kf_tmdb_search_credits_model.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class KFMovieInformationBuilder extends StatefulWidget {
  const KFMovieInformationBuilder(
      {Key? key, required this.isMovie, required this.controller})
      : super(key: key);
  final bool isMovie;
  final TabController controller;

  @override
  State<KFMovieInformationBuilder> createState() =>
      _KFMovieInformationBuilderState();
}

class _KFMovieInformationBuilderState extends State<KFMovieInformationBuilder> {
  late bool isMovie = widget.isMovie;
  late TabController controller = widget.controller;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return isMovie
        ? _BuildMovieTabs(controller: controller, isMovie: isMovie)
        : _BuildTVTabs(controller: controller, isMovie: isMovie);
  }

}

class _BuildTVTabs extends StatelessWidget {
  const _BuildTVTabs(
      {Key? key, required this.controller, required this.isMovie})
      : super(key: key);
  final TabController controller;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    switch (controller.index) {
      case 0:
        return seasonsBuild();
      case 1:
        return exploreBuild();
      case 2:
        return moreInfoBuild();
      default:
        return seasonsBuild();
    }
  }

  Widget seasonsBuild() => SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) => const _TVSeasonBuild(),
        childCount: 1,
      ));
  Widget exploreBuild() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => const _TVAndMovieExploreBuild(),
            childCount: 1),
      );
  Widget moreInfoBuild() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => _TVAndMovieMoreInfoBuild(
                  isMovie: isMovie,
                ),
            childCount: 1),
      );
}

class _BuildMovieTabs extends StatelessWidget {
  const _BuildMovieTabs(
      {Key? key, required this.controller, required this.isMovie})
      : super(key: key);
  final TabController controller;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    if (controller.index == 0) {
      return _relatedBuild();
    } else {
      return _moreInfoBuild();
    }
  }

  Widget _relatedBuild() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => const _TVAndMovieExploreBuild(),
            childCount: 1),
      );
  Widget _moreInfoBuild() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => _TVAndMovieMoreInfoBuild(isMovie: isMovie), childCount: 1),
      );
}

class _TVSeasonBuild extends StatelessWidget {
  const _TVSeasonBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Consumer<KFProvider>(builder: (context, value, child) {
        int numberOfSeasons = value.numberOfSeasonsOfTheCurrentTVShow() ?? 0;
        return numberOfSeasons != 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (numberOfSeasons > 1) _seasonButtonBuild(value, context),
                  _EpisodesInfoList()
                ],
              )
            : Container();
      }),
    );
  }

  Widget _seasonButtonBuild(KFProvider value, BuildContext context) => Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        const KFTVSeasonSelectionScreenComponent(),
                  ),
              child: Row(
                children: [
                  Text("Season ${value.currentSeason}"),
                  3.width,
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  )
                ],
              )),
        ],
      );
}

class _EpisodesInfoList extends StatelessWidget {
  _EpisodesInfoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contraints = getScreenContraints(context);
    double width = contraints.getWidth();

    return Consumer<KFProvider>(builder: (context, value, child) {
      return value.kfEpisodes != null
          ? _buildEpisodeInfo(width, value)
          : Column(
              children: [
                for (int i = 0; i < 5; i++) _episodeInfoPlaceHolder(width)
              ],
            );
    });
  }

  Widget _buildEpisodeInfo(double width, KFProvider value) {
    String? imageUrl = "";
    dynamic runTime = 0;
    int episodeNumber = 0;
    String overview = "";

    final episodesList = value.kfEpisodes?.episodes ?? [];

    return Column(
      children: [
        for (int index = 0; index < episodesList.length; index++)
          Builder(builder: (context) {
            imageUrl =
                episodesList[index].stillPath ?? value.kfEpisodes?.posterPath;
            runTime =
                episodesList[index].runtime ?? episodesList[index].name ?? 0;
            episodeNumber = episodesList[index].episodeNumber ?? 0;
            overview = episodesList[index].overview ?? "";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          KFEpisodeImageBuildComponent(
                              width: width * 0.3, height: 90, path: imageUrl),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _titleBulder(index + 1, episodeNumber),
                              4.height,
                              _runTimeBuilder(runTime, width * 0.4)
                            ],
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                  ),
                  6.height,
                  _descriptionBuilder(overview)
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _imagePlaceHolder(double width) => FadeShimmer(
        height: 80,
        width: width * 0.3,
        fadeTheme: FadeTheme.dark,
      );

  Widget _titleBulder(int index, int episodeNumber) => Text(
        "$index.Episode $episodeNumber",
        style: boldTextStyle(size: 16, color: Colors.white),
      );
  Widget _titlePlaceHolder() => mediumTextShimmer();

  Widget _runTimeBuilder(dynamic runTime, double width) =>
      "$runTime".isNumeric()
          ? Text(
              "$runTime min",
              style: boldTextStyle(color: Colors.white60),
            )
          : SizedBox(
              height: 32,
              width: width,
              child: ReadMoreText(
                "$runTime",
                style: boldTextStyle(color: Colors.white60),
                trimLength: 20,
                trimCollapsedText: kfTrimCollapsedText,
              ),
            );
  Widget _runTimePlaceHolder() => smallTextShimmer();

  final List _smallTextShimmers = smallTextShimmers(8, height: 12);
  final List _mediumTextShimmers = mediumTextShimmers(6, height: 12);
  final List _largeTextShimmers = largeTextShimmers(3, height: 12);

  Widget _descriptionPlaceHolder() {
    List<Widget> descriptionnShimmers = [
      ..._smallTextShimmers,
      ..._mediumTextShimmers,
      ..._largeTextShimmers
    ];
    descriptionnShimmers.shuffle();

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: descriptionnShimmers,
    );
  }

  Widget _descriptionBuilder(String overview) => ReadMoreText(
        trimCollapsedText: kfTrimCollapsedText,
        trimLength: 150,
        trimMode: TrimMode.Length,
        overview,
        style: primaryTextStyle(color: Colors.white60, size: 13),
      );

  Widget _episodeInfoPlaceHolder(double width) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _imagePlaceHolder(width),
                5.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titlePlaceHolder(),
                    4.height,
                    _runTimePlaceHolder()
                  ],
                )
              ],
            ),
            6.height,
            _descriptionPlaceHolder()
          ],
        ),
      );
}

class _TVAndMovieExploreBuild extends StatelessWidget {
  const _TVAndMovieExploreBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cast & Crew",
            style: boldTextStyle(size: 17, color: Colors.white),
          ),
          3.height,
          Text(
            "Details From IMDb",
            style: boldTextStyle(size: 16, color: Colors.white60),
          ),
          const _CastAndCrewScreenBuild()
        ],
      ),
    );
  }
}

class _CastAndCrewScreenBuild extends StatelessWidget {
  const _CastAndCrewScreenBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Consumer<KFProvider>(builder: (context, value, child) {
        var credits = context.watch<KFProvider>().kfTMDBsearchCreditsResults;
        final List<Cast> casts = credits?.cast ?? [];

        if (value.kfTMDBsearchCreditsResults?.cast?.isNotEmpty ?? false) {
          return Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              for (var cast in casts)
                KFCastImageComponent(
                  profilePath: cast.profilePath,
                  name: cast.name ?? cast.originalName,
                  onTap: () =>
                      KFCastInfoFragment(id: cast.id ?? 0).launch(context),
                )
            ],
          );
        }
        return Wrap(
          spacing: 5,
          runSpacing: 5,
          children: List<Widget>.generate(
            10,
            (index) => const KFCastImageComponent(
              profilePath: null,
              name: null,
            ),
          ),
        );
      }),
    );
  }
}

class _TVAndMovieMoreInfoBuild extends StatelessWidget {
  const _TVAndMovieMoreInfoBuild({Key? key, required this.isMovie})
      : super(key: key);
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return KFMoreInfoBuild(isMovie: isMovie);
  }
}
