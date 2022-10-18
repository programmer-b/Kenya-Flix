import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_header_carousel_builder_component.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Components/kf_movie_data_component.dart';
import '../../Components/kf_movie_header_component.dart';

class KFTvShowsCategoryFragment extends StatefulWidget {
  const KFTvShowsCategoryFragment({Key? key}) : super(key: key);

  @override
  State<KFTvShowsCategoryFragment> createState() =>
      _KFTvShowsCategoryFragmentState();
}

class _KFTvShowsCategoryFragmentState extends State<KFTvShowsCategoryFragment> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              if (index == 0)
                const KFHeaderCarouselBuilderComponent(isMovie: false),
              if (index == 0) const KFMovieHeaderComponent(isMovie: false),
              KFMovieDataComponent(index: index, isMovie: false)
            ],
          ).paddingSymmetric(horizontal: 6);
        },
        childCount: series.length,
      ),
    );
  }
}
