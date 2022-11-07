import 'package:flutter/material.dart';
import 'package:kenyaflix/Components/kf_tv_and_movie_explore_build.dart';
import 'package:kenyaflix/Components/kf_tv_and_movie_more_info_build.dart';

import 'kf_tv_season_build.dart';

class KFBuildTVTabs extends StatelessWidget {
  const KFBuildTVTabs(
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
        (context, index) => const KFTVSeasonBuild(),
        childCount: 1,
      ));
  Widget exploreBuild() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => const KFTVAndMovieExploreBuild(),
            childCount: 1),
      );
  Widget moreInfoBuild() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => KFTVAndMovieMoreInfoBuild(
                  isMovie: isMovie,
                ),
            childCount: 1),
      );
}
