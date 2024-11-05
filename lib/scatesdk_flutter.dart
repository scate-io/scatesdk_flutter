import 'scatesdk_flutter_platform_interface.dart';
import 'dart:convert';

enum ScateEvents {
  REMOTE_CONFIG_READY,
}

extension ScateEventsExtension on ScateEvents {
  String get name {
    switch (this) {
      case ScateEvents.REMOTE_CONFIG_READY:
        return 'Scate_RemoteConfigsReady';
    }
  }
}

class ScateSDK {
  static final Map<String, Function> _listeners = {};

  static Future<void> Init(String appID) {
    return ScatesdkFlutterPlatform.instance.Init(appID);
  }

  static Future<void> SetAdid(String adid) {
    return ScatesdkFlutterPlatform.instance.SetAdid(adid);
  }

  static Future<void> Event(String name) {
    return ScatesdkFlutterPlatform.instance.Event(name);
  }

  static Future<void> EventWithValue(String name, String value) async {
    await ScatesdkFlutterPlatform.instance.EventWithValue(name, value);
  }

  static Future<String?> GetRemoteConfig(
      String key, String defaultValue) async {
    return await ScatesdkFlutterPlatform.instance
        .GetRemoteConfig(key, defaultValue);
  }

  static void AddListener(ScateEvents eventType, Function listener) {
    var name = eventType.name;

    if (!_listeners.containsKey(name)) {
      _listeners[name] = listener;
      ScatesdkFlutterPlatform.instance.AddListener(name);
      ScatesdkFlutterPlatform.instance.eventsStream.listen((event) {
        HandleEvent(name, event);
      });
    }
  }

  static void RemoveListener(ScateEvents eventType) {
    var name = eventType.name;
    if (_listeners.containsKey(name)) {
      _listeners.remove(name);
      ScatesdkFlutterPlatform.instance.RemoveListener(name);
    }
  }

  static void ClearListeners(ScateEvents eventType) {
    var name = eventType.name;
    _listeners.remove(name);
    ScatesdkFlutterPlatform.instance.RemoveListener(name);
  }

  static void HandleEvent(String name, dynamic event) {
    final listener = _listeners[name];
    if (listener != null) {
      try {
        // Assuming the event is a JSON string, parse it into a map.
        final Map<String, dynamic> parsedEvent = jsonDecode(event);

        // Access the `data` field and then `remoteConfigFetched`.
        final remoteConfigFetched = parsedEvent['data']?['remoteConfigFetched'];

        // Pass the extracted value to the listener.
        listener(remoteConfigFetched);
      } catch (e) {
        // Handle the case where parsing or accessing fields fails.
        print("Error parsing event: $e");
      }
    }
  }

  //Event functions
  static void OnboardingStart() {
    ScatesdkFlutterPlatform.instance.OnboardingStart();
  }

  static void OnboardingStep(String step) {
    ScatesdkFlutterPlatform.instance.OnboardingStep(step);
  }

  static void OnboardingFinish() {
    ScatesdkFlutterPlatform.instance.OnboardingFinish();
  }

  static void LoginSuccess(String source) {
    ScatesdkFlutterPlatform.instance.LoginSuccess(source);
  }

  static void InterstitialAdShown() {
    ScatesdkFlutterPlatform.instance.InterstitialAdShown();
  }

  static void InterstitialAdClosed() {
    ScatesdkFlutterPlatform.instance.InterstitialAdClosed();
  }

  static void RewardedAdShown() {
    ScatesdkFlutterPlatform.instance.RewardedAdShown();
  }

  static void RewardedAdClosed() {
    ScatesdkFlutterPlatform.instance.RewardedAdClosed();
  }

  static void RewardedAdClaimed() {
    ScatesdkFlutterPlatform.instance.RewardedAdClaimed();
  }

  static void BannerAdShown() {
    ScatesdkFlutterPlatform.instance.BannerAdShown();
  }

  static void NotificationPermissionGranted() {
    ScatesdkFlutterPlatform.instance.NotificationPermissionGranted();
  }

  static void NotificationPermissionDenied() {
    ScatesdkFlutterPlatform.instance.NotificationPermissionDenied();
  }

  static void LocationPermissionGranted() {
    ScatesdkFlutterPlatform.instance.LocationPermissionGranted();
  }

  static void LocationPermissionDenied() {
    ScatesdkFlutterPlatform.instance.LocationPermissionDenied();
  }

  static void ATTPromptShown() {
    ScatesdkFlutterPlatform.instance.ATTPromptShown();
  }

  static void ATTPermissionGranted() {
    ScatesdkFlutterPlatform.instance.ATTPermissionGranted();
  }

  static void ATTPermissionDenied() {
    ScatesdkFlutterPlatform.instance.ATTPermissionDenied();
  }

  static void PaywallShown(String paywall) {
    ScatesdkFlutterPlatform.instance.PaywallShown(paywall);
  }

  static void PaywallClosed(String paywall) {
    ScatesdkFlutterPlatform.instance.PaywallClosed(paywall);
  }

  static void PaywallAttempted(String paywall) {
    ScatesdkFlutterPlatform.instance.PaywallAttempted(paywall);
  }

  static void PaywallPurchased(String paywall) {
    ScatesdkFlutterPlatform.instance.PaywallPurchased(paywall);
  }

  static void PaywallCancelled(String paywall) {
    ScatesdkFlutterPlatform.instance.PaywallCancelled(paywall);
  }

  static void TabClicked(String tab) {
    ScatesdkFlutterPlatform.instance.TabClicked(tab);
  }

  static void FeatureClicked(String feature) {
    ScatesdkFlutterPlatform.instance.FeatureClicked(feature);
  }

  static void DailyStreakShown() {
    ScatesdkFlutterPlatform.instance.DailyStreakShown();
  }

  static void DailyStreakClaimed() {
    ScatesdkFlutterPlatform.instance.DailyStreakClaimed();
  }

  static void DailyStreakClosed() {
    ScatesdkFlutterPlatform.instance.DailyStreakClosed();
  }
}
