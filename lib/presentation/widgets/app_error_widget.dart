import 'package:flutter/material.dart';
import 'package:kenyaflix/common/translations/app_translator.dart';
import 'package:kenyaflix/presentation/widgets/primary_button.dart';
import 'package:responsive_size/responsive_size.dart';

import 'package:kenyaflix/common/constants/size_constants.dart';
import 'package:kenyaflix/common/utils/find_translator.dart';
import 'package:kenyaflix/domain/entities/app_error.dart';
import 'package:wiredash/wiredash.dart';

class AppErrorWidget extends StatelessWidget {
  final AppErrorType appErrorType;
  final dynamic Function()? retryFunction;

  const AppErrorWidget({
    Key? key,
    required this.appErrorType,
    required this.retryFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translator = Utils.findTranslator(context);
    return Padding(
      padding: EdgeInsets.all(Sizes.s32.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _getErrorMessage(translator),
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          ButtonBar(
            children: [
              PrimaryButton(
                text: translator.retry,
                onPressed: retryFunction,
              ),
              PrimaryButton(
                text: translator.reportError,
                onPressed: () => Wiredash.of(context).show(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(AppTranslator translator) {
    return appErrorType == AppErrorType.Network
        ? translator.checkYourConnection
        : translator.somethingWentWrong;
  }
}
