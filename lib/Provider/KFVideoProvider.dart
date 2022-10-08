import 'package:flutter/cupertino.dart';
import 'package:kenyaflix/Screens/KFVideoPlayerScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

class KFVideoProvider extends ChangeNotifier {
  void launchVideoPlayerScreen(context){
    enterFullScreen();
    setOrientationLandscape();
    const KFVideoPlayerScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Slide);
  }

  void escapeVideoPlayerScreen(context){
    exitFullScreen();
    setOrientationPortrait();
    finish(context);
  }

  VideoPlayerController? _controller;
  VideoPlayerController? get controller => _controller;

  Future<void> initializeNetworkPlayer({required String url}) async {
    _controller = VideoPlayerController.network(url)
      ..addListener(() => notifyListeners())
      ..setLooping(_loop);
    await _controller?.initialize();
    await 500.milliseconds.delay;
    notifyListeners();
  }

  bool _loop = true;
  bool get loop => _loop;

  void willLoop(loop) {
    _loop = loop;
    notifyListeners();
  }

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  void willMute(mute) {
    _isMuted = mute;
    mute ? _controller?.setVolume(0) : _controller?.setVolume(1);
    notifyListeners();
  }

  bool _isVideoPaused = false;
  bool get isVideoPaused => _isVideoPaused;

  bool _isVideoPlaying = false;
  bool get isVideoPlaying => _isVideoPlaying;

  Future<void> videoInit() async {
    await 1.seconds.delay;
    _isVideoPaused = false;
    _isVideoPlaying = false;
    notifyListeners();
  }

  bool _isVideoLoading = false;
  bool get isVideoLoading => _isVideoLoading;

  void playVideo(play) {
    _isVideoPlaying = play;
    _isVideoPaused = !play;
    play ? _controller?.play() : _controller?.pause();
    notifyListeners();
  }
}
