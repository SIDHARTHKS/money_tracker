import 'package:get/get.dart';

import '../../app_string.dart';
import '../../deviceInfo.dart';
import '../../single_app.dart';
import 'http_service.dart';
import 'app_base_controller.dart';

class AppBaseService {
  late AppBaseController controller;

  final HttpService httpService = Get.find<HttpService>();

  getLoginApiEndpoint(String type, String username, String password) =>
      '/oauth/token?grant_type=$type&username=$username&password=$password';
  getRefreshApiEndpoint(String type, String token) =>
      '/oauth/token?grant_type=$type&refresh_token=$token';

  getCompanyDropdownApiEndpoint() => '/fetchcompanydropdown';
  getDropdownApiEndpoint() => '/fetchlocationdropdown';
  getTransactionsApiEndpoint() => '/fetchtransactionsummarydata';

  Future<Map<String, String>> getHeaders({
    bool contentType = true,
    bool authorization = true,
    bool xCorrelationId = true,
    bool deviceId = true,
    bool appId = true,
    bool sid = true,
    bool fbEid = false,
    bool token = false, // controls Bearer vs Basic
  }) async {
    final MyApplication misApp = Get.find<MyApplication>();
    if (misApp.preferenceHelper == null) {
      return {};
    }

    final Map<String, String> headers = {};
    String? authToken;
    String? sidValue;
    String? deviceIdValue;
    String? fbEidValue;
    String randomDigit = await DeviceUtil.generateRandomString();

    if (authorization) {
      authToken = misApp.preferenceHelper!.getString(accessTokenKey);
    }
    if (sid) {
      sidValue = misApp.preferenceHelper!.getString(sidKey);
    }
    if (deviceId) {
      deviceIdValue = misApp.preferenceHelper!.getString(deviceIdKey);
    }
    if (fbEid) {
      fbEidValue = misApp.preferenceHelper!.getString(fbEidKey);
    }

    if (contentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (authorization) {
      if (token) {
        // Basic auth, use your actual value here
        headers['Authorization'] =
            'Basic anVlbGlzdjJ0cG1vYmlsZTpBIzQyVjIzcmRATWJsU0w=';
      } else {
        headers['Authorization'] = 'Bearer ${authToken ?? ''}';
      }
    }

    if (xCorrelationId) {
      headers['X-Correlation-Id'] = 'S01${sidValue ?? ''}$randomDigit';
    }
    if (deviceId) {
      headers['DeviceID'] = deviceIdValue ?? '';
    }
    if (appId) {
      headers['AppID'] = 'S01';
    }
    if (sid) {
      headers['SID'] = sidValue ?? '';
    }
    if (fbEid) {
      headers['FBEID'] = fbEidValue ?? '';
    }

    return headers;
  }
}
