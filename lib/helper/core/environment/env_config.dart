import 'dart:io';

import '../../app_string.dart';
import '../../enum.dart';

class EnvironmentConfig {
  final String baseApiurl;
  final String baseTokenApiurl;
  final String title;
  final String appUpdateDate;
  final String releaseDate;
  final bool enableLogs; // Display logs in console
  final String version;
  final bool
      enableNetworkImages; // Disable or enable loading images from s3. disbale in dev stage for reduce the s3 hits.
  late PlatformType platformType;

  EnvironmentConfig({
    required this.baseApiurl,
    required this.baseTokenApiurl,
    required this.title,
    required this.appUpdateDate,
    required this.releaseDate,
    required this.enableLogs,
    required this.version,
    required this.enableNetworkImages,
  }) {
    if (Platform.isAndroid) {
      platformType = PlatformType.android;
    } else if (Platform.isIOS) {
      platformType = PlatformType.ios;
    } else {
      throw Exception(platformNotSupportedMsg);
    }
  }
}
