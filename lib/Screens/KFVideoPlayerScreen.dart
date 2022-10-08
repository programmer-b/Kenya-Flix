import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/commons.dart';
import 'package:kenyaflix/Components/components.dart';
import 'package:kenyaflix/Provider/KFVideoProvider.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class KFVideoPlayerScreen extends StatefulWidget {
  const KFVideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<KFVideoPlayerScreen> createState() => _KFVideoPlayerScreenState();
}

class _KFVideoPlayerScreenState extends State<KFVideoPlayerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context.read<KFVideoProvider>().controller?.dispose();
  }

  Future<File?> pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    return File(result.files.single.path ?? '');
  }

  afterBuildLayout() {}

  Future<void> init() async {
    await 1.seconds.delay;
    if (mounted) {
      context
          .read<KFVideoProvider>()
          .initializeNetworkPlayer(url: dummyVideoUrl);
      context.read<KFVideoProvider>().playVideo(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<KFVideoProvider>().escapeVideoPlayerScreen(context);
        return false;
      },
      child: Consumer<KFVideoProvider>(builder: (context, provider, child) {
        final controller = provider.controller;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              onPressed: () => provider.escapeVideoPlayerScreen(context),
            ),
          ),
          body: Column(
            children: [
              const VideoPlayerComponent(),
              32.height,
              if (controller != null && controller.value.isInitialized)
                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      onPressed: () => provider.willMute(!provider.isMuted),
                      icon: Icon(
                        provider.isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                    )),
              32.height,
              FloatingActionButton(
                  heroTag: const Text('Play | Pause'),
                  child: provider.isVideoPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onPressed: () async {
                    provider.playVideo(!provider.isVideoPlaying);
                  }),
            ],
          ),
        );
      }),
    );
  }
}
