import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';

ThemeData? kfMainTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kfScaffoldBackgroundColor);
ButtonStyle? kfButtonStyle(context) => ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.5);
      }
      return null; // Use the component's default.
    },
  ),
);
