import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tracker/helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/app_message.dart';

class LandingController extends AppBaseController {
  // Text controller
  TextEditingController userController = TextEditingController();
  final FocusNode userFocusNode = FocusNode();

  // Validation error
  var userError = RxString('');

  // user
  var rxUserName = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    final savedName = myApp.preferenceHelper!.getString(userNameKey) ?? '';
    rxUserName.value = savedName;
    if (savedName.isNotEmpty) {
      appLog("Loaded username: $savedName");
    }
  }

  bool validateUser() {
    final text = userController.text.trim();
    if (text.isEmpty) {
      userError.value = "Name cannot be empty";
      return false;
    } else if (text.length < 3) {
      userError.value = "Name must be at least 3 characters";
      return false;
    }
    userError.value = '';
    return true;
  }

  Future<void> savePreference() async {
    final name = userController.text.trim();
    if (!validateUser()) return;
    await myApp.preferenceHelper!.setString(userNameKey, name);
    rxUserName.value = name;
    appLog("Saved username: $name");
    final storedName = myApp.preferenceHelper!.getString(userNameKey) ?? '';
    appLog("Confirmed stored in prefs: $storedName");
  }
}
