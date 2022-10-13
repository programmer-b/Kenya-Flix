const kfContentLoadingError = "Oops! Cant Connect to Rock Flix 😭";

const dummyVideourl =
    "https://assets.mixkit.co/videos/preview/mixkit-group-of-friends-partying-happily-4640-large.mp4";
const kfAppName = "Rock flix";
const dummyMovieImageUrl = "https://i.goojara.to/mb_228_228238.jpg";
const kfAppLogoAsset = "assets/images/kenya_flix_logo.png";
const kfMoviesBaseUrl = "https://www.goojara.to/watch-movies";
const kfSeriesBaseUrl = "https://www.goojara.to/watch-series";

const List<Map<String, dynamic>> movies = [
  {
    "display_title": "Action",
    "genre": "action",
    "url": "$kfMoviesBaseUrl-genre-Action",
    "id": 0
  },

  {
    "display_title": "Mystery",
    "genre": "mystery",
    "url": "$kfMoviesBaseUrl-genre-News",
    "id": 16
  },

  {
    "display_title": "Biography",
    "genre": "biography",
    "url": "$kfMoviesBaseUrl-genre-Biography",
    "id": 3
  },
  {
    "display_title": "Comedy",
    "genre": "comedy",
    "url": "$kfMoviesBaseUrl-genre-Comedy",
    "id": 4
  },
  {
    "display_title": "Crime",
    "genre": "crime",
    "url": "$kfMoviesBaseUrl-genre-Crime",
    "id": 5
  },

  {
    "display_title": "Drama",
    "genre": "drama",
    "url": "$kfMoviesBaseUrl-genre-Drama",
    "id": 7
  },
  {
    "display_title": "Adventure",
    "genre": "adventure",
    "url": "$kfMoviesBaseUrl-genre-Adventure",
    "id": 1
  },
  {
    "display_title": "Thrillers",
    "genre": "thriller",
    "url": "$kfMoviesBaseUrl-genre-Thriller",
    "id": 23
  },
  {
    "display_title": "Family",
    "genre": "family",
    "url": "$kfMoviesBaseUrl-genre-Family",
    "id": 8
  },

  {
    "display_title": "Animations",
    "genre": "animation",
    "url": "$kfMoviesBaseUrl-genre-Animation",
    "id": 2
  },
  {
    "display_title": "Fantasy",
    "genre": "fantasy",
    "url": "$kfMoviesBaseUrl-genre-Fantasy",
    "id": 9
  },
  {
    "display_title": "Film-Noir",
    "genre": "action",
    "url": "$kfMoviesBaseUrl-genre-Film-Noir",
    "id": 10
  },
  // {
  //   "display_title": "Game-Show",
  //   "genre": "game-show",
  //   "url": "$kfMoviesBaseUrl-genre-Game-Show",
  //   "id": 11
  // },
  {
    "display_title": "History",
    "genre": "history",
    "url": "$kfMoviesBaseUrl-genre-History",
    "id": 12
  },
  {
    "display_title": "Horror",
    "genre": "horror",
    "url": "$kfMoviesBaseUrl-genre-Horror",
    "id": 13
  },

  {
    "display_title": "Musical",
    "genre": "musical",
    "url": "$kfMoviesBaseUrl-genre-Musical",
    "id": 15
  },
  {
    "display_title": "Documentary",
    "genre": "documentary",
    "url": "$kfMoviesBaseUrl-genre-Documentary",
    "id": 6
  },

  {
    "display_title": "News",
    "genre": "news",
    "url": "$kfMoviesBaseUrl-genre-News",
    "id": 17
  },
  // {
  //   "display_title": "Reality TV",
  //   "genre": "reality-tv",
  //   "url": "$kfMoviesBaseUrl-genre-Reality-TV",
  //   "id": 18
  // },
  {
    "display_title": "Romance",
    "genre": "romance",
    "url": "$kfMoviesBaseUrl-genre-Romance",
    "id": 19
  },
  {
    "display_title": "Sci-fi",
    "genre": "sci-fi",
    "url": "$kfMoviesBaseUrl-genre-Sci-Fi",
    "id": 20
  },
  {
    "display_title": "Sports",
    "genre": "sport",
    "url": "$kfMoviesBaseUrl-genre-Sport",
    "id": 21
  },
  // {
  //   "display_title": "Talk Show",
  //   "genre": "talk-show",
  //   "url": "$kfMoviesBaseUrl-genre-Talk-Show",
  //   "id": 22
  // },

  {
    "display_title": "War",
    "genre": "war",
    "url": "$kfMoviesBaseUrl-genre-War",
    "id": 24
  },
  {
    "display_title": "Music",
    "genre": "music",
    "url": "$kfMoviesBaseUrl-genre-Music",
    "id": 14
  },
  {
    "display_title": "Western",
    "genre": "western",
    "url": "$kfMoviesBaseUrl-genre-Western",
    "id": 25
  },
  {
    "display_title": "Adults",
    "genre": "adult",
    "url": "$kfMoviesBaseUrl-genre-Adult",
    "id": 26
  },
];

