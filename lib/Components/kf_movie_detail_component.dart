import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_Image_builder.dart';
import 'package:kenyaflix/Components/kf_title_builder.dart';
import 'package:kenyaflix/Models/kf_tmdb_search_model.dart';
import 'package:nb_utils/nb_utils.dart' hide log;

import 'kf_optional_details.dart';

class KFMovieDetailComponent extends StatefulWidget {
  const KFMovieDetailComponent(
      {super.key, required this.isMovie, required this.homeUrl});
  final bool isMovie;
  final String homeUrl;

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
  String get homeUrl => widget.homeUrl;

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
        const KFImageBuilder(),
        const KFTitleBuilder(),
        KFMovieDetailComponent(isMovie: isMovie, homeUrl: homeUrl),
        const KFOptionalDetailsBar(),
      ];
}
