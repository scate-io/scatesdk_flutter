import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'scatesdk_flutter_platform_interface.dart';

/// An implementation of [ScatesdkFlutterPlatform] that uses method channels.
class MethodChannelScatesdkFlutter extends ScatesdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('scatesdk_flutter');

  @override
  Future<void> Init(String appID) async {
    try {
      await methodChannel.invokeMethod('Init', {'appID': appID});
    } on PlatformException catch (e) {
      print("Failed to call Init: '${e.message}'.");
    }
  }
  @override
  Future<void> SetAdid(String adid) async {
    try {
      await methodChannel.invokeMethod('SetAdid', {'adid': adid});
    } on PlatformException catch (e) {
      print("Failed to call SetAdid: '${e.message}'.");
    }
  }
  @override
  Future<void> Event(String name) async {
    try {
      await methodChannel.invokeMethod('Event', {'name': name});
    } on PlatformException catch (e) {
      print("Failed to call Event: '${e.message}'.");
    }
  }
  @override
  Future<void> EventWithValue(String name, String value) async {
    try {
      await methodChannel.invokeMethod('EventWithValue', {'name': name, 'value': value});
    } on PlatformException catch (e) {
      print("Failed to call EventWithValue: '${e.message}'.");
    }
  }


}
