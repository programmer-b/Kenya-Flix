import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? openAd;

Future<void> loadAd() async {
  await AppOpenAd.load(
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            log('Ad loaded successfully ');
            openAd = ad;
            ad.show();
            openAd!.show;
          },
          onAdFailedToLoad: (error) => log('Ad failed to load: $error')),
      // ca-app-pub-5988017258715205/2185598767
      adUnitId: 'ca-app-pub-5988017258715205/2185598767',
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await loadAd();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.dark().copyWith(
            platform: TargetPlatform.iOS,
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kPrimaryColor,
          ),
          home: HomeScreen(
            key: kHomeScreenKey,
          ),
        );
      },
    );
  }
}
