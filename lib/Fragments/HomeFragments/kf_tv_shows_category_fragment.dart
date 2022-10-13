
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../Utils/kf_utils.dart';

class KFTvShowsCategoryFragment extends StatefulWidget {
  const KFTvShowsCategoryFragment({Key? key}) : super(key: key);

  @override
  State<KFTvShowsCategoryFragment> createState() =>
      _KFTvShowsCategoryFragmentState();
}


class _KFTvShowsCategoryFragmentState extends State<KFTvShowsCategoryFragment> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KFProvider>(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return StreamBuilder(
              stream: fetchData(series[index]['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != '') {
                    final urls = stractureData(snapshot.data ?? '');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        genreTitleWidget(series[index]['display_title'], isMovie: false),
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
        childCount: series.length,
      ),
    );
  }
}
