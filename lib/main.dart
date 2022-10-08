import 'package:flutter/material.dart';
import 'package:kenyaflix/Provider/KFVideoProvider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => KFVideoProvider()),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerProvider = Provider.of<KFVideoProvider>(context);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => videoPlayerProvider.launchVideoPlayerScreen(context),
          child: const Text('Play a video'),
        ),
      ),
    );
  }
}
