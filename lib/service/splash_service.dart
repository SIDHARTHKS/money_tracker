import 'package:flutter/widgets.dart';

import '../helper/core/base/app_base_service.dart';

class SplashService extends AppBaseService {
  // Future<AppBaseResponse<List<Company>>?> loadCompany(
  //     UserProfileRequest request) async {
  //   final response = await httpService.postService<List<Company>>(
  //     endpoint: getCompaniesApiEndpoint(),
  //     headers: await getHeaders(),
  //     data: request.toJson(),
  //     fromJsonT: (json) {
  //       if (json is List) {
  //         return List<Company>.from(
  //           json.map((x) => Company.fromJson(x)),
  //         );
  //       } else {
  //         return [Company.fromJson(json)];
  //       }
  //     },
  //   );
  //   return response;
  // }

  // Future<MisBaseResponse<List<Branch>>?> loadBranches(
  //     UserProfileRequest request) async {
  //   final response = await httpService.postService<List<Branch>>(
  //     endpoint: getBranchesApiEndpoint(),
  //     headers: await getHeaders(),
  //     data: request.toJson(),
  //     fromJsonT: (json) {
  //       if (json is List) {
  //         return List<Branch>.from(
  //           json.map((x) => Branch.fromJson(x)),
  //         );
  //       } else {
  //         return [Branch.fromJson(json)];
  //       }
  //     },
  //   );
  //   return response;
  // }

  // Future<MisBaseResponse?>? loadLastEntry(UserProfileRequest request) async {
  //   return await httpService.postService<LastEntryDate>(
  //     endpoint: getLastEntryApiEndpoint(),
  //     headers: await getHeaders(),
  //     data: request.toJson(),
  //     fromJsonT: (json) => LastEntryDate.fromJson(json),
  //   );
  // }

  // Future<MisBaseResponse?>? loadSaleData(SaleDataRequest request) async {
  //   return await httpService.postService<SaleDataResponse>(
  //     endpoint: getSalesApiEndpoint(),
  //     headers: await getHeaders(fbEid: true),
  //     data: request.toJson(),
  //     fromJsonT: (json) => SaleDataResponse.fromJson(json),
  //   );
  // }

  // Future<MisBaseResponse?>? getVersion() async {
  //   return await httpService.getService<UserProfileResponse>(
  //     endpoint: getVersionApiEndpoint(),
  //     headers: await getHeaders(),
  //     fromJsonT: (json) => UserProfileResponse.fromJson(json),
  //   );
  // }

  // Future<AppBaseResponse?>? verifyOtp(OtpRequest request) async {
  //   return await httpService.postService<OtpResponse>(
  //     endpoint: verifyOtpApiEndpoint(),
  //     headers: await getHeaders(
  //       xCorrelationId: false,
  //       authorization: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => OtpResponse.fromJson(json),
  //   );
  // }

  // Future<AppBaseResponse?>? resetPassword(ResetPasswordRequest request) async {
  //   return await httpService.postService<ResetPasswordResponse>(
  //     endpoint: resetPasswordApiEndpoint(),
  //     headers: await getHeaders(
  //       xCorrelationId: false,
  //       authorization: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => ResetPasswordResponse.fromJson(json),
  //   );
  // }

  // Future<AppBaseResponse?>? changePassword(
  //     ChangePasswordRequest request) async {
  //   return await httpService.postService<bool>(
  //     endpoint: changePasswordApiEndpoint(),
  //     headers: await getHeaders(),
  //     data: request.toJson(),
  //     fromJsonT: (json) => json,
  //   );
  // }

  // Future<ProfileResponse?> getProfileDetails(
  //     ProfileRequest request, String token) async {
  //   var response = await httpService.postService<ProfileResponse>(
  //     endpoint: getProfileApiEndpoint(token),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => ProfileResponse.fromJson(json),
  //   );
  //   if (response != null && response.data != null) {
  //     return response.data;
  //   }
  //   return null;
  // }

  // Future<AppBaseResponse<List<NotificationResponse>>?> fetchNotifications(
  //     NotificationRequest request) async {
  //   final response = await httpService.postService<List<NotificationResponse>>(
  //     endpoint: getNotificationApiEndpoint(),
  //     headers: await getHeaders(),
  //     data: request.toJson(),
  //     fromJsonT: (json) {
  //       if (json is List) {
  //         return List<NotificationResponse>.from(
  //           json.map((x) => NotificationResponse.fromJson(x)),
  //         );
  //       } else {
  //         return [NotificationResponse.fromJson(json)];
  //       }
  //     },
  //   );
  //   return response;
  // }

  @override
  Widget buildView() {
    // TODO: implement buildView
    throw UnimplementedError();
  }
}
