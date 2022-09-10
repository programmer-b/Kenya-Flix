import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translation/flutter_translation.dart';

import 'package:kenyaflix/common/translations/app_languages.dart';
import 'package:kenyaflix/depen_injec/get_it.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc()
      : super(LanguageLoadedState(
            getIt<AppLanguages>().defaultLanguage.toLocale()));

  Stream<LanguageState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is LanguageChangeEvent) {
      yield LanguageLoadedState(
          getIt<AppLanguages>().findByCode(event.languageCode).toLocale());
    }
  }
}
