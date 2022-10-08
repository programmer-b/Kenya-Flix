part of './components.dart';

class VideoPlayerComponent extends StatelessWidget {
  const VideoPlayerComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<KFVideoProvider>(builder: (context, provider, child) {
        final controller = provider.controller;
        return (controller != null && controller.value.isInitialized)
            ? Container(
                alignment: Alignment.topCenter,
                child: buildVideo(controller),
              )
            : SizedBox(
                height: 200,
                child: Center(
                    child: fadingCircleSpinKit(context, color: Colors.white)),
              );
      }),
    );
  }

  Widget buildVideo(controller) => Stack(
        children: [
          buildVideoPlayer(controller),
          Positioned.fill(
              child: KFBasicOverlayVideoComponent(controller: controller)),
        ],
      );
  Widget buildVideoPlayer(controller) => AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller));
}
