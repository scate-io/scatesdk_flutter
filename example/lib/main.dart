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
  
    // Example ScateSDK event functions.
    // If you need to send events, you can use these functions.
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

      setState(() {
        _remoteConfigValue = 'Remote -> ' +
            (remoteConfig ?? 'not found') +
            '\n success -> ' +
            success.toString(); // Convert boolean to string
      });
    });

    ScateSDK.AddListener(ScateEvents.ONBOARDING_SCREENS_FINISHED,
        (identifier) async {
      print('Onboarding Screens Finished: $identifier');
      ScateSDK.ShowPaidProductLoadingScreen();
      Future.delayed(const Duration(seconds: 5), () {
        ScateSDK.ClosePaidProductLoadingScreen();
      });
    });

    ScateSDK.AddListener(ScateEvents.PAYWALL_SCREEN_FINISHED,
        (identifier) async {
      print('Paywall Screen Finished: $identifier');
      ScateSDK.ShowPaidProductLoadingScreen();
      Future.delayed(const Duration(seconds: 5), () {
        ScateSDK.ClosePaidProductLoadingScreen();
      });
    });

    ScateSDK.AddListener(ScateEvents.PAID_PRODUCT_CLICKED, (identifier) async {
      print('Paid Product Clicked: $identifier');
      ScateSDK.ShowPaidProductLoadingScreen();
      Future.delayed(const Duration(seconds: 5), () {
        ScateSDK.ClosePaidProductLoadingScreen();
      });
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
    //ShowPaywall();

    //ScateSDK.ShowEventList();

    //ScateSDK.RemoveListener(ScateEvents.REMOTE_CONFIG_READY);
    //ScateSDK.ClearListeners(ScateEvents.REMOTE_CONFIG_READY);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void ShowPaywall() {
    // For media, you can also use an image path like this
    /*
    import 'package:path_provider/path_provider.dart';

    Future<String> getAssetFilePath(String assetPath) async {
      try {
        // Load the asset from the bundle
        final byteData = await rootBundle.load(assetPath);
        // Get the temporary directory
        final tempDir = await getTemporaryDirectory();
        // Extract the file name from the asset path (if any)
        final fileName = assetPath.split('/').last;
        // Create a file in the temporary directory
        final file = File('${tempDir.path}/$fileName');
        // Write the asset data to the file
        await file.writeAsBytes(byteData.buffer.asUint8List());
        // Return the file path with the 'file://' scheme
        return Uri.file(file.path).toString();
      } catch (e) {
        print("Error getting asset file path: $e");
        // Return an empty string or default path on error
        return "";
      }
    }

    // Specify the full path of the asset file
    String assetFullPath = "assets/images/png/app_logo_s.png";

    // Get the file path from the asset
    String fileUrl = await getAssetFilePath(assetFullPath);
    */

    final Map<String, dynamic> paywallData = {
      "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
      "heading": "Heading",
      "details": ["✓ Details 1", "✓ Details 2", "✓ Details 3", "✓ Details 4"],
      "paidProducts": [
        {
          "selectedBackgroundColor": "#252f60",
          "unselectedBackgroundColor": "#1E1E1E",
          "unselectedBorderColor": "#174d67",
          "badgeSelectedColor": "#9747FF",
          "identifier": "Identifier1",
          "title": "[Product]",
          "badgeText": "Badge1",
          "badgeUnselectedColor": "#587BF6",
          "selectedBorderColor": "#4a3288",
          "price": "\$Price1",
          "badgeTextColor": "#ffffff",
          "titleColor": "#ffffff",
          "priceColor": "#ffffff",
        },
        {
          "tagUnselectedColor": "#587BF6",
          "badgeSelectedColor": "#9747FF",
          "unselectedBackgroundColor": "#1E1E1E",
          "badgeText": "Badge2",
          "tagSelectedColor": "#058ed2",
          "price": "\$Price2",
          "identifier": "Identifier2",
          "unselectedBorderColor": "#174d67",
          "badgeUnselectedColor": "#587BF6",
          "title": "[Product]",
          "selectedBackgroundColor": "#252f60",
          "selectedBorderColor": "#4a3288",
          "tagText": "Tag2",
          "badgeTextColor": "#ffffff",
          "titleColor": "#ffffff",
          "priceColor": "#ffffff",
          "tagTextColor": "#ffffff"
        },
        {
          "descriptionText": "Description",
          "unselectedBackgroundColor": "#1E1E1E",
          "price": "\$Price3",
          "identifier": "Identifier3",
          "selectedBackgroundColor": "#252f60",
          "selectedBorderColor": "#4a3288",
          "unselectedBorderColor": "#174d67",
          "title": "[Product]",
          "titleColor": "#ffffff",
          "priceColor": "#ffffff",
          "descriptionTextColor": "#ffffff"
        }
      ],
      "selectedPaidProduct": "Identifier2",
      "buttonTitle": "Button",
      "termsOfUse": "https://www.google.com/",
      "privacyPolicy": "https://www.google.com/",
      "footNote": "Auto Renewable. Cancel Anytime.",
      "backgroundColor": "#000000",
      "actionButtonColor1": "#587BF6",
      "actionButtonColor2": "#2C58F3",
      "headingColor": "#ffffff",
      "buttonTitleColor": "#ffffff",
      "termsOfUseColor": "#ffffff",
      "footNoteColor": "#ffffff",
      "restoreButtonColor": "#ffffff",
      "privacyPolicyColor": "#ffffff",
      "detailsColor": "#ffffff",
    };

    String jsonString = jsonEncode(paywallData);

    ScateSDK.ShowPaywall(jsonString);
  }

  void ShowOnboarding() {
    // For media, you can also use an image path like this
    /*

    import 'package:path_provider/path_provider.dart';

    Future<String> getAssetFilePath(String assetPath) async {
      try {
        // Load the asset from the bundle
        final byteData = await rootBundle.load(assetPath);
        // Get the temporary directory
        final tempDir = await getTemporaryDirectory();
        // Extract the file name from the asset path (if any)
        final fileName = assetPath.split('/').last;
        // Create a file in the temporary directory
        final file = File('${tempDir.path}/$fileName');
        // Write the asset data to the file
        await file.writeAsBytes(byteData.buffer.asUint8List());
        // Return the file path with the 'file://' scheme
        return Uri.file(file.path).toString();
      } catch (e) {
        print("Error getting asset file path: $e");
        // Return an empty string or default path on error
        return "";
      }
    }

    // Specify the full path of the asset file
    String assetFullPath = "assets/images/png/app_logo_s.png";

    // Get the file path from the asset
    String fileUrl = await getAssetFilePath(assetFullPath);
    */

    final jsonString = jsonEncode([
      {
        "type": "basic",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
        "heading": "Heading 1",
        "buttonTitle": "Button 1",
        "paidProducts": [],
        "title": "[App Name]",
        "backgroundColor": "#000000",
        "actionButtonColor1": "#587BF6",
        "actionButtonColor2": "#2C58F3",
        "titleColor": "#ffffff",
        "headingColor": "#ffffff",
        "buttonTitleColor": "#ffffff"
      },
      {
        "type": "basic",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
        "heading": "Heading 2",
        "buttonTitle": "Button 2",
        "paidProducts": [],
        "title": "[App Name]",
        "backgroundColor": "#000000",
        "actionButtonColor1": "#587BF6",
        "actionButtonColor2": "#2C58F3",
        "titleColor": "#ffffff",
        "headingColor": "#ffffff",
        "buttonTitleColor": "#ffffff"
      },
      {
        "type": "paywall",
        "media": "https://ninegshort.b-cdn.net/Apps/ScateSDK/ob_sample.png",
        "heading": "Heading 3",
        "buttonTitle": "Button 3",
        "paidProducts": [
          {
            "selectedBackgroundColor": "#252f60",
            "unselectedBackgroundColor": "#1E1E1E",
            "unselectedBorderColor": "#174d67",
            "badgeSelectedColor": "#9747FF",
            "identifier": "Identifier1",
            "title": "[Product]",
            "badgeText": "Badge1",
            "badgeUnselectedColor": "#587BF6",
            "selectedBorderColor": "#4a3288",
            "price": "\$Price1",
            "badgeTextColor": "#ffffff",
            "titleColor": "#ffffff",
            "priceColor": "#ffffff",
          },
          {
            "tagUnselectedColor": "#587BF6",
            "badgeSelectedColor": "#9747FF",
            "unselectedBackgroundColor": "#1E1E1E",
            "badgeText": "Badge2",
            "tagSelectedColor": "#058ed2",
            "price": "\$Price2",
            "identifier": "Identifier2",
            "unselectedBorderColor": "#174d67",
            "badgeUnselectedColor": "#587BF6",
            "title": "[Product]",
            "selectedBackgroundColor": "#252f60",
            "selectedBorderColor": "#4a3288",
            "tagText": "Tag2",
            "badgeTextColor": "#ffffff",
            "titleColor": "#ffffff",
            "priceColor": "#ffffff",
            "tagTextColor": "#ffffff"
          },
          {
            "descriptionText": "Description",
            "unselectedBackgroundColor": "#1E1E1E",
            "price": "\$Price3",
            "identifier": "Identifier3",
            "selectedBackgroundColor": "#252f60",
            "selectedBorderColor": "#4a3288",
            "unselectedBorderColor": "#174d67",
            "title": "[Product]",
            "titleColor": "#ffffff",
            "priceColor": "#ffffff",
            "descriptionTextColor": "#ffffff"
          }
        ],
        "selectedPaidProduct": "Identifier2",
        "termsOfUse": "https://www.google.com/",
        "privacyPolicy": "https://www.google.com/",
        "title": "[App Name]",
        "footNote": "Auto Renewable, Cancel Anytime",
        "backgroundColor": "#000000",
        "actionButtonColor1": "#587BF6",
        "actionButtonColor2": "#2C58F3",
        "titleColor": "#ffffff",
        "headingColor": "#ffffff",
        "buttonTitleColor": "#ffffff",
        "termsOfUseColor": "#D3D3D3",
        "footNoteColor": "#D3D3D3",
        "restoreButtonColor": "#D3D3D3",
        "privacyPolicyColor": "#D3D3D3"
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
