import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Commons/kf_themes.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Screens/kf_splash_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  setOrientationPortrait();

  String storageLocation = (await getApplicationDocumentsDirectory()).path;
  await FastCachedImageConfig.init(
      path: storageLocation, clearCacheAfter: const Duration(days: 15));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: ChangeNotifierProvider(
        create: (context) => KFProvider(),
        child: MaterialApp(
          title: kfAppName,
          theme: kfMainTheme,
          home: const KFSplashScreen(),
        ),
      ),
    );
  }
}
