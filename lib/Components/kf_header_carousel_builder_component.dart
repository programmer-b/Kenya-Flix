import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Commons/kf_functions.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Screens/kf_movie_detail_screen.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class KFHeaderCarouselBuilderComponent extends StatefulWidget {
  const KFHeaderCarouselBuilderComponent({Key? key, required this.isMovie})
      : super(key: key);
  final bool isMovie;

  @override
  State<KFHeaderCarouselBuilderComponent> createState() =>
      _KFHeaderCarouselBuilderComponentState();
}

class _KFHeaderCarouselBuilderComponentState
    extends State<KFHeaderCarouselBuilderComponent> {
  int _activeIndex = 0;
  int get activeIndex => _activeIndex;

  final _autoPlayAnimationDuration = const Duration(milliseconds: 200);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        for (var index = 0;
            widget.isMovie
                ? index < kfPopularMoviesIDs.length
                : index < kfPopularSeriesIDs.length;
            index++)
          Visibility(visible: false, child: _imageStreamBuilder(index)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CarouselSlider.builder(
              itemCount: widget.isMovie
                  ? kfPopularMoviesIDs.length
                  : kfPopularSeriesIDs.length,
              itemBuilder: (context, index, realIndex) =>
                  _imageStreamBuilder(index),
              options: CarouselOptions(
                  height: 0.3 * height,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 6),
                  autoPlayAnimationDuration: _autoPlayAnimationDuration,
                  onPageChanged: ((index, reason) =>
                      setState(() => _activeIndex = index)))),
        ),
        _buildIndicator().paddingSymmetric(vertical: 8),
      ],
    );
  }

  Widget _imageStreamBuilder(int index) {
    final imageIndex =
        widget.isMovie ? kfPopularMoviesIDs[index] : kfPopularSeriesIDs[index];
    return StreamBuilder(
        stream: fetchAllData(imageIndex),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final backdropImageUrl = snapshot.data?.backdropsPath;
            final title = snapshot.data?.title;
            if (backdropImageUrl != "null") {
              final url = '$kfOriginalTMDBImageUrl$backdropImageUrl';
              log(url);
              return _imageBuilder(
                  url, title ?? (widget.isMovie ? "Movie" : "TV Show"), snapshot.data?.homeUrl ?? "https://www.goojara.to/eAeMM8");
            }
          }
          return _imagePlaceHolder();
        });
  }

  Widget _buildIndicator() => AnimatedSmoothIndicator(
      effect: const JumpingDotEffect(
          dotColor: Colors.white38,
          activeDotColor: Colors.white,
          dotHeight: 10),
      duration: _autoPlayAnimationDuration,
      activeIndex: activeIndex,
      count: widget.isMovie
          ? kfPopularMoviesIDs.length
          : kfPopularSeriesIDs.length);

  Widget _imagePlaceHolder() => const FadeShimmer(
        width: double.infinity,
        height: 200,
        fadeTheme: FadeTheme.dark,
      );

  Widget _imageBuilder(String imageUrl, String title, String homeUrl) => GestureDetector(
    onTap: () => KFMovieDetailScreen(homeUrl: homeUrl).launch(context),
    child: CachedNetworkImage(
          imageUrl: imageUrl,
          key: UniqueKey(),
          imageBuilder: ((context, image) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: image, fit: BoxFit.cover),
                      border: Border.all(color: Colors.yellow, width: 0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      color: kfAppBarBgColor,
                      height: 30,
                      child: Center(
                          child: Text(
                        title,
                        style: boldTextStyle(color: kfPrimaryTextColor),
                      ))),
                )
              ],
            );
          }),
          placeholder: (_, __) => _imagePlaceHolder(),
          errorWidget: (_, __, ___) => _imagePlaceHolder(),
        ),
  );
}
