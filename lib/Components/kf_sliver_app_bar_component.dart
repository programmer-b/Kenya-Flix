import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';

class KFSliverAppBarComponent extends StatelessWidget {
  const KFSliverAppBarComponent(
      {super.key,
      this.flexibleSpace,
      this.pinned = false,
      this.snap = false,
      this.floating = false,
      this.expandedHeight,
      this.automaticallyImplyLeading = true});

  final Widget? flexibleSpace;
  final bool pinned;
  final bool snap;
  final bool floating;
  final double? expandedHeight;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: const IconThemeData(color: Colors.white60),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 37)),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
              size: 37,
            ))
      ],
      backgroundColor: kfAppBarBgColor,
      pinned: pinned,
      snap: snap,
      floating: floating,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }
}
