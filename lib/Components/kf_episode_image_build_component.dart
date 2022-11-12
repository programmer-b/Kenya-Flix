import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Components/kf_video_loading_component.dart';

class KFEpisodeImageBuildComponent extends StatelessWidget {
  const KFEpisodeImageBuildComponent({
    super.key,
    required this.width,
    required this.height,
    required this.path,
    required this.homeUrl,
    required this.currentSeason,
    required this.index,
  });
  final double width;
  final double height;
  final String? path;
  final String homeUrl;
  final String currentSeason;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () =>  showDialog(
      //     context: context,
      //     builder: (context) => KFVideoLoadingComponent(
      //           homeUrl: homeUrl,
      //           currentSeason: currentSeason,
      //           episodeIndex: index,
      //           isMovie: false,
      //         )),
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                image: path == null
                    ? null
                    : DecorationImage(
                        image: CachedNetworkImageProvider(
                            "$kfOriginalTMDBImageUrl$path"),
                        fit: BoxFit.cover)),
          ),
          Container(
            height: height,
            width: width,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: playButton(onTap: () {}),
          )
        ],
      ),
    );
  }

  Widget playButton({required Function()? onTap}) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: const Color(0x67000000),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
              )),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 17,
          ),
        ),
      );
}
