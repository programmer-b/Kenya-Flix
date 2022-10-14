import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_dimens.dart';

import 'kf_common_components.dart';

class KFImageContainerComponent extends StatelessWidget {
  const KFImageContainerComponent(
      {Key? key,
      required this.urlImage,
      required this.homeUrl,
      this.trending = false})
      : super(key: key);

  final String urlImage;
  final String homeUrl;

  final bool trending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => log(homeUrl),
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
                  width: 0.2,
                ),
                image: DecorationImage(image: image, fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
          ),
        ),
        height: 150,
        placeholder: (context, url) => imagePlaceHolder(),
        errorWidget: (context, url, error) => imagePlaceHolder(),
      ),
    );
  }
}
