import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'scatesdk_flutter_platform_interface.dart';

/// An implementation of [ScatesdkFlutterPlatform] that uses method channels.
class MethodChannelScatesdkFlutter extends ScatesdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('scatesdk_flutter');

  /// Event channel for receiving events from native platform.
  final EventChannel eventChannel =
      const EventChannel('scatesdk_flutter_events');

  /// Stream controller for handling events.
  final StreamController<String> _eventsController =
      StreamController<String>.broadcast();

  /// Stream getter for exposing events stream.
  Stream<String> get eventsStream => _eventsController.stream;

  Future<void> _initializeEventChannel() async {
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event is String) {
        try {
          _eventsController.add(event);
        } catch (e) {
          print('Error parsing event: $e');
        }
      } else {
        print('Unexpected event format: $event');
      }
    }, onError: (error) {
      print("Error receiving event: $error");
    });
  }

  @override
  Future<void> Init(String appID) async {
    try {
      await methodChannel.invokeMethod('Init', {'appID': appID});
      await _initializeEventChannel();
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
      await methodChannel
          .invokeMethod('EventWithValue', {'name': name, 'value': value});
    } on PlatformException catch (e) {
      print("Failed to call EventWithValue: '${e.message}'.");
    }
  }

  @override
  Future<String?> GetRemoteConfig(String key, String defaultValue) async {
    try {
      String config = await methodChannel.invokeMethod(
          'GetRemoteConfig', {'key': key, 'defaultValue': defaultValue});
      return config;
    } on PlatformException catch (e) {
      print("Failed to call GetRemoteConfig: '${e.message}'.");
    }

    return null;
  }

  Future<void> AddListener(String name) async {
    try {
      await methodChannel.invokeMethod('AddListener', {'name': name});
    } on PlatformException catch (e) {
      print("Failed to add listener for $name: ${e.message}");
    }
  }

  Future<void> RemoveListener(String name) async {
    try {
      await methodChannel.invokeMethod('RemoveListener', {'name': name});
    } on PlatformException catch (e) {
      print("Failed to remove listener for $name: ${e.message}");
    }
  }
}
