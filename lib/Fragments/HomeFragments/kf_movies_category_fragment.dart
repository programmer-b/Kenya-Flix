import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_functions.dart';
import 'package:kenyaflix/Components/kf_common_components.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

import '../../Commons/kf_strings.dart';

class KFMoviesCategoryFragment extends StatefulWidget {
  const KFMoviesCategoryFragment({Key? key}) : super(key: key);

  @override
  State<KFMoviesCategoryFragment> createState() =>
      _KFMoviesCategoryFragmentState();
}

class _KFMoviesCategoryFragmentState extends State<KFMoviesCategoryFragment> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KFProvider>(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              if (index == 0)
                StreamBuilder(
                    stream: fetchData(trendingNowMovies[0]['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != '') {
                          final trendingUrls = stractureData(
                              snapshot.data ?? '',
                              trending: true);
                          return Column(
                            children: [
                              genreTitleWidget(
                                  trendingNowMovies[0]['display_title'],
                                  isMovie: false,
                                  trending: true),
                              6.height,
                              horrizontalImageListBuilder(urls: trendingUrls, trending: true)
                            ],
                          );
                        }
                      }
                      if (snapshot.hasError) {
                        provider.setError(true);
                      }
                      return loadingWidget(trending: true);
                    }),
              StreamBuilder(
                  stream: fetchData(movies[index]['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data != '') {
                        final urls = stractureData(snapshot.data ?? '');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            genreTitleWidget(movies[index]['display_title'],
                                isMovie: true),
                            6.height,
                            horrizontalImageListBuilder(urls: urls)
                          ],
                        );
                      }
                    }
                    if (snapshot.hasError) {
                      provider.setError(true);
                    }
                    return loadingWidget();
                  })
            ],
          ).paddingSymmetric(horizontal: 7);
        },
        childCount: movies.length,
      ),
    );
  }
}
