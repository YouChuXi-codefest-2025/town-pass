import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
import 'package:get/get.dart';

class DeviceService extends GetxService {
  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iosDeviceInfo;
  BaseDeviceInfo? baseDeviceInfo;

  Future<DeviceService> init() async {
    try {
      // 在 web 平台上，device_info_plus 會自動處理平台檢測
      if (kIsWeb) {
        // Web 平台只獲取 baseDeviceInfo
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        baseDeviceInfo = await deviceInfo.deviceInfo;
        return this;
      }

      // 移動平台使用 Platform 檢查
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      baseDeviceInfo = await deviceInfo.deviceInfo;

      // 使用 try-catch 來安全地檢測平台
      try {
        if (defaultTargetPlatform == TargetPlatform.android) {
          androidDeviceInfo = await deviceInfo.androidInfo;
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          iosDeviceInfo = await deviceInfo.iosInfo;
        }
      } catch (e) {
        // 如果平台檢測失敗，只使用 baseDeviceInfo
        print('無法獲取平台特定設備資訊: $e');
      }
    } catch (e) {
      // 如果 deviceInfo 初始化失敗，至少確保服務可以繼續運行
      print('無法初始化設備資訊服務: $e');
    }
    
    return this;
  }
}
