import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class KFBrowserComponent extends StatefulWidget {
  const KFBrowserComponent({Key? key}) : super(key: key);

  @override
  State<KFBrowserComponent> createState() => _KFBrowserComponentState();
}

class _KFBrowserComponentState extends State<KFBrowserComponent> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [_sliverAppBar()],
    );
  }

  Widget _sliverAppBar() => SliverAppBar(
          title: Row(
        children: [_categoryDropdown(), _genreDropdown()],
      ));
  Widget _categoryDropdown() => DropdownSearch<String>();
  Widget _genreDropdown() => DropdownSearch<String>();
}
