// ignore_for_file: file_names

import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceUtil {
  static final RxBool _isTablet = false.obs;

  /// Initialize during app start or splash.
  /// Requires BuildContext once during initialization.
  static Future<void> init(BuildContext context) async {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide >= 600) {
      _isTablet.value = true;
    } else {
      // fallback to DeviceInfo if needed
      _isTablet.value = await _isTabletDeviceInfo();
    }
  }

  /// Use anywhere in the app to check if device is tablet
  static bool get isTablet => _isTablet.value;

  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return 'Unknown';
  }

  static Future<String> generateRandomString() async {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  static Future<bool> _isTabletDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      // Approximate using physical size or model naming
      final model = androidInfo.model?.toLowerCase() ?? '';
      return model.contains('tablet') || model.contains('pad');
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model?.toLowerCase().contains('ipad') ?? false;
    }
    return false;
  }
}
