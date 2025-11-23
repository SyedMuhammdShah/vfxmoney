import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';

class DeviceInfoService {
  // Private constructor
  DeviceInfoService._privateConstructor();

  // Static instance
  static final DeviceInfoService _instance =
      DeviceInfoService._privateConstructor();

  // Factory constructor to return the same instance
  factory DeviceInfoService() {
    return _instance;
  }

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  String? deviceName;
  String? deviceID;

  Future<void> init() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        debugPrint('Android Device Info: ${androidInfo.toString()}');
        deviceName = androidInfo.model;
        deviceID = await locator<StorageService>().getPersistentDeviceUUID();
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        deviceID = iosInfo.identifierForVendor ?? 'Unknown';
      }
    } catch (e) {
      debugPrint("ERROOORRRR DEVICEEE ${e.toString()}");
      deviceName = "Unknown Device";
      deviceID = "Unknown ID";
    }
  }

  String get safeDeviceName => deviceName ?? "Unknown Device";
  String get safeDeviceID => deviceID ?? "Unknown ID";
}
