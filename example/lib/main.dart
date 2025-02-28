import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

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

    ScateSDK.AddListener(ScateEvents.ONBOARDING_SCREENS_FINISHED, (identifier) async {
      print('Onboarding Screens Finished: $identifier');
    });

    ScateSDK.AddListener(ScateEvents.PAYWALL_SCREEN_FINISHED,
        (identifier) async {
      print('Paywall Screen Finished: $identifier');
    });

    ScateSDK.AddListener(ScateEvents.PAID_PRODUCT_CLICKED,
        (identifier) async {
        print('Paid Product Clicked: $identifier');
    });

    ScateSDK.AddListener(ScateEvents.PAYWALL_SCREEN_CLOSED, (success) async {
      print('Paywall Screen Closed: $success');
      ScateSDK.ClosePaywall();
    });

    ScateSDK.AddListener(ScateEvents.ONBOARDING_SCREEN_CLOSED, (success) async {
      print('Onboarding Screen Closed: $success');
      ScateSDK.CloseOnboarding();
    });

    ScateSDK.AddListener(ScateEvents.RESTORE_PURCHASE_CLICKED, (success) async {
      print('Restore Purchase Clicked: $success');
    });

    ShowOnboarding();

    //ScateSDK.RemoveListener(ScateEvents.REMOTE_CONFIG_READY);
    //ScateSDK.ClearListeners(ScateEvents.REMOTE_CONFIG_READY);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void ShowPaywall() {
    final Map<String, dynamic> paywallData = {
      "media":
          "https://ninegshort.b-cdn.net/Apps/ScateSDK/InApp_Paywall_Image.png",
      "heading": "Unlock More!",
      "details": [
        "✓ Choose your plan",
        "✓ Right now",
        "✓ Right here",
        "✓ Fast"
      ],
      "paidProducts": [
        {
          "identifier": "Product1",
          "price": "\$9.99",
          "title": "Premium Plan",
          "discount": "20% OFF",
          "selectedBackgroundColor": "#5466c1",
          "unselectedBackgroundColor": "#495a6f",
          "selectedBorderColor": "#51338e",
          "unselectedBorderColor": "#7fb3d5",
        },
        {
          "identifier": "Product2",
          "price": "\$14.99",
          "title": "Pro Plan",
          "discount": "10% OFF",
          "selectedBackgroundColor": "#5466c1",
          "unselectedBackgroundColor": "#495a6f",
          "selectedBorderColor": "#51338e",
          "unselectedBorderColor": "#7fb3d5",
        },
        {
          "identifier": "Product3",
          "price": "\$19.99",
          "title": "Ultimate Plan",
          "discount": "",
          "selectedBackgroundColor": "#5466c1", 
          "unselectedBackgroundColor": "#495a6f", 
          "selectedBorderColor": "#51338e", 
          "unselectedBorderColor": "#7fb3d5", 
        }
      ],
      "selectedPaidProduct": "Product2",
      "buttonTitle": "Accept",
      "termsOfUse": "https://www.ign.com/articles/avowed-review",
      "privacyPolicy":
          "https://www.ign.com/articles/monster-hunter-wilds-review",
      "footNote": "Auto Renewable. Cancel Anytime.",
      "backgroundColor": "#000000",
      "actionButtonColor": "#5466c1"
    };

    String jsonString = jsonEncode(paywallData);

    ScateSDK.ShowPaywall(jsonString);
  }

  void ShowOnboarding() {
    final jsonString = jsonEncode([
      {
        "type": "basic",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/OB_Image.png",
        "heading": "Make your own music",
        "details": [
          "Mozart AI will analyze your photo or text",
          "to compose an incredible song just for you."
        ],
        "buttonTitle": "Continue",
        "paidProducts": [],
        "title": "Mozart AI",
        "backgroundColor": "#000000",
        "actionButtonColor": "#5466c1",
        "detailsColor": "#a62893"
      },
      {
        "type": "basic",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/OB_Image.png",
        "heading": "Apply your taste",
        "details": [
          "Let Mozart AI know your",
          "preferred style and genre for your song"
        ],
        "buttonTitle": "Continue",
        "paidProducts": [],
        "title": "Mozart AI",
        "backgroundColor": "#000000",
        "actionButtonColor": "#5466c1",
        "detailsColor": "#a62893"
      },
      {
        "type": "paywall",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/OB_Image.png",
        "heading": "Create, enjoy and share",
        "details": [
          "Mozart AI will compose",
          "Perfect song tailored to your needs."
        ],
        "buttonTitle": "Continue",
        "paidProducts": [
          {
            "price": "\$9.99",
            "discount": "20% OFF",
            "identifier": "Product1",
            "title": "Premium Plan",
            "selectedBackgroundColor": "#5466c1",
            "unselectedBackgroundColor": "#495a6f",
            "selectedBorderColor": "#51338e",
            "unselectedBorderColor": "#7fb3d5",
          },
          {
            "price": "\$14.99",
            "discount": "10% OFF",
            "identifier": "Product2",
            "title": "Pro Plan",
            "selectedBackgroundColor": "#5466c1",
            "unselectedBackgroundColor": "#495a6f",
            "selectedBorderColor": "#51338e",
            "unselectedBorderColor": "#7fb3d5",
          },
          {
            "identifier": "Product3",
            "discount": "",
            "title": "Ultimate Plan",
            "price": "\$19.99",
            "selectedBackgroundColor": "#5466c1",
            "unselectedBackgroundColor": "#495a6f",
            "selectedBorderColor": "#51338e",
            "unselectedBorderColor": "#7fb3d5",
          }
        ],
        "selectedPaidProduct": "Product2",
        "termsOfUse": "https://www.ign.com/articles/avowed-review",
        "privacyPolicy":
            "https://www.ign.com/articles/monster-hunter-wilds-review",
        "title": "Mozart AI",
        "footNote": "Auto Renewable. Cancel Anytime.",
        "backgroundColor": "#000000",
        "actionButtonColor": "#5466c1",
        "detailsColor": "#a62893"
      }
    ]);

    ScateSDK.ShowOnboarding(jsonString);
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
