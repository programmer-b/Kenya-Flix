import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

part './KFStrings.dart';

///Fading circle spinKit can be called from anywhere that has context
Widget fadingCircleSpinKit(context,
    {final Color? color, final Color? evenColor, final Color? oddColor}) {
  return SpinKitFadingCircle(
    color: color,
  );
}
