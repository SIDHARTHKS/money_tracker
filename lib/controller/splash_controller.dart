import 'package:get/get.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/shared_pref.dart';
import '../helper/single_app.dart';

class SplashController extends AppBaseController {
  final MyApplication myApplication = Get.find<MyApplication>();
  SharedPreferenceHelper? _preference;

  Future<int> fetchUserProfile() async {
    _preference = myApplication.preferenceHelper;
    appLog(_preference!.getString(userNameKey));
    bool isLoggedIn = (myApp.preferenceHelper != null &&
        myApp.preferenceHelper!.getString(userNameKey).isNotEmpty);

    if (isLoggedIn) {
      return 1;
    }
    return 2;
  }
}
