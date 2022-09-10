import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translation/flutter_translation.dart';
import 'package:kenyaflix/common/translations/app_languages.dart';
import 'package:kenyaflix/common/translations/app_localizations.dart';

import 'package:kenyaflix/depen_injec/get_it.dart';
import 'package:kenyaflix/presentation/blocs/language_bloc/language_bloc.dart';
import 'package:kenyaflix/presentation/themes/app_colors.dart';
import 'package:kenyaflix/presentation/themes/text_themes.dart';
import 'package:kenyaflix/presentation/wiredash_app.dart';
import './journeys/home/home_screen.dart';

class MoviesApp extends StatefulWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  _MoviesAppState createState() => _MoviesAppState();
}

class _MoviesAppState extends State<MoviesApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late LanguageBloc _languageBloc;

  @override
  void initState() {
    super.initState();
    _languageBloc = getIt<LanguageBloc>();
  }

  @override
  void dispose() {
    _languageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _languageBloc,
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          if (state is LanguageLoadedState) {
            return WiredashApp(
              navigatorKey: _navigatorKey,
              locale: state.locale,
              child: MaterialApp(
                navigatorKey: _navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Movies App',
                theme: ThemeData(
                  primaryColor: AppColors.vulcan,
                  unselectedWidgetColor: AppColors.royalBlue,
                  scaffoldBackgroundColor: AppColors.vulcan,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: const AppBarTheme(elevation: 0),
                  textTheme: TextThemes.getTextTheme(), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.royalBlue),
                ),
                supportedLocales: getIt<AppLanguages>()
                    .languages
                    .map((lang) => lang.toLocale()),
                locale: state.locale,
                localizationsDelegates: [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                home: HomeScreen(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
