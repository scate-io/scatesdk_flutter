import 'package:flutter/material.dart';
import 'dart:async';

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
  static const String _adjustToken = '19atefbehslc';

  String _remoteConfigValue = 'Loading...';
  String _adjustStatus = 'Adjust not started';
  String _adjustId = 'Waiting...';
  String _sdkMetadata = 'Loading SDK metadata...';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await ScateSDK.Init("uw2YK", debug: true);
    final sdkMetadata = await ScateSDK.GetSdkMetadata();
    print('SDK metadata: $sdkMetadata');
    if (!mounted) return;
    setState(() {
      _sdkMetadata =
          'native=${sdkMetadata['sdkNativeVersion'] ?? ''}, '
          'platformVer=${sdkMetadata['sdkPlatformVersion'] ?? ''}, '
          'platform=${sdkMetadata['sdkPlatform'] ?? ''}';
    });
    await ScateSDK.InitAdjust(_adjustToken);
    setState(() {
      _adjustStatus = 'Adjust initialized, waiting for ADID';
    });
    ScateSDK.GetAdjustId((adid) {
      print('Adjust ADID: $adid');
      if (!mounted) return;
      setState(() {
        _adjustStatus = 'Adjust ADID ready';
        _adjustId = adid;
      });
    });
    final scateUserId = await ScateSDK.GetUserID();
    print('Scate userId: $scateUserId');

    // Example ScateSDK event functions.
    // If you need to send events, you can use these functions.
    await ScateSDK.Event("test_event");
    await ScateSDK.Event(
      "test_event_with_parameters",
      parameters: {
        "button_id": "flutter_example_purchase",
        "attempt": 1,
        "is_trial": true,
        "price": 9.99,
      },
    );
    await ScateSDK.EventWithValue("test_event", "test_value");
    await ScateSDK.EventWithValueAndParameters(
      "test_event_with_value_and_parameters",
      "test_value",
      parameters: {
        "button_id": "flutter_example_purchase",
        "attempt": 2,
        "is_trial": false,
        "price": 19.99,
      },
    );
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

    ScateSDK.RevenuecatInitiated();
    ScateSDK.AdjustInitiated();
    ScateSDK.AdjustSetToRevenuecat();
    ScateSDK.SplashCompleted();
    ScateSDK.FirebaseRemoteInitiated();
    ScateSDK.HomeScreenOpen();
    ScateSDK.OnboardingPaywallShown();
    ScateSDK.OnboardingPaywallClosed();

    // Example usage of ScateSDK remote config.
    // Use these function if you have set up remote config in your Scate dashboard.
    var localConfig = await ScateSDK.GetRemoteConfig('test', 'default');
    setState(() {
      _remoteConfigValue = 'Local -> ' + (localConfig ?? 'not found');
    });

    // Example usage of ScateSDK event listeners.
    // Add these listeners if you need to handle specific events in your app.
    ScateSDK.AddListener(ScateEvents.REMOTE_CONFIG_READY, (success) async {
      print('Remote Fetched: $success');
      var remoteConfig = await ScateSDK.GetRemoteConfig('test', 'default');
      final typedBool = await ScateSDK.GetRemoteConfigBool('test', false);
      final typedInt = await ScateSDK.GetRemoteConfigInt('test1', -1);
      final typedDouble = await ScateSDK.GetRemoteConfigDouble('test2', -1);
      print('Typed $typedBool $typedInt $typedDouble');

      setState(() {
        _remoteConfigValue = 'Remote -> ' +
            (remoteConfig ?? 'not found') +
            '\n success -> ' +
            success.toString(); // Convert boolean to string
      });
    });


    //ScateSDK.ShowEventList();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SDK metadata: $_sdkMetadata\n'
                'Adjust: $_adjustStatus\n'
                'ADID: $_adjustId\n'
                'Remote config: $_remoteConfigValue\n',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
