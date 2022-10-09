import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:kenyaflix/Provider/KFProvider.dart';
import 'package:kenyaflix/Screens/KFVideoPlayerScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KFProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        "https://go.wootly.ch/dash?source=web&id=2a433898c7c06921cd1aff16fa2f21b29c48e58a&sig=3DehfA6E6M55Jr-0BSKPCw&expire=1665326813&ofs=11&usr=170024"
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter better player example"),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () => KFVideoPlayerScreen(
                title: 'Better player example',
                      betterPlayerDataSource: betterPlayerDataSource, goBackWidget: const MyHomePage(),)
                  .launch(context),
              child: const Text('Play video'))),
    );
  }
}
