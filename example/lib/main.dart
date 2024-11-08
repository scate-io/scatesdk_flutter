import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:scatesdk_flutter/scatesdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _remoteConfigValue = 'Loading...';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    ScateSDK.Init("uw2YK");
    ScateSDK.SetAdid("test_adid");
    ScateSDK.Event("test_event");
    ScateSDK.EventWithValue("test_event", "test_value");

    ScateSDK.OnboardingStart();
    ScateSDK.OnboardingStep("location_screen");
    ScateSDK.OnboardingStep("notification_screen");
    ScateSDK.OnboardingStep("personalization_screen");
    ScateSDK.OnboardingStep("journey_screen");
    ScateSDK.OnboardingStep("intro_paywall_screen");
    ScateSDK.OnboardingStep("fullscreen_ad");
    ScateSDK.OnboardingFinish();

    ScateSDK.LoginSuccess("apple");
    ScateSDK.LoginSuccess("email");
    ScateSDK.LoginSuccess("fb");
    ScateSDK.LoginSuccess("google");

    ScateSDK.InterstitialAdShown();
    ScateSDK.InterstitialAdClosed();
    ScateSDK.RewardedAdShown();
    ScateSDK.RewardedAdClosed();
    ScateSDK.RewardedAdClaimed();
    ScateSDK.BannerAdShown();

    ScateSDK.NotificationPermissionGranted();
    ScateSDK.NotificationPermissionDenied();
    ScateSDK.LocationPermissionGranted();
    ScateSDK.LocationPermissionDenied();
    ScateSDK.ATTPromptShown();
    ScateSDK.ATTPermissionGranted();
    ScateSDK.ATTPermissionDenied();

    ScateSDK.PaywallShown("paywall_name");
    ScateSDK.PaywallClosed("paywall_name");
    ScateSDK.PaywallAttempted("paywall_name");
    ScateSDK.PaywallPurchased("paywall_name");
    ScateSDK.PaywallCancelled("paywall_name");

    ScateSDK.TabClicked("x");
    ScateSDK.TabClicked("y");

    ScateSDK.FeatureClicked("x");
    ScateSDK.FeatureClicked("y");

    ScateSDK.DailyStreakShown();
    ScateSDK.DailyStreakClaimed();
    ScateSDK.DailyStreakClosed();

    var localConfig = await ScateSDK.GetRemoteConfig('test', 'default');
    setState(() {
      _remoteConfigValue = 'Local -> ' + (localConfig ?? 'not found');
    });

    ScateSDK.AddListener(ScateEvents.REMOTE_CONFIG_READY, (success) async {
      print('Remote Fetched: $success');
      var remoteConfig = await ScateSDK.GetRemoteConfig('test', 'default');

      setState(() {
        _remoteConfigValue = 'Remote -> ' +
            (remoteConfig ?? 'not found') +
            '\n success -> ' +
            success.toString(); // Convert boolean to string
      });
    });

    //ScateSDK.RemoveListener(ScateEvents.REMOTE_CONFIG_READY);
    //ScateSDK.ClearListeners(ScateEvents.REMOTE_CONFIG_READY);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ScateSDK example app'),
        ),
        body: Center(
          child: Text(_remoteConfigValue + '\n'),
        ),
      ),
    );
  }
}
