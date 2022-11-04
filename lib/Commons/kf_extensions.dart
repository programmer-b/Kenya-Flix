import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

extension GetConstraits on Map<String, dynamic> {
  double getWidth() {
    return this["width"];
  }

  double getHeight() {
    return this["height"];
  }
}

extension IsNumeric on String {
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}

extension PowerString on String {
  String smallSentence() {
    if (length > 30) {
      return '${substring(0, 30)}...';
    } else {
      return this;
    }
  }

  String firstFewWords() {
    int startIndex = 0, indexOfSpace = 0;

    for (int i = 0; i < 6; i++) {
      indexOfSpace = indexOf(' ', startIndex);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return this;
      }
      startIndex = indexOfSpace + 1;
    }

    return '${substring(0, indexOfSpace)}...';
  }
}

extension NumberOfWords on String {
  int numberOfWords() {
    return split(' ').length;
  }
}

extension IsOk on Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

extension GetConstraints on Map<String, dynamic> {
  double get height {
    return this["height"];
  }

  double get width {
    return this["width"];
  }
}

extension SnapshotLoaded on AsyncSnapshot {
  bool get loaded {
    return connectionState == ConnectionState.done;
  }
}
