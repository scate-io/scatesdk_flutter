import 'scatesdk_flutter_platform_interface.dart';
import 'dart:convert';

enum ScateEvents {
  REMOTE_CONFIG_READY,
  PAID_PRODUCT_CLICKED,
  ONBOARDING_SCREENS_FINISHED,
  PAYWALL_SCREEN_CLOSED,
  ONBOARDING_SCREEN_CLOSED,
  PAYWALL_SCREEN_FINISHED,
  RESTORE_PURCHASE_CLICKED
}

extension ScateEventsExtension on ScateEvents {
  String get name {
    switch (this) {
      case ScateEvents.REMOTE_CONFIG_READY:
        return 'Scate_RemoteConfigsReady';
      case ScateEvents.PAID_PRODUCT_CLICKED:
        return 'Scate_PaidProductClicked';
      case ScateEvents.ONBOARDING_SCREENS_FINISHED:
        return 'Scate_OnboardingScreensFinished';
      case ScateEvents.PAYWALL_SCREEN_CLOSED:
        return 'Scate_PaywallScreenClosed';
      case ScateEvents.ONBOARDING_SCREEN_CLOSED:
        return 'Scate_OnboardingScreenClosed';
      case ScateEvents.PAYWALL_SCREEN_FINISHED:
        return 'Scate_PaywallScreenFinished';
      case ScateEvents.RESTORE_PURCHASE_CLICKED:
        return 'Scate_RestorePurchaseClicked';
    }
  }
}

class ScateSDK {
  static final Map<String, Function> _listeners = {};

  static Future<void> Init(String appID) {
    ScatesdkFlutterPlatform.instance.Init(appID);

    // To trigger Scate_AppDidBecomeActive manually
    ScatesdkFlutterPlatform.instance.ManuallyTriggerDidBecomeActive();
    for (var event in ScateEvents.values) {
      ScateSDK.ClearListeners(event);
    }
    return Future.value(); // fixes the warning
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

        if (name != parsedEvent['event']) {
          return;
        }

        // Use if-else to handle each event type.
        if (name == 'Scate_RemoteConfigsReady') {
          final remoteConfigFetched =
              parsedEvent['data']?['remoteConfigFetched'];
          listener(remoteConfigFetched);
        } else if (name == 'Scate_PaidProductClicked') {
          final productClicked = parsedEvent['data']?['identifier'];
          listener(productClicked);
        } else if (name == 'Scate_OnboardingScreensFinished') {
          final onboardingFinished = parsedEvent['data']?['identifier'];
          listener(onboardingFinished);
        } else if (name == 'Scate_PaywallScreenClosed') {
          final paywallScreenClosed = parsedEvent['data']?['success'];
          listener(paywallScreenClosed);
        } else if (name == 'Scate_OnboardingScreenClosed') {
          final onboardingScreenClosed = parsedEvent['data']?['success'];
          listener(onboardingScreenClosed);
        } else if (name == 'Scate_PaywallScreenFinished') {
          final onboardingFinished = parsedEvent['data']?['identifier'];
          listener(onboardingFinished);
        } else if (name == 'Scate_RestorePurchaseClicked') {
          final restorePurchaseClicked = parsedEvent['data']?['success'];
          listener(restorePurchaseClicked);
        } else {
          print("Unknown event: $name");
        }
      } catch (e) {
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

  static void ShowPaywall(String jsonString) {
    ScatesdkFlutterPlatform.instance.ShowPaywall(jsonString);
  }

  static void ShowOnboarding(String jsonString) {
    ScatesdkFlutterPlatform.instance.ShowOnboarding(jsonString);
  }

  static void ClosePaywall() {
    ScatesdkFlutterPlatform.instance.ClosePaywall();
  }

  static void CloseOnboarding() {
    ScatesdkFlutterPlatform.instance.CloseOnboarding();
  }

  static void ShowEventList() {
    ScatesdkFlutterPlatform.instance.ShowEventList();
  }

  static void ShowPaidProductLoadingScreen() {
    ScatesdkFlutterPlatform.instance.ShowPaidProductLoadingScreen();
  }

  static void ClosePaidProductLoadingScreen() {
    ScatesdkFlutterPlatform.instance.ClosePaidProductLoadingScreen();
  }
}
