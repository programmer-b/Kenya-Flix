import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_dimens.dart';
import 'package:kenyaflix/Screens/kf_movie_detail_screen.dart';
import 'package:nb_utils/nb_utils.dart' hide log;

import 'kf_common_components.dart';

class KFImageContainerComponent extends StatelessWidget {
  const KFImageContainerComponent(
      {Key? key,
      required this.urlImage,
      required this.homeUrl,
      this.trending = false,
      required this.type,
      required this.query,
      required this.year})
      : super(key: key);

  final String urlImage;
  final String homeUrl;
  final String type;
  final String query;
  final String year;

  final bool trending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KFMovieDetailScreen(
        homeUrl: homeUrl,
        query: query,
        year: year,
        type: type,
      ).launch(context),
      child: CachedNetworkImage(
        key: UniqueKey(),
        imageUrl: urlImage,
        imageBuilder: (_, image) => Card(
          elevation: 5,
          child: Container(
            height: trending
                ? trendingImageHeightDimen
                : defaultGenreImageHeightDimen,
            width: trending
                ? trendingImageWidthDimen
                : defaultGenreImageWidthDimen,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.yellow,
                  width: 0.1,
                ),
                image: DecorationImage(image: image, fit: BoxFit.fill),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
          ),
        ),
        placeholder: (context, url) => imagePlaceHolder(),
        errorWidget: (context, url, error) => imagePlaceHolder(),
      ),
    );
  }
}
