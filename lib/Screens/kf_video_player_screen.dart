import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/kf_provider.dart';

class KFVideoPlayerScreen extends StatefulWidget {
  const KFVideoPlayerScreen({
    Key? key,
    required this.masterUrl,
  }) : super(key: key);

  final Uri masterUrl;
  @override
  State<KFVideoPlayerScreen> createState() => _KFVideoPlayerScreenState();
}

class _KFVideoPlayerScreenState extends State<KFVideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero, () => context.read<KFProvider>().initMovieDetails());
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Video Player"),
        ),
        body: Text(widget.masterUrl.toString()),
      );
    });
  }
}
