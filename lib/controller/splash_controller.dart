import 'package:get/get.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/shared_pref.dart';
import '../helper/single_app.dart';
import '../model/login_model.dart';
import '../service/auth_service.dart';

class SplashController extends AppBaseController {
  final AuthService _authService = Get.find<AuthService>();

  final MyApplication myApplication = Get.find<MyApplication>();
  SharedPreferenceHelper? _preference;
  var rxUpdateRequired = false.obs;

  Future<int> fetchUserProfile() async {
    _preference = myApplication.preferenceHelper;
    appLog(myApplication.preferenceHelper!.getString(userIdKey));

    await Future.delayed(const Duration(milliseconds: 1500));

    bool isLoggedIn = myApp.preferenceHelper != null
        ? (myApp.preferenceHelper!.getBool(rememberMeKey) &&
            myApp.preferenceHelper!.getString(emailKey).isNotEmpty)
        : false;

    if (isLoggedIn) {
      if (myApp.preferenceHelper == null) {
        return 2;
      } else {
        // await fetchCompanies().then((success) {
        //   if (success) {
        //     fetchLocations();
        //   }
        // });
        return 1;
      }
    }
    return 2;
  }

  // Future<bool> fetchCompanies() async {
  //   try {
  //     if (myApp.preferenceHelper != null) {
  //       String id = myApp.preferenceHelper!.getString(personIdKey);
  //       if (id.isNotEmpty) {
  //         List<CompanyDropdownResponse>? response =
  //             await _homeService.getCompanyDropdown(
  //                 CompanyDropdownRequest(attribute1: "userID", value1: id));
  //         if (response != null) {
  //           rxCompanyResponse(response);
  //           // await setDefaultLocation();
  //           return true;
  //         }
  //       }
  //     } else {
  //       showErrorSnackbar(
  //           message: "Unable To Fetch Companies. Please Login Again");
  //       navigateToAndRemoveAll(loginPageRoute);
  //     }
  //   } catch (e) {
  //     appLog('$exceptionMsg $e', logging: Logging.error);
  //   } finally {}
  //   return false;
  // }

  // Future<bool> fetchLocations() async {
  //   try {
  //     if (myApp.preferenceHelper != null) {
  //       String id = myApp.preferenceHelper!.getString(personIdKey);
  //       if (id.isNotEmpty) {
  //         List<DropdownResponse>? response =
  //             await _homeService.getLocationDropdown(
  //                 LocationDropdownRequest(attribute1: "userID", value1: id));
  //         if (response != null) {
  //           rxLocationResponse(response);
  //           // await setDefaultLocation();
  //           return true;
  //         }
  //       }
  //     } else {
  //       showErrorSnackbar(
  //           message: "Unable To Fetch Locations. Please Login Again");
  //       navigateToAndRemoveAll(loginPageRoute);
  //     }
  //   } catch (e) {
  //     appLog('$exceptionMsg $e', logging: Logging.error);
  //   } finally {}
  //   return false;
  // }

  Future<void> resetPref() async {
    _preference!.remove(accessTokenKey);
    _preference!.remove(personKey);
    _preference!.remove(personCodeKey);
    _preference!.remove(passwordKey);
  }

  Future<bool> callrefresh() async {
    var response = await _authService.refresh(RefreshRequest(
        grantType: "refresh_token",
        refershToken:
            myApp.preferenceHelper!.getString(refreshTokenKey) ?? ""));
    if (response != null && response.containsKey("access_token")) {
      myApp.preferenceHelper!
          .setString(accessTokenKey, response['access_token'] ?? "");
      myApp.preferenceHelper!
          .setString(refreshTokenKey, response['refresh_token'] ?? "");
      myApp.preferenceHelper!.setString(sidKey, response['appssid'] ?? "");
      return true;
    } else {
      return false;
    }
  }
}
