import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kenyaflix/Components/kf_movie_detail_action_button_builder.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

class KFBuildDetailsActionBar extends StatelessWidget {
  const KFBuildDetailsActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<KFProvider>(builder: (context, value, child) {
      final List<Widget> actions = _actions(value);

      if (value.kfTMDBSearchVideoResults == null) {
        log("Video data is actually not available");
        actions.removeRange(1, 2);
      }

      return HorizontalList(
          itemCount: actions.length,
          itemBuilder: (context, index) => actions[index]);
    });
  }

  List<Widget> _actions(KFProvider value) => [
        KFMovieDetailActionButtonBuilder(
            onTap: () {}, icon: MdiIcons.playOutline, text: "Trailer"),
        6.width,
        KFMovieDetailActionButtonBuilder(
            onTap: () {}, icon: Icons.add_outlined, text: "Watchlist"),
        6.width,
        KFMovieDetailActionButtonBuilder(
            onTap: () {}, icon: Icons.more_vert_sharp, text: "More")
      ];
}