const List<Map<String, dynamic>> series = [
  {
    "display_title": "Action",
    "genre": "action",
    "url": "$kfSeriesBaseUrl-genre-Action",
    "id": 27
  },
  {
    "display_title": "Adventure",
    "genre": "adventure",
    "url": "$kfSeriesBaseUrl-genre-Adventure",
    "id": 28
  },
  {
    "display_title": "Animations",
    "genre": "animation",
    "url": "$kfSeriesBaseUrl-genre-Animation",
    "id": 29
  },
  {
    "display_title": "Biography",
    "genre": "biography",
    "url": "$kfSeriesBaseUrl-genre-Biography",
    "id": 30
  },
  {
    "display_title": "Comedy",
    "genre": "comedy",
    "url": "$kfSeriesBaseUrl-genre-Comedy",
    "id": 31
  },
  {
    "display_title": "Crime",
    "genre": "crime",
    "url": "$kfSeriesBaseUrl-genre-Crime",
    "id": 32
  },
  {
    "display_title": "Documentary",
    "genre": "documentary",
    "url": "$kfSeriesBaseUrl-genre-Documentary",
    "id": 33
  },
  {
    "display_title": "Drama",
    "genre": "drama",
    "url": "$kfSeriesBaseUrl-genre-Drama",
    "id": 34
  },
  {
    "display_title": "Family",
    "genre": "family",
    "url": "$kfSeriesBaseUrl-genre-Family",
    "id": 35
  },
  {
    "display_title": "Fantasy",
    "genre": "fantasy",
    "url": "$kfSeriesBaseUrl-genre-Fantasy",
    "id": 36
  },

  {
    "display_title": "Game-Show",
    "genre": "game-show",
    "url": "$kfSeriesBaseUrl-genre-Game-Show",
    "id": 38
  },
  {
    "display_title": "History",
    "genre": "history",
    "url": "$kfSeriesBaseUrl-genre-History",
    "id": 39
  },
  {
    "display_title": "Horror",
    "genre": "horror",
    "url": "$kfSeriesBaseUrl-genre-Horror",
    "id": 40
  },
  {
    "display_title": "Music",
    "genre": "music",
    "url": "$kfSeriesBaseUrl-genre-Music",
    "id": 41
  },
  {
    "display_title": "Musical",
    "genre": "musical",
    "url": "$kfSeriesBaseUrl-genre-Musical",
    "id": 42
  },
  {
    "display_title": "Mystery",
    "genre": "mystery",
    "url": "$kfSeriesBaseUrl-genre-News",
    "id": 43
  },
  {
    "display_title": "News",
    "genre": "news",
    "url": "$kfSeriesBaseUrl-genre-News",
    "id": 44
  },
  {
    "display_title": "Reality TV",
    "genre": "reality-tv",
    "url": "$kfSeriesBaseUrl-genre-Reality-TV",
    "id": 45
  },
  {
    "display_title": "Romance",
    "genre": "romance",
    "url": "$kfSeriesBaseUrl-genre-Romance",
    "id": 46
  },
  {
    "display_title": "Sci-fi",
    "genre": "sci-fi",
    "url": "$kfSeriesBaseUrl-genre-Sci-Fi",
    "id": 47
  },
  {
    "display_title": "Sports",
    "genre": "sport",
    "url": "$kfSeriesBaseUrl-genre-Sport",
    "id": 48
  },
  {
    "display_title": "Talk Show",
    "genre": "talk-show",
    "url": "$kfSeriesBaseUrl-genre-Talk-Show",
    "id": 49
  },
  {
    "display_title": "Thrillers",
    "genre": "thriller",
    "url": "$kfSeriesBaseUrl-genre-Thriller",
    "id": 50
  },
  {
    "display_title": "War",
    "genre": "war",
    "url": "$kfSeriesBaseUrl-genre-War",
    "id": 51
  },
  {
    "display_title": "Western",
    "genre": "western",
    "url": "$kfSeriesBaseUrl-genre-Western",
    "id": 52
  },

];


  final List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'Film-Noir',
    'Game-Show',
    'History',
    'Horror',
    'Music',
    'Musical',
    'Mystery',
    'News',
    'Reality-TV',
    'Romance',
    'Sci-Fi',
    'Sport',
    'Talk-Show',
    'Thriller',
    'War',
    'Western',
    'Adult'
  ];