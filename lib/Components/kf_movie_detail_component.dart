import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_functions.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_common_components.dart';
import 'package:nb_utils/nb_utils.dart';

class KFMovieDetailComponent extends StatefulWidget {
  const KFMovieDetailComponent({super.key});

  @override
  State<KFMovieDetailComponent> createState() => _KFMovieDetailComponentState();
}

class _KFMovieDetailComponentState extends State<KFMovieDetailComponent> {
  int get id => kfmovieDetailSecondaryID;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: fetchData(id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != '') {
                            // return _delegates[index];
                            return _loadingWidget(screenWidth);
                          }
                        }
                        return _loadingWidget(screenWidth);
                      }),
                ),
            childCount: _delegates.length));
  }

  final List<Widget> _delegates = [const Center()];

  Widget _loadingWidget(double width) => Column(
        children: [
          _imagePlaceHolder(width),
          16.height,
          _titlePlaceHolder(width),
          16.height,
          _titlePlaceHolder(width),
          32.height,
          _movieDetailsActionBar(width),
          26.height,
          _movieDescriptionPlaceHolder()
        ],
      );
  Widget _titlePlaceHolder(double width) => FadeShimmer(
        radius: 8,
        width: width,
        height: 28,
        fadeTheme: FadeTheme.dark,
      );

  Widget _imagePlaceHolder(double width) => FadeShimmer(
        width: width,
        height: 200,
        fadeTheme: FadeTheme.dark,
      );

  List<Widget> _smallTextShimmers() =>
      List<Widget>.generate(6, (index) => smallTextShimmer());

  List<Widget> _mediumTextShimmers() =>
      List<Widget>.generate(5, (index) => mediumTextShimmer());

  List<Widget> _largeTextShimmers() =>
      List<Widget>.generate(4, (index) => largeTextShimmer());

  Widget _movieDescriptionPlaceHolder() {
    List<Widget> descriptionShimmers = [
      ..._smallTextShimmers(),
      ..._mediumTextShimmers(),
      ..._largeTextShimmers()
    ];
    descriptionShimmers.shuffle();
    descriptionShimmers.shuffle();
    descriptionShimmers.shuffle();
    return Wrap(spacing: 8, runSpacing: 8, children: descriptionShimmers);
  }

  Widget _movieDetailsActionBar(width) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(
            3,
            (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _downloadButtonPlaceHolder(),
                    8.height,
                    _textPlaceHolder(width)
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
}
