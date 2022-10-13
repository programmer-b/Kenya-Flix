import 'package:flutter/material.dart';
import 'package:kenyaflix/Commons/kf_colors.dart';
import 'package:kenyaflix/Commons/kf_menus.dart';
import 'package:kenyaflix/Components/kf_app_bar_menu_component.dart';
import 'package:kenyaflix/Components/kf_error_screen_component.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:kenyaflix/Utils/kf_utils.dart';
import 'package:provider/provider.dart';


class KFHomeFragment extends StatefulWidget {
  const KFHomeFragment({Key? key}) : super(key: key);

  @override
  State<KFHomeFragment> createState() => _KFHomeFragmentState();
}

class _KFHomeFragmentState extends State<KFHomeFragment> {
  late ScrollController? controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    init();
  }

  Future<void> init() async {
    final provider = context.read<KFProvider>();
    await fetchDataAndStoreData(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KFProvider>(builder: (context, provider, child) {
      return provider.contentLoadError
          ? const KFErrorScreenComponent()
          : CustomScrollView(
              controller: controller,
              slivers: <Widget>[
                _silverAppbarActions(controller),
                kfTopAppBarMenu[provider.selectedHomeCategory]['widget']
              ],
            );
    });
  }

  Widget _silverAppbarActions(ScrollController? controller) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
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
      pinned: false,
      snap: false,
      floating: true,
      expandedHeight: 90,
      flexibleSpace: Padding(
        padding: EdgeInsets.zero,
        child: FlexibleSpaceBar(
          title: KFAppBarMenuComponent(controller: controller),
          titlePadding: EdgeInsets.zero,
          collapseMode: CollapseMode.none,
        ),
      ),
    );
  }
}
