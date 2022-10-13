import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Screens/kf_splash_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
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
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: kfScaffoldBackgroundColor
          ),
          home: const KFSplashScreen(),
        ),
      ),
    );
  }
}