import 'package:flutter/material.dart';
import 'package:kenyaflix/utils/constants.dart';

// ignore: must_be_immutable
class BottomNavigationItem extends StatelessWidget {
  final Icon icon;
  final double iconSize;
  final Function? onPressed;
  Color? color;

  BottomNavigationItem({
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: iconSize,
        color: color ?? kInactiveButtonColor,
        onPressed: () => onPressed!(),
        icon: icon);
  }
}
