import 'package:flutter/material.dart';
import 'package:kenyaflix/domain/entities/movie_entity.dart';
import 'package:kenyaflix/presentation/journeys/home/movie_tabbed/movie_tabbed_card_widget.dart';
import 'package:responsive_size/responsive_size.dart';

import 'package:kenyaflix/common/constants/size_constants.dart';

class MoviesTabbedList extends StatelessWidget {
  final List<MovieEntity> movies;

  const MoviesTabbedList({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Sizes.s6.h,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, index) {
          return SizedBox(width: Sizes.s14.w);
        },
        itemBuilder: (_, index) {
          return MovieTabbedCardWidget(
            movieId: movies[index].id,
            title: movies[index].title,
            posterPath: movies[index].posterPath,
          );
        },
      ),
    );
  }
}
