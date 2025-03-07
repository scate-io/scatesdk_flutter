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

    //ShowOnboarding();
    //ShowPaywall();

    ScateSDK.ShowEventList();

    //ScateSDK.RemoveListener(ScateEvents.REMOTE_CONFIG_READY);
    //ScateSDK.ClearListeners(ScateEvents.REMOTE_CONFIG_READY);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void ShowPaywall() {

    //For media you can also use image path like this
    //String imagePath = "/path/to/image.jpg";
    //String fileUrl = Uri.file(imagePath).toString();

    final Map<String, dynamic> paywallData = {
      "media":
          "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
      "heading": "Heading",
      "details":  ["✓ Details 1", "✓ Details 2", "✓ Details 3", "✓ Details 4"],
      "paidProducts": [
        {
          "selectedBackgroundColor": "#22264B",
          "unselectedBackgroundColor": "#1E1E1E",
          "unselectedBorderColor": "#587BF6",
          "badgeSelectedColor": "#9747FF",
          "identifier": "Identifier1",
          "title": "[Product]",
          "badgeText": "Badge1",
          "badgeUnselectedColor": "#587BF6",
          "selectedBorderColor": "#EA43FB",
          "price": "\$Price1"
        },
        {
          "tagUnselectedColor": "#587BF6",
          "badgeSelectedColor": "#9747FF",
          "unselectedBackgroundColor": "#1E1E1E",
          "badgeText": "Badge2",
          "tagSelectedColor": "#587BF6",
          "price": "\$Price2",
          "identifier": "Identifier2",
          "unselectedBorderColor": "#587BF6",
          "badgeUnselectedColor": "#587BF6",
          "title": "[Product]",
          "selectedBackgroundColor": "#22264B",
          "selectedBorderColor": "#EA43FB",
          "tagText": "Tag2"
        },
        {
          "descriptionText": "Description",
          "unselectedBackgroundColor": "#1E1E1E",
          "price": "\$Price3",
          "identifier": "Identifier3",
          "selectedBackgroundColor": "#22264B",
          "selectedBorderColor": "#EA43FB",
          "unselectedBorderColor": "#587BF6",
          "title": "[Product]"
        }
      ],
      "selectedPaidProduct": "Identifier2",
      "buttonTitle": "Button",
      "termsOfUse": "https://www.google.com/",
      "privacyPolicy":
          "https://www.google.com/",
      "footNote": "Auto Renewable. Cancel Anytime.",
      "backgroundColor": "#000000",
      "actionButtonColor": "#5466c1"
    };

    String jsonString = jsonEncode(paywallData);

    ScateSDK.ShowPaywall(jsonString);
  }

  void ShowOnboarding() {

    //For media you can also use image path like this
    //String imagePath = "/path/to/image.jpg";
    //String fileUrl = Uri.file(imagePath).toString();

    final jsonString = jsonEncode([
      {
        "type": "basic",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
        "heading": "Heading 1",
        "details":  ["Details 1", "Details 2"],
        "buttonTitle": "Button 1",
        "paidProducts": [],
        "title": "[App Name]",
        "backgroundColor": "#000000",
        "actionButtonColor": "#2C58F3",
        "detailsColor": "#a62893"
      },
      {
        "type": "basic",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
        "heading": "Heading 2",
        "details": ["Details 1", "Details 2"],
        "buttonTitle": "Button 2",
        "paidProducts": [],
        "title": "[App Name]",
        "backgroundColor": "#000000",
        "actionButtonColor": "#2C58F3",
        "detailsColor": "#a62893"
      },
      {
        "type": "paywall",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
        "heading": "Heading 3",
        "details": ["Details 1", "Details 2"],
        "buttonTitle": "Button 3",
        "paidProducts": [
          {"selectedBackgroundColor":"#22264B",
          "unselectedBackgroundColor":"#1E1E1E",
          "unselectedBorderColor":"#587BF6",
          "badgeSelectedColor":"#9747FF",
          "identifier":"Identifier1",
          "title":"[Product]",
          "badgeText":"Badge1",
          "badgeUnselectedColor":"#587BF6",
          "selectedBorderColor":"#EA43FB",
          "price":"\$Price1"},
          {"tagUnselectedColor":"#587BF6",
          "badgeSelectedColor":"#9747FF",
          "unselectedBackgroundColor":"#1E1E1E",
          "badgeText":"Badge2",
          "tagSelectedColor":"#587BF6",
          "price":"\$Price2",
          "identifier":"Identifier2",
          "unselectedBorderColor":"#587BF6",
          "badgeUnselectedColor":"#587BF6",
          "title":"[Product]",
          "selectedBackgroundColor":"#22264B",
          "selectedBorderColor":"#EA43FB",
          "tagText":"Tag2"},
          {"descriptionText":"Description",
          "unselectedBackgroundColor":"#1E1E1E",
          "price":"\$Price3",
          "identifier":"Identifier3",
          "selectedBackgroundColor":"#22264B",
          "selectedBorderColor":"#EA43FB",
          "unselectedBorderColor":"#587BF6",
          "title":"[Product]"}],
        "selectedPaidProduct": "Identifier2",
        "termsOfUse": "https://www.google.com/",
        "privacyPolicy":"https://www.google.com/",
        "title": "[App Name]",
        "footNote":"Auto Renewable, Cancel Anytime",
        "backgroundColor":"#000000",
        "actionButtonColor": "#2C58F3",
        "detailsColor": "#a62893"
      }]);

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
