import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Screens/kf_home_screen.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

import '../Commons/kf_functions.dart';
import '../Provider/kf_provider.dart';

class KFSplashScreen extends StatefulWidget {
  const KFSplashScreen({Key? key}) : super(key: key);

  @override
  State<KFSplashScreen> createState() => _KFSplashScreenState();
}

class _KFSplashScreenState extends State<KFSplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final provider = context.read<KFProvider>();
    provider.stracturePopularMoviesAndSeriesData();
    await fetchDataAndStoreData(provider);
  }

  Future<void> _ready() async {
    await 4.seconds.delay;
  }

  void launchToHomeScreen() {
    Future.delayed(
        Duration.zero,
        () => const KFHomeScreen().launch(context,
            pageRouteAnimation: PageRouteAnimation.Slide, isNewTask: true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _ready(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            launchToHomeScreen();
            return _loadingWidget();
          }
          return _loadingWidget();
        });
  }

  Widget _loadingWidget() => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(kfAppLogoAsset))),
            ),
            10.height,
            Text(
              kfAppName,
              style: boldTextStyle(size: 24, color: Colors.white),
            ),
          ],
        ).center().paddingSymmetric(vertical: 30),
      );
}
