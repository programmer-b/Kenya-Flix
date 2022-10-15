import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Commons/kf_strings.dart';
import 'package:kenyaflix/Commons/kf_themes.dart';
import 'package:nb_utils/nb_utils.dart';

class KFPaginationComponent extends StatelessWidget {
  const KFPaginationComponent({
    super.key,
    required this.onPressedPrevButton,
    required this.onPressedNextButton,
    required this.currentPage,
  });

  final void Function()? onPressedPrevButton;
  final void Function()? onPressedNextButton;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Page $currentPage",
          style: boldTextStyle(color: kfPrimaryTextColor),
        ),
        Row(children: [
          ElevatedButton(
              style: kfButtonStyle(context),
              onPressed: onPressedPrevButton,
              child: Text(
                kfPrevButtonLabel,
                style: boldTextStyle(color: Colors.white),
              )),
          6.width,
          ElevatedButton(
              style: kfButtonStyle(context),
              onPressed: onPressedNextButton,
              child: Text(
                kfNextButtonLabel,
                style: boldTextStyle(color: Colors.white),
              ))
        ])
      ]),
    );
  }
}
