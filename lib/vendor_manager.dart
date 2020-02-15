import 'dart:async';

import 'package:flutter/services.dart';

class LocationData {
  double latitude;
  double longitude;

  LocationData({this.latitude, this.longitude});

  LocationData.fromJson(Map<String, dynamic> dataJson) {
    if(dataJson != null) {
      latitude = dataJson['latitude'];
      longitude = dataJson['longitude'];
    }
  }
}

enum MethodName {
  getPlatformVersion,
  hasPermission,
  getLocation,
}

class EnumsToString {
  static String parse(enumItem) {
    if(enumItem == null) return null;
    return enumItem.toString().split('.')[1];
  }
}

class VendorManager {
  //method channel 用来进行flutter调用native
  static const MethodChannel _channel =
      const MethodChannel('hi_vendor_manager');

  static const EventChannel _stream = const EventChannel('havi/locationstrem');

  /*
  获取平台系统版本号
   */
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod(EnumsToString.parse(MethodName.getPlatformVersion));
    return version;
  }

  /*
  checks if the app has permission for access location
   */
  static Future<bool> get hasPermission async {
    final bool permission = await _channel.invokeMethod(EnumsToString.parse(MethodName.hasPermission.toString()));
    return permission;
  }

  static Future<LocationData> get getLocation async {
    final data = await _channel.invokeMethod(EnumsToString.parse(MethodName.getLocation.toString()));
    final location = LocationData.fromJson(data.cast<String, double>());
    return location;
  }
}
