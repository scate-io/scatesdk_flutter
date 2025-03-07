import 'dart:async';
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

  @override
  Future<void> OnboardingStart() async {
    try {
      await methodChannel.invokeMethod('OnboardingStart');
    } on PlatformException catch (e) {
      print("Failed to call OnboardingStart: ${e.message}");
    }
  }

  @override
  Future<void> OnboardingStep(String step) async {
    try {
      await methodChannel.invokeMethod('OnboardingStep', {'step': step});
    } on PlatformException catch (e) {
      print("Failed to call OnboardingStep: ${e.message}");
    }
  }

  @override
  Future<void> OnboardingFinish() async {
    try {
      await methodChannel.invokeMethod('OnboardingFinish');
    } on PlatformException catch (e) {
      print("Failed to call OnboardingFinish: ${e.message}");
    }
  }

  @override
  Future<void> LoginSuccess(String source) async {
    try {
      await methodChannel.invokeMethod('LoginSuccess', {'source': source});
    } on PlatformException catch (e) {
      print("Failed to call LoginSuccess: ${e.message}");
    }
  }

  @override
  Future<void> InterstitialAdShown() async {
    try {
      await methodChannel.invokeMethod('InterstitialAdShown');
    } on PlatformException catch (e) {
      print("Failed to call InterstitialAdShown: ${e.message}");
    }
  }

  @override
  Future<void> InterstitialAdClosed() async {
    try {
      await methodChannel.invokeMethod('InterstitialAdClosed');
    } on PlatformException catch (e) {
      print("Failed to call InterstitialAdClosed: ${e.message}");
    }
  }

  @override
  Future<void> RewardedAdShown() async {
    try {
      await methodChannel.invokeMethod('RewardedAdShown');
    } on PlatformException catch (e) {
      print("Failed to call RewardedAdShown: ${e.message}");
    }
  }

  @override
  Future<void> RewardedAdClosed() async {
    try {
      await methodChannel.invokeMethod('RewardedAdClosed');
    } on PlatformException catch (e) {
      print("Failed to call RewardedAdClosed: ${e.message}");
    }
  }

  @override
  Future<void> RewardedAdClaimed() async {
    try {
      await methodChannel.invokeMethod('RewardedAdClaimed');
    } on PlatformException catch (e) {
      print("Failed to call RewardedAdClaimed: ${e.message}");
    }
  }

  @override
  Future<void> BannerAdShown() async {
    try {
      await methodChannel.invokeMethod('BannerAdShown');
    } on PlatformException catch (e) {
      print("Failed to call BannerAdShown: ${e.message}");
    }
  }

  @override
  Future<void> NotificationPermissionGranted() async {
    try {
      await methodChannel.invokeMethod('NotificationPermissionGranted');
    } on PlatformException catch (e) {
      print("Failed to call NotificationPermissionGranted: ${e.message}");
    }
  }

  @override
  Future<void> NotificationPermissionDenied() async {
    try {
      await methodChannel.invokeMethod('NotificationPermissionDenied');
    } on PlatformException catch (e) {
      print("Failed to call NotificationPermissionDenied: ${e.message}");
    }
  }

  @override
  Future<void> LocationPermissionGranted() async {
    try {
      await methodChannel.invokeMethod('LocationPermissionGranted');
    } on PlatformException catch (e) {
      print("Failed to call LocationPermissionGranted: ${e.message}");
    }
  }

  @override
  Future<void> LocationPermissionDenied() async {
    try {
      await methodChannel.invokeMethod('LocationPermissionDenied');
    } on PlatformException catch (e) {
      print("Failed to call LocationPermissionDenied: ${e.message}");
    }
  }

  @override
  Future<void> ATTPromptShown() async {
    try {
      await methodChannel.invokeMethod('ATTPromptShown');
    } on PlatformException catch (e) {
      print("Failed to call ATTPromptShown: ${e.message}");
    }
  }

  @override
  Future<void> ATTPermissionGranted() async {
    try {
      await methodChannel.invokeMethod('ATTPermissionGranted');
    } on PlatformException catch (e) {
      print("Failed to call ATTPermissionGranted: ${e.message}");
    }
  }

  @override
  Future<void> ATTPermissionDenied() async {
    try {
      await methodChannel.invokeMethod('ATTPermissionDenied');
    } on PlatformException catch (e) {
      print("Failed to call ATTPermissionDenied: ${e.message}");
    }
  }

  @override
  Future<void> PaywallShown(String paywall) async {
    try {
      await methodChannel.invokeMethod('PaywallShown', {'paywall': paywall});
    } on PlatformException catch (e) {
      print("Failed to call PaywallShown: ${e.message}");
    }
  }

  @override
  Future<void> PaywallClosed(String paywall) async {
    try {
      await methodChannel.invokeMethod('PaywallClosed', {'paywall': paywall});
    } on PlatformException catch (e) {
      print("Failed to call PaywallClosed: ${e.message}");
    }
  }

  @override
  Future<void> PaywallAttempted(String paywall) async {
    try {
      await methodChannel
          .invokeMethod('PaywallAttempted', {'paywall': paywall});
    } on PlatformException catch (e) {
      print("Failed to call PaywallAttempted: ${e.message}");
    }
  }

  @override
  Future<void> PaywallPurchased(String paywall) async {
    try {
      await methodChannel
          .invokeMethod('PaywallPurchased', {'paywall': paywall});
    } on PlatformException catch (e) {
      print("Failed to call PaywallPurchased: ${e.message}");
    }
  }

  @override
  Future<void> PaywallCancelled(String paywall) async {
    try {
      await methodChannel
          .invokeMethod('PaywallCancelled', {'paywall': paywall});
    } on PlatformException catch (e) {
      print("Failed to call PaywallCancelled: ${e.message}");
    }
  }

  @override
  Future<void> TabClicked(String tab) async {
    try {
      await methodChannel.invokeMethod('TabClicked', {'tab': tab});
    } on PlatformException catch (e) {
      print("Failed to call TabClicked: ${e.message}");
    }
  }

  @override
  Future<void> FeatureClicked(String tab) async {
    try {
      await methodChannel.invokeMethod('FeatureClicked', {'feature': tab});
    } on PlatformException catch (e) {
      print("Failed to call FeatureClicked: ${e.message}");
    }
  }

  @override
  Future<void> DailyStreakShown() async {
    try {
      await methodChannel.invokeMethod('DailyStreakShown');
    } on PlatformException catch (e) {
      print("Failed to call DailyStreakShown: ${e.message}");
    }
  }

  @override
  Future<void> DailyStreakClaimed() async {
    try {
      await methodChannel.invokeMethod('DailyStreakClaimed');
    } on PlatformException catch (e) {
      print("Failed to call DailyStreakClaimed: ${e.message}");
    }
  }

  @override
  Future<void> DailyStreakClosed() async {
    try {
      await methodChannel.invokeMethod('DailyStreakClosed');
    } on PlatformException catch (e) {
      print("Failed to call DailyStreakClosed: ${e.message}");
    }
  }

  @override
  Future<void> ShowPaywall(String jsonString) async {
    try {
      await methodChannel.invokeMethod('ShowPaywall', {'jsonString': jsonString});
    } on PlatformException catch (e) {
      print("Failed to call ShowPaywall: '${e.message}'.");
    }

    return null;
  }

  @override
  Future<void> ShowOnboarding(String jsonString) async {
    try {
      await methodChannel.invokeMethod('ShowOnboarding', {'jsonString': jsonString});
    } on PlatformException catch (e) {
      print("Failed to call ShowOnboarding: '${e.message}'.");
    }

    return null;
  }

  @override
  Future<void> ClosePaywall() async {
    try {
      await methodChannel.invokeMethod('ClosePaywall');
    } on PlatformException catch (e) {
      print("Failed to call ClosePaywall: ${e.message}");
    }
  }

  @override
  Future<void> CloseOnboarding() async {
    try {
      await methodChannel.invokeMethod('CloseOnboarding');
    } on PlatformException catch (e) {
      print("Failed to call CloseOnboarding: ${e.message}");
    }
  }

  @override
  Future<void> ShowEventList() async {
    try {
      await methodChannel.invokeMethod('ShowEventList');
    } on PlatformException catch (e) {
      print("Failed to call ShowEventList: ${e.message}");
    }
  }
}
