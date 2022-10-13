import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class KFProvider with ChangeNotifier {
  /// Here is a boolean value indicating when the app is loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// change loading state for the app
  void load() {
    _isLoading = true;
    notifyListeners();
  }

  /// A method to update the category in the home fragment
  int _selectedHomeCategory = 0;
  int get selectedHomeCategory => _selectedHomeCategory;

  void updateHomeCategory(index) {
    _selectedHomeCategory = index;
    notifyListeners();
  }

  String _moviesData = "";
  String get moviesData => _moviesData;

  String _seriesData = "";
  String get seriesData => _seriesData;

  void updateMoviesData(String moviesData) {
    _moviesData = moviesData;
    if (moviesData != '') stractureMoviesData(moviesData);

    notifyListeners();
  }

  void stractureMoviesData(String moviesData) {
    var document = parse(moviesData);
    var recentTitleImages =
        document.getElementsByClassName('dflex')[0].children;
    for (int i = 0; i < recentTitleImages.length; i++) {
       _moviesTopCarouselUrls.insert(
          i,
          recentTitleImages[i]
              .getElementsByTagName('img')[0]
              .attributes['data-src']
              .toString());
    }
  }

  void updateSeriesData(String seriesData) {
    _seriesData = seriesData;
    notifyListeners();
  }



  List<String> _moviesTopCarouselUrls = [];
  List<String> get moviesTopCarouselUrls => _moviesTopCarouselUrls;

  List<String> _seriesTopCarouselUrls = [];
  List<String> get seriesTopCarouselUrls => _seriesTopCarouselUrls;

  bool _contentLoadError = false;
  bool get contentLoadError => _contentLoadError;

  void setError(error) {
    _contentLoadError = error;
    notifyListeners();
  }
}
