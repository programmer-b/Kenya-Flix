import 'package:flutter/material.dart';
import 'package:kenyaflix/Components/kf_image_container_component.dart';
import 'package:kenyaflix/Provider/kf_provider.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

class KFHorrizontalImageListBuilderComponent extends StatefulWidget {
  const KFHorrizontalImageListBuilderComponent(
      {super.key, required this.urls, this.trending = false});

  final List<Map<String, String>> urls;
  final bool trending;

  @override
  State<KFHorrizontalImageListBuilderComponent> createState() =>
      _KFHorrizontalImageListBuilderComponentState();
}

class _KFHorrizontalImageListBuilderComponentState
    extends State<KFHorrizontalImageListBuilderComponent> {
  late List<Map<String, String>> urls;
  late bool trending;
  @override
  void initState() {
    super.initState();
    urls = widget.urls;
    trending = widget.trending;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KFProvider>(
      builder: (context, provider, child) {
       return  HorizontalList(
            itemCount: trending ? urls.length : 10,
            itemBuilder: (context, index) {
              final imageUrl = urls[index]['imageUrl'];
              final homeUrl = urls[index]['homeUrl'] ?? "";
              final urlImage = 'https:$imageUrl';
              return KFImageContainerComponent(
                urlImage: urlImage,
                homeUrl: homeUrl,
                trending: trending,
              );
            });
      },
    );
  }
}
