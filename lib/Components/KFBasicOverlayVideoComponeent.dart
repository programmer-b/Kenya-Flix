part of './components.dart';

class KFBasicOverlayVideoComponent extends StatelessWidget {
  const KFBasicOverlayVideoComponent({Key? key, required this.controller})
      : super(key: key);
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<KFVideoProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.value.isPlaying ? null : controller.play(),
          onDoubleTap: () =>
              controller.value.isPlaying ? controller.pause() : null,
          child: Stack(
            children: [
              buildPlay(),
              Center(
                child: buildPlaceHolder(context,provider.isVideoPlaying,provider.isVideoPaused),
              ),
              Positioned(left: 0, right: 0, bottom: 0, child: buildIndicator())
            ],
          ),
        );
      },
    );
  }

  Widget buildPlaceHolder(context,bool isVideoPlaying, bool isVideoPaused) => (!controller.value.isPlaying && !isVideoPaused)
      ? fadingCircleSpinKit(context, color: Colors.white)
      :  Container();

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
        colors: const VideoProgressColors(
            playedColor: Colors.red,
            bufferedColor: Colors.white60,
            backgroundColor: Colors.white30),
      );
  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ));
}
