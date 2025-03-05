# ScateSDK Flutter Plugin



## Installation

Install via CLI;

```sh
flutter pub add scatesdk_flutter
```

Or

Add the following into your `pubspec.yaml` file;

```yaml
dependencies:
  scatesdk_flutter: ^0.4.11
```

## Android Integration

To ensure that the ScateSDK works properly on Android, you need to add the Maven repository to your build.gradle file.

In your project's android/build.gradle file, add the following Maven repository:

```
repositories {
        // Other repositories
        maven {
            url "https://europe-west1-maven.pkg.dev/mavenrepo-433814/scatecoresdk-android"
        }
    }
```   

## Usage

### Initialize the SDK

```dart
import 'package:scatesdk_flutter/scatesdk_flutter.dart';


class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    // ... Your initialization code
    // Adjust SDK initialization
    // ...
    // Initialize ScateSDK
    ScateSDK.Init("<your app id>");
    // make sure to set adid from Adjust SDK
    String adid = await Adjust.adid();
    ScateSDK.SetAdid(adid);
    

  }

}

```

### Send Events

To send events, you can use the following code:

```dart
    
ScateSDK.Event("button_clicked");

```

### Send Events with Additional Data

```dart

ScateSDK.EventWithValue("button_clicked", "subscribe_btn");

```

### Get Remote Config for Key

```dart

ScateSDK.GetRemoteConfig('key', 'defaultValue');

```

### Add Listener

```dart
ScateSDK.AddListener(ScateEvents.REMOTE_CONFIG_READY, (event) => {});
```

### Remove Listener

```dart
ScateSDK.RemoveListener(ScateEvents.REMOTE_CONFIG_READY);
```

### Clean Listeners

```dart
ScateSDK.CleanListeners(ScateEvents.REMOTE_CONFIG_READY);
```

### Onboarding Event Functions

```dart
ScateSDK.OnboardingStart();
ScateSDK.OnboardingStep("location_screen");
ScateSDK.OnboardingStep("notification_screen");
ScateSDK.OnboardingStep("personalization_screen");
ScateSDK.OnboardingStep("journey_screen");
ScateSDK.OnboardingStep("intro_paywall_screen");
ScateSDK.OnboardingStep("fullscreen_ad");
ScateSDK.OnboardingFinish();
```

### Login Event Functions

```dart
ScateSDK.LoginSuccess("apple");
ScateSDK.LoginSuccess("email");
ScateSDK.LoginSuccess("fb");
ScateSDK.LoginSuccess("google");
```

### Ad Event Functions

```dart
ScateSDK.InterstitialAdShown();
ScateSDK.InterstitialAdClosed();
ScateSDK.RewardedAdShown();
ScateSDK.RewardedAdClosed();
ScateSDK.RewardedAdClaimed();
ScateSDK.BannerAdShown();
```

### Permission Event Functions

```dart
ScateSDK.NotificationPermissionGranted();
ScateSDK.NotificationPermissionDenied();
ScateSDK.LocationPermissionGranted();
ScateSDK.LocationPermissionDenied();
ScateSDK.ATTPromptShown();
ScateSDK.ATTPermissionGranted();
ScateSDK.ATTPermissionDenied();
```

### Paywall Event Functions

```dart
ScateSDK.PaywallShown("paywall_name");
ScateSDK.PaywallClosed("paywall_name");
ScateSDK.PaywallAttempted("paywall_name");
ScateSDK.PaywallPurchased("paywall_name");
ScateSDK.PaywallCancelled("paywall_name");
```

### Tab And Feature Event Functions

```dart
ScateSDK.TabClicked("x");
ScateSDK.FeatureClicked("x");
```

### Daily Streak Event Functions

```dart
ScateSDK.DailyStreakShown();
ScateSDK.DailyStreakClaimed();
ScateSDK.DailyStreakClosed();
```