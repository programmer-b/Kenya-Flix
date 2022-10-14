import 'package:flutter/material.dart';

const kfAppbarComponentsDimen = EdgeInsets.only(left: 10, top: 20);
double kfTopSrollableImageHeightDimen(context) {
  final height = MediaQuery.of(context).size.height;
  return (30 / 100) * height;
}

const double defaultGenreImageHeightDimen = 150;
const double defaultGenreImageWidthDimen = 100;

const double trendingImageHeightDimen = 240;
const double trendingImageWidthDimen = 120;