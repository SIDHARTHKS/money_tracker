import 'package:tracker/model/login_model.dart';

import '../helper/app_message.dart';
import '../helper/core/base/app_base_service.dart';
import '../helper/enum.dart';

class AuthService extends AppBaseService {
  // Future<AppBaseResponse?>? fetchSupportedVersion() async =>
  //     await httpService.getService(
  //       endpoint: getSupportedVersionApiEndpoint(),
  //       headers: await getHeaders(authorization: false),
  //       fromJsonT: (json) => DeviceSupportModel.fromJson(json),
  //     );

  Future<Map<String, dynamic>?> login(LoginRequest request) async {
    final response = await httpService.postServiceReturningMap(
      endpoint: getLoginApiEndpoint(
          request.grantType!, request.username!, request.password!),
      headers: await getHeaders(
        authorization: true,
        token: true,
        xCorrelationId: false,
        sid: false,
      ),
      data: request.toJson(),
      ignoreError: false, // true if you want silent handling during refresh
    );

    if (response != null) {
      if (response.containsKey('access_token')) {
        appLog('Login successful, token: ${response['access_token']}',
            logging: Logging.info);
        return response;
      } else if (response.containsKey('error_description')) {
        appLog(
            'Login failed: ${response['error']}: ${response['error_description']}',
            logging: Logging.error);
        return response;
      }
    }

    appLog('Login returned null response.', logging: Logging.warning);
    return null;
  }

  Future<Map<String, dynamic>?> refresh(RefreshRequest request) async {
    final response = await httpService.postServiceReturningMap(
      endpoint:
          getRefreshApiEndpoint(request.grantType!, request.refershToken!),
      headers: await getHeaders(
        authorization: false,
        token: true,
        xCorrelationId: false,
        sid: false,
      ),
      data: request.toJson(),
      retryOnUnauthorized: false,
      ignoreError: true, // or true if you want silent handling
    );

    if (response != null) {
      if (response.containsKey('access_token')) {
        final token = response['access_token'] as String;
        appLog('Login successful, token: $token', logging: Logging.info);
        return response;
      } else if (response.containsKey('error_description')) {
        appLog(
            'Login failed: ${response['error']}: ${response['error_description']}',
            logging: Logging.error);
        return null;
      }
    }

    appLog('Login returned null response.', logging: Logging.warning);
    return null;
  }

  // Future<bool> updatePassword(LoginRequest request) async {
  //   var response = await httpService.postService<LoginResponse>(
  //     endpoint: getUpdatePassApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => LoginResponse.fromJson(json),
  //   );
  //   if (response != null && response.success != null) {
  //     return response.success!;
  //   }
  //   return false;
  // }

  // Future<bool> changePassword(
  //     ChangePasswordRequest request, String token) async {
  //   var response = await httpService.postService<LoginResponse>(
  //     endpoint: getChangePassApiEndpoint(token),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => json,
  //   );
  //   if (response != null && response.success != null) {
  //     return response.success!;
  //   }
  //   return false;
  // }

  // Future<OtpResponse?> getOtp(OtpRequest request) async {
  //   var response = await httpService.postService<OtpResponse>(
  //     endpoint: getOtpApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => OtpResponse.fromJson(json),
  //   );
  //   if (response != null && response.data != null) {
  //     return response.data;
  //   }
  //   return null;
  // }

  // Future<AppBaseResponse?> verifyOtp(VerifyOtpRequest request) async {
  //   var response = await httpService.postService<AppBaseResponse>(
  //     endpoint: getverifyOtpApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) =>
  //         AppBaseResponse.fromJson(json, (data) => OtpResponse.fromJson(data)),
  //   );

  //   return response;
  // }
}
