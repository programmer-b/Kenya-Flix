
import 'package:flutter/material.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

import '../../Commons/kf_strings.dart';
import '../../Utils/kf_utils.dart';

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
          return StreamBuilder(
              stream: fetchData(movies[index]['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != '') {
                    final urls = stractureData(snapshot.data ?? '');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        genreTitleWidget(movies[index]['display_title'], isMovie: true),
                        6.height,
                        horrizontalImageListBuilder(urls: urls)
                      ],
                    ).paddingSymmetric(horizontal: 6);
                  }
                }
                if (snapshot.hasError) {
                  provider.setError(true);
                }
                return loadingWidget();
              });
        },
        childCount: movies.length,
      ),
    );
  }
}
