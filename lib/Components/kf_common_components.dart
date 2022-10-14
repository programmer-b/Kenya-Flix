import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_dimens.dart';
import 'package:kenyaflix/Components/kf_image_container_component.dart';
import 'package:nb_utils/nb_utils.dart';

Widget loadingWidget({bool trending = false}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        genreTitlePlaceHolder(),
        6.height,
        HorizontalList(
            itemCount: 10,
            itemBuilder: (context, index) {
              return imagePlaceHolder();
            }),
      ],
    ).paddingSymmetric(vertical: 5, horizontal: 8);

Widget horrizontalImageListBuilder(
        {required List<Map<String, String>> urls,
        void Function()? onTap,
        bool trending = false}) =>
    HorizontalList(
        itemCount: trending ? urls.length : 10,
        itemBuilder: (context, index) {
          final imageUrl = urls[index]['imageUrl'];
          final homeUrl = urls[index]['homeUrl'] ?? "";
          final urlImage = 'https:$imageUrl';
          return KFImageContainerComponent(
            urlImage: urlImage,
            homeUrl: homeUrl,
            trending: trending,
          );
        });

Widget genreTitleWidget(String genre,
        {required bool isMovie, bool trending = false}) =>
    Row(
      children: [
        RichText(
            text: TextSpan(
                text: trending ? '' : 'Rock Flix - ',
                children: <TextSpan>[
                  TextSpan(
                      text: "$genre ${trending ? '': isMovie ? 'Movies' : 'Series'} ",
                      style: boldTextStyle(color: Colors.white))
                ],
                style: boldTextStyle(color: Colors.blue))),
        4.width,
        const Icon(Icons.chevron_right)
      ],
    );
Widget genreTitlePlaceHolder() => const FadeShimmer(
      height: 25,
      width: 100,
      fadeTheme: FadeTheme.dark,
    );

Widget imagePlaceHolder({bool trending = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FadeShimmer(
        width: trending ? trendingImageWidthDimen : defaultGenreImageWidthDimen,
        height:
            trending ? trendingImageHeightDimen : defaultGenreImageHeightDimen,
        fadeTheme: FadeTheme.dark,
      ),
    );
