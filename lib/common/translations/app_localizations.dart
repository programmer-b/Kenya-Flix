import 'package:flutter/widgets.dart';
import 'package:flutter_translation/flutter_translation.dart';
import 'package:kenyaflix/common/translations/app_languages.dart';
// import 'package:kenyaflix/common/translations/app_translator.dart';

import 'package:kenyaflix/depen_injec/get_it.dart';

class AppLocalizations extends ILocalizations<ITranslator> {
  AppLocalizations.singleton(Locale locale) : super(locale);

  @override
  ITranslator getTranslator(String languageCode) {
    return getIt<AppLanguages>().findByCode(languageCode).translator;
  }
}

class AppLocalizationsDelegate
    extends ILocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  List<LanguageEntity> getLanguages() => getIt<AppLanguages>().languages;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations.singleton(locale);
  }
}
