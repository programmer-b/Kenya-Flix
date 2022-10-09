import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:kenyaflix/Commons/KFVideoPlayerConfigurations.dart';

class KFVideoPlayerScreen extends StatefulWidget {
  const KFVideoPlayerScreen(
      {Key? key,
      required this.betterPlayerDataSource,
      required this.goBackWidget,
      required this.title})
      : super(key: key);
  final BetterPlayerDataSource betterPlayerDataSource;
  final Widget goBackWidget;
  final String title;

  @override
  State<KFVideoPlayerScreen> createState() => _KFVideoPlayerScreenState();
}

class _KFVideoPlayerScreenState extends State<KFVideoPlayerScreen> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    enterFullScreen();
    setOrientationLandscape();
    _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration(context),
        betterPlayerDataSource: widget.betterPlayerDataSource);
  }

  @override
  void dispose() {
    exitFullScreen();
    setOrientationPortrait();
    _betterPlayerController.dispose();
    super.dispose();
  }

  bool automaticallyImplyLeading = false;
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        automaticallyImplyLeading = false;
      } else {
        automaticallyImplyLeading = true;
      }
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: BetterPlayer(controller: _betterPlayerController),
      );
    });
  }
}
