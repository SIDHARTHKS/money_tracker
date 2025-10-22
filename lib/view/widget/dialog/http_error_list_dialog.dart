import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/app_string.dart';
import '../../../../helper/color_helper.dart';
import '../../../helper/core/base/app_base_response.dart';
import '../../../helper/core/environment/env.dart';
import '../../../helper/sizer.dart';
import '../common_widget.dart';
import '../text/app_text.dart';

class HttpErrorListDialog extends StatelessWidget {
  final List<ResponseError> errors;
  const HttpErrorListDialog({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) => _widgetView();

  AlertDialog _widgetView() => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        backgroundColor: AppColorHelper().dialogBackgroundColor,
        content: StatefulBuilder(
          builder: (context, setState) => SizedBox.fromSize(
            // width: Get.width,
            // height: Get.height * .19,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  headlineText(exceptionMsg,
                      color: AppColorHelper().primaryTextColor),
                  divider(
                      color:
                          AppColorHelper().dividerColor.withValues(alpha: 0.2)),
                  Row(
                    children: [
                      iconWidget(Icons.error,
                          color: AppColorHelper().errorColor),
                      width(20),
                      Expanded(
                        child: bodyText('${error.tr} : ${errors[0].message}',
                            color: AppColorHelper().primaryTextColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buttonContainer(
                      height: 38,
                      width: 120,
                      appText(close.tr,
                          color: AppColorHelper().textColor,
                          fontWeight: FontWeight.w500),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  ListView _listView() => ListView.separated(
        itemBuilder: ((context, index) {
          ResponseError item = errors[index];
          return AppEnvironment.isProdMode()
              ? Row(
                  children: [
                    iconWidget(Icons.error, color: AppColorHelper().errorColor),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: labelText(item.message ?? ' ',
                          color: AppColorHelper().primaryTextColor),
                    ),
                  ],
                )
              : ListTile(
                  leading:
                      Icon(Icons.error, color: AppColorHelper().errorColor),
                  // title: bodyText('${errorCode.tr} : ${item.code ?? ' '}',
                  //     color: AppColorHelper().primaryTextColor),
                  // subtitle: labelText(
                  //     '${errorMessage.tr} : ${item.message ?? ' '}',
                  //     color: AppColorHelper().primaryTextColor),
                  title: bodyText('${error.tr} : ${item.message ?? ' '}',
                      color: AppColorHelper().primaryTextColor),
                );
        }),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: errors.length,
      );
}
