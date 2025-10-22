import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../model/login_model.dart';
import '../../../service/auth_service.dart';
import '../../../view/widget/dialog/http_error_list_dialog.dart';
import '../../app_message.dart';
import '../../app_string.dart';
import '../../deviceInfo.dart';
import '../../enum.dart';
import '../../navigation.dart';
import '../../route.dart' show loginPageRoute;
import '../../single_app.dart';
import '../environment/env.dart';
import 'app_base_response.dart';

class HttpService extends GetxService {
  final MyApplication myApplication = Get.find<MyApplication>();
  Future<dynamic> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('${AppEnvironment.config.baseApiurl}$endpoint');
    appLog('http GET: url:$url', logging: Logging.info);
    try {
      headers ??= await _getHeaders();
      appLog('http: headers:$headers', logging: Logging.info);
      final response = await http.get(url, headers: headers);
      appLog('http: response:${response.body}', logging: Logging.info);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('$exceptionMsg $e');
    }
  }

  Future<AppBaseResponse<T>?> getService<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    required T Function(dynamic) fromJsonT,
  }) async {
    final url = Uri.parse('${AppEnvironment.config.baseApiurl}$endpoint');
    appLog('http GET: url:$url', logging: Logging.info);
    try {
      headers ??= await _getHeaders();
      appLog('http: headers:$headers', logging: Logging.info);
      final response = await http.get(url, headers: headers);

      appLog('http: response:${response.body}', logging: Logging.info);
      if (response.statusCode == 200) {
        final baseResponse = misBaseResponseFromJson<T>(
          response.body,
          fromJsonT,
        );

        if (baseResponse.errors != null && baseResponse.errors!.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500),
              () => showErroListDialog(baseResponse.errors!));
        }

        return baseResponse;
      } else {
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('$exceptionMsg $e');
    }
  }

  Future<dynamic> post({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('${AppEnvironment.config.baseApiurl}$endpoint');
    appLog('http POST: url:$url', logging: Logging.info);
    try {
      headers ??= await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      appLog('http: headers:$headers', logging: Logging.info);
      appLog('http: response:${response.body}', logging: Logging.info);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('$exceptionMsg $e');
    }
  }

  Future<AppBaseResponse<T>?> postServiceList<T>({
    required String endpoint,
    required List<Map<String, dynamic>> data,
    Map<String, String>? headers,
    required T Function(dynamic) fromJsonT,
    bool ignoreError = false,
    bool retryOnUnauthorized = true,
  }) async {
    final url = Uri.parse('${AppEnvironment.config.baseApiurl}$endpoint');
    appLog('http POST: url:$url', logging: Logging.info);

    try {
      headers ??= await _getHeaders();

      final encodedBody = jsonEncode(data);

      appLog('http: headers: $headers', logging: Logging.info);
      appLog('http: body: $encodedBody', logging: Logging.info);

      final response = await http.post(
        url,
        headers: headers,
        body: encodedBody,
      );

      appLog('http: response: ${response.statusCode} ${response.body}',
          logging: Logging.info);
      inspect(response);

      return _commonResponse<T>(
        endpoint: endpoint,
        httpMethodType: HttpMethodType.postList,
        response: response,
        data: data, // For logging/debug clarity
        headers: headers,
        fromJsonT: fromJsonT,
        ignoreError: ignoreError,
        retryOnUnauthorized: retryOnUnauthorized,
      );
    } catch (e, st) {
      appLog('Exception in postServiceList: $e', logging: Logging.error);
      appLog('$st', logging: Logging.error);
      throw Exception('$exceptionMsg $e');
    }
  }

  Future<Map<String, dynamic>?> postServiceReturningMap({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
    bool ignoreError = false,
    bool retryOnUnauthorized = true,
  }) async {
    final url = Uri.parse('${AppEnvironment.config.baseTokenApiurl}$endpoint');
    appLog('http POST: url:$url', logging: Logging.info);

    try {
      headers ??= await _getHeaders();

      final String encodedBody = jsonEncode(data);
      appLog('http: headers:$headers', logging: Logging.info);
      appLog('http: body:$encodedBody', logging: Logging.info);

      final response = await http.post(
        url,
        headers: headers,
        body: encodedBody,
      );

      appLog(
        'http: response for $url : ${response.statusCode} ${response.body}',
        logging: Logging.info,
      );

      final body = response.body;

      if (response.statusCode == 200) {
        // Typically returns access_token response
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          appLog('Expected Map JSON on 200, got ${decoded.runtimeType}',
              logging: Logging.error);
          if (!ignoreError) {
            showErrorSnackbar(message: 'Unexpected server response.');
          }
          return null;
        }
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('error') &&
            decoded.containsKey('error_description')) {
          final errorMsg =
              '${decoded['error']}: ${decoded['error_description']}';
          appLog('Server returned 400 error: $errorMsg',
              logging: Logging.error);
          if (!ignoreError) {
            showErrorSnackbar(message: errorMsg);
          }
          return decoded; // return the error map for handling in controller
        } else {
          if (!ignoreError) {
            showErrorSnackbar(message: 'Error: HTTP 400');
          }
          return null;
        }
      } else if (response.statusCode == 401 && retryOnUnauthorized) {
        appLog('Unauthorized, attempting silent refresh.',
            logging: Logging.warning);

        final refreshed = await _refreshAccessToken();

        if (refreshed) {
          return refreshed as Map<String, dynamic>?;
        } else {
          navigateToAndRemoveAll(loginPageRoute);
          return null;
        }
      } else {
        appLog(
          'Unhandled HTTP ${response.statusCode}: ${response.body}',
          logging: Logging.error,
        );
        if (!ignoreError) {
          showErrorSnackbar(
              message: 'HTTP ${response.statusCode}: Server error');
        }
        return null;
      }
    } catch (e) {
      appLog('Exception during postServiceReturningMap: $e',
          logging: Logging.error);
      if (!ignoreError) {
        showErrorSnackbar(message: 'Exception: $e');
      }
      return null;
    }
  }

  Future<AppBaseResponse<T>?> postService<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    required T Function(dynamic) fromJsonT,
    bool ignoreError = false,
    bool retryOnUnauthorized = true,
  }) async {
    final url = Uri.parse('${AppEnvironment.config.baseApiurl}$endpoint');
    appLog('http POST: url:$url', logging: Logging.info);

    try {
      headers ??= await _getHeaders();
      appLog('http: headers:$headers', logging: Logging.info);
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      appLog('http: body:${data != null ? jsonEncode(data) : ''}',
          logging: Logging.info);
      appLog('http: response: ${response.statusCode} ${response.body}',
          logging: Logging.info);

      inspect(response);

      return _commonResponse<T>(
        endpoint: endpoint,
        httpMethodType: HttpMethodType.post,
        response: response,
        data: data,
        headers: headers,
        fromJsonT: fromJsonT,
      );
    } catch (e) {
      throw Exception('$exceptionMsg $e');
    }
  }

  Future<AppBaseResponse<T>?> _commonResponse<T>({
    required String endpoint,
    required HttpMethodType httpMethodType,
    required http.Response response,
    dynamic data,
    Map<String, String>? headers,
    required T Function(dynamic) fromJsonT,
    bool ignoreError = false,
    bool retryOnUnauthorized = true,
  }) async {
    if (response.statusCode == 200) {
      final baseResponse = misBaseResponseFromJson<T>(
        response.body,
        fromJsonT,
      );

      if (!ignoreError && baseResponse.errors!.isNotEmpty) {
        if (baseResponse.errors!.first.code != null &&
            baseResponse.errors!.first.code == '401' &&
            retryOnUnauthorized) {
          await _handleUnAuthorised(
            endpoint: endpoint,
            data: data,
            headers: headers,
            fromJsonT: fromJsonT,
            ignoreError: ignoreError,
            httpMethodType: httpMethodType,
          );
        } else if (baseResponse.errors!.first.code == '500') {
          appLog('Internal Error', logging: Logging.error);
          navigateToAndRemoveAll(loginPageRoute);
        } else if (baseResponse.success == false) {
          Future.delayed(const Duration(milliseconds: 500), () {
            showErroListDialog(baseResponse.errors!);
          });
        } else {
          Future.delayed(const Duration(milliseconds: 500),
              () => showErroListDialog(baseResponse.errors!));
        }
      }

      return baseResponse;
    } else if (response.statusCode == 401 && retryOnUnauthorized) {
      await _handleUnAuthorised(
        endpoint: endpoint,
        data: data,
        headers: headers,
        fromJsonT: fromJsonT,
        ignoreError: ignoreError,
        httpMethodType: httpMethodType,
      );
    } else {
      return _handleResponse(response);
    }
    return null;
  }

  Future<Future<AppBaseResponse<T>?>?> _handleUnAuthorised<T>({
    required String endpoint,
    required HttpMethodType httpMethodType,
    dynamic data,
    Map<String, String>? headers,
    required T Function(dynamic) fromJsonT,
    bool ignoreError = false,
  }) async {
// Handle token expiration
    appLog('Token expired, attempting to refresh token...',
        logging: Logging.warning);

    final isTokenRefreshed = await _refreshAccessToken();
    if (isTokenRefreshed) {
      // Retry the API call once
      appLog('Retrying the request after refreshing the token...',
          logging: Logging.info);
      Map<String, String>? updatedHeaders = headers;
      if (myApplication.preferenceHelper != null && updatedHeaders != null) {
        String accessToken =
            myApplication.preferenceHelper!.getString(accessTokenKey);
        updatedHeaders['Authorization'] = 'Bearer $accessToken';
      }
      switch (httpMethodType) {
        case HttpMethodType.get:
          return getService(
            endpoint: endpoint,
            data: data,
            headers: updatedHeaders,
            fromJsonT: fromJsonT,
          );
        case HttpMethodType.post:
          return postService(
            endpoint: endpoint,
            data: data,
            headers: updatedHeaders,
            fromJsonT: fromJsonT,
          );
        case HttpMethodType.postList:
          return postServiceList(
            endpoint: endpoint,
            data: data,
            headers: updatedHeaders,
            fromJsonT: fromJsonT,
          );
        case HttpMethodType.delete:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } else {
      if (myApplication.preferenceHelper != null) {
        await myApplication.preferenceHelper!.setBool(rememberMeKey, false);
      }
      appLog('Unable to refresh token. Please log in again.',
          logging: Logging.error);
      showErrorSnackbar(
          message: 'Unable to refresh token. Please log in again.');
      navigateToAndRemoveAll(loginPageRoute);
    }
    return null;
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final authService = safeFindOrLazyPut<AuthService>(() => AuthService());
      final MyApplication myApp = Get.find<MyApplication>();
      if (myApp.preferenceHelper != null) {
        var response = await authService.refresh(RefreshRequest(
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
      return false;
    } catch (e) {
      appLog('Exception during token refresh: $e', logging: Logging.error);
      return false;
    }
  }

  T safeFindOrLazyPut<T>(T Function() creator) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut(creator);
    }
    return Get.find<T>();
  }

  Future<Map<String, String>> _getHeaders() async {
    final MyApplication misApp = Get.find<MyApplication>();
    if (misApp.preferenceHelper != null) {
      String authToken = misApp.preferenceHelper!.getString(accessTokenKey);
      // String userid = misApp.preferenceHelper!.getString(userIdKey);
      String sid = misApp.preferenceHelper!.getString(sidKey);
      String deviceId = misApp.preferenceHelper!.getString(deviceIdKey);
      String randomDigit = await DeviceUtil.generateRandomString();
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Correlation-Id': 'S01$sid$randomDigit',
        'DeviceID': deviceId,
        'AppID': 'S01',
        'SID': sid
      };
    }
    return {};
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception("$badRequest: ${response.body}");
      case 401:
        toastMessage(failedAuthenticationMsg.tr);
        Future.delayed(const Duration(milliseconds: 500), () {
          navigateToAndRemoveAll(loginPageRoute);
        });
        throw Exception("$unauthorized: ${response.body}");
      case 403:
        throw Exception("$forbidden: ${response.body}");
      case 404:
        throw Exception("$notFound: ${response.body}");
      case 500:
        throw Exception("$serverError: ${response.body}");
      default:
        throw Exception("$unknownError: ${response.body}");
    }
  }

  void showErroListDialog(List<ResponseError> errors) {
    showDialog(
      context: Get.context!,
      builder: (context) => HttpErrorListDialog(
        errors: errors,
      ),
    );
  }
}
