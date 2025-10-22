import '../helper/core/base/app_base_service.dart';

class ProfileService extends AppBaseService {
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
}
