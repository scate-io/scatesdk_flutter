import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'scatesdk_flutter_method_channel.dart';

abstract class ScatesdkFlutterPlatform extends PlatformInterface {
  /// Constructs a ScatesdkFlutterPlatform.
  ScatesdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScatesdkFlutterPlatform _instance = MethodChannelScatesdkFlutter();

  /// The default instance of [ScatesdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelScatesdkFlutter].
  static ScatesdkFlutterPlatform get instance => _instance;

  Stream<String> get eventsStream;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScatesdkFlutterPlatform] when
  /// they register themselves.
  static set instance(ScatesdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> Init(String appID) async {
    _instance.Init(appID);
  }

  Future<void> SetAdid(String adid) async {
    return _instance.SetAdid(adid);
  }

  Future<void> Event(String name) async {
    return _instance.Event(name);
  }

  Future<void> EventWithValue(String name, String value) async {
    return _instance.EventWithValue(name, value);
  }

  Future<String?> GetRemoteConfig(String key, String defaultValue) async {
    return _instance.GetRemoteConfig(key, defaultValue);
  }

  Future<void> AddListener(String name) async {
    return _instance.AddListener(name);
  }

  Future<void> RemoveListener(String name) async {
    return _instance.RemoveListener(name);
  }

  Future<void> OnboardingStart() async {
    return _instance.OnboardingStart();
  }

  Future<void> OnboardingStep(String step) async {
    return _instance.OnboardingStep(step);
  }

  Future<void> OnboardingFinish() async {
    return _instance.OnboardingFinish();
  }

  Future<void> LoginSuccess(String source) async {
    return _instance.LoginSuccess(source);
  }

  Future<void> InterstitialAdShown() async {
    return _instance.InterstitialAdShown();
  }

  Future<void> InterstitialAdClosed() async {
    return _instance.InterstitialAdClosed();
  }

  Future<void> RewardedAdShown() async {
    return _instance.RewardedAdShown();
  }

  Future<void> RewardedAdClosed() async {
    return _instance.RewardedAdClosed();
  }

  Future<void> RewardedAdClaimed() async {
    return _instance.RewardedAdClaimed();
  }

  Future<void> BannerAdShown() async {
    return _instance.BannerAdShown();
  }

  Future<void> NotificationPermissionGranted() async {
    return _instance.NotificationPermissionGranted();
  }

  Future<void> NotificationPermissionDenied() async {
    return _instance.NotificationPermissionDenied();
  }

  Future<void> LocationPermissionGranted() async {
    return _instance.LocationPermissionGranted();
  }

  Future<void> LocationPermissionDenied() async {
    return _instance.LocationPermissionDenied();
  }

  Future<void> ATTPromptShown() async {
    return _instance.ATTPromptShown();
  }

  Future<void> ATTPermissionGranted() async {
    return _instance.ATTPermissionGranted();
  }

  Future<void> ATTPermissionDenied() async {
    return _instance.ATTPermissionDenied();
  }

  Future<void> PaywallShown(String paywall) async {
    return _instance.PaywallShown(paywall);
  }

  Future<void> PaywallClosed(String paywall) async {
    return _instance.PaywallClosed(paywall);
  }

  Future<void> PaywallAttempted(String paywall) async {
    return _instance.PaywallAttempted(paywall);
  }

  Future<void> PaywallPurchased(String paywall) async {
    return _instance.PaywallPurchased(paywall);
  }

  Future<void> PaywallCancelled(String paywall) async {
    return _instance.PaywallCancelled(paywall);
  }

  Future<void> TabClicked(String tab) async {
    return _instance.TabClicked(tab);
  }

  Future<void> FeatureClicked(String feature) async {
    return _instance.FeatureClicked(feature);
  }

  Future<void> DailyStreakShown() async {
    return _instance.DailyStreakShown();
  }

  Future<void> DailyStreakClaimed() async {
    return _instance.DailyStreakClosed();
  }

  Future<void> DailyStreakClosed() async {
    return _instance.DailyStreakClaimed();
  }

  Future<void> ShowPaywall(String jsonString) async {
    return _instance.ShowPaywall(jsonString);
  }

  Future<void> ShowOnboarding(String jsonString) async {
    return _instance.ShowOnboarding(jsonString);
  }

  Future<void> ClosePaywall() async {
    return _instance.ClosePaywall();
  }

  Future<void> CloseOnboarding() async {
    return _instance.CloseOnboarding();
  }

  Future<void> ShowEventList() async {
    return _instance.ShowEventList();
  }

  Future<void> ClosePaidProductLoadingScreen() async {
    return _instance.ClosePaidProductLoadingScreen();
  }
}
