import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import '../view/widget/common_widget.dart';
import 'app_string.dart';
import 'color_helper.dart';
import 'core/environment/env.dart';
import 'enum.dart';
import 'single_app.dart';

void showSuccessSnackbar({
  String? title,
  required String message,
  Duration? duration = const Duration(seconds: 10),
}) {
  title ??= success.tr;
  showCustomSnackbar(
    title: title,
    message: message,
    duration: duration,
    isSuccess: true,
  );
}

void showErrorSnackbar({
  String? title,
  required String message,
  Duration? duration = const Duration(seconds: 10),
}) {
  title ??= failureTitle.tr;
  showCustomSnackbar(
    title: title,
    message: message,
    duration: duration,
    isSuccess: false,
  );
}

void showCustomSnackbar({
  required String title,
  required String message,
  bool isSuccess = true,
  Duration? duration = const Duration(seconds: 2),
  VoidCallback? closePressed,
}) {
  Get.snackbar(
    title,
    colorText: AppColorHelper().primaryTextColor,
    message,
    backgroundColor:
        isSuccess ? AppColorHelper().cardColor : AppColorHelper().cardColor,
    messageText: appText(
      message,
      color: AppColorHelper().primaryTextColor,
    ),
    duration: duration,
    snackPosition: SnackPosition.TOP,
    icon: isSuccess
        ? Icon(Icons.check, color: AppColorHelper().unreadNotification)
        : Icon(
            Icons.error_outline_rounded,
            color: AppColorHelper().errorColor,
          ),
    shouldIconPulse: false,
    borderRadius: 20.0,
    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    overlayColor: Colors.transparent,
    barBlur: 5,
    forwardAnimationCurve: Curves.linearToEaseOut,
    reverseAnimationCurve: Curves.linearToEaseOut,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
    dismissDirection: DismissDirection.horizontal,
    mainButton: TextButton(
      onPressed: () {
        Get.back();
        closePressed ?? ();
      },
      child: appText(close.tr,
          fontSize: 16,
          color: AppColorHelper().textColor,
          fontWeight: FontWeight.w800),
    ),
  );
}

void showPopupDialog({
  required String title,
  required String content,
  String? positiveButtonText,
  String? negativeButtonText,
  bool showNegativeButton = true,
  VoidCallback? onPositivePressed,
  VoidCallback? onNegativePressed,
}) {
  positiveButtonText ??= ok.tr;
  negativeButtonText ??= cancel.tr;
  Get.defaultDialog(
    title: title,
    barrierDismissible: false,
    content: Text(content),
    textConfirm: positiveButtonText,
    textCancel: showNegativeButton ? negativeButtonText : null,
    onConfirm: onPositivePressed ?? () {},
    onCancel: showNegativeButton ? onNegativePressed : null,
  );
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? positiveButtonText,
  String? negativeButtonText,
  bool showNegative = false,
  Function()? onPositiveButtonPressed,
  Function()? onNegativeButtonPressed,
}) {
  positiveButtonText ??= ok.tr;
  negativeButtonText ??= cancel.tr;
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        Visibility(
          visible: showNegative,
          child: ElevatedButton(
            onPressed: onNegativeButtonPressed ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text(negativeButtonText!),
          ),
        ),
        ElevatedButton(
          onPressed: onPositiveButtonPressed ??
              () {
                Navigator.of(context).pop();
              },
          child: Text(positiveButtonText!),
        ),
      ],
    ),
  );
}

void appLog(dynamic value, {Logging logging = Logging.debug}) {
  if (AppEnvironment.config.enableLogs) {
    switch (logging) {
      case Logging.debug:
        misDebugMessage(value);
        break;
      case Logging.info:
        misInfoMessage(value);
        break;
      case Logging.warning:
        misWarningMessage(value);
        break;
      case Logging.error:
        misErrorMessage(value);
        break;
    }
  }
}

void toastMessage(String message) {
  // Fluttertoast.showToast(msg: message);
}

void misDebugMessage(dynamic value) {
  Get.find<MyApplication>().logger.d('Logger Debug: $value');
}

void misInfoMessage(dynamic value) {
  Get.find<MyApplication>().logger.i('Logger Info: $value');
}

void misErrorMessage(dynamic value) {
  Get.find<MyApplication>().logger.e('Logger Error: $value');
}

void misWarningMessage(dynamic value) {
  Get.find<MyApplication>().logger.w('Logger Warning: $value');
}
