import Flutter
import UIKit
import ScateSDK

public class ScatesdkFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var eventListeners: [String: NSObjectProtocol] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "scatesdk_flutter", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "scatesdk_flutter_events", binaryMessenger: registrar.messenger())
        
        let instance = ScatesdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "Init":
            guard let args = call.arguments as? [String: Any],
                  let appId = args["appID"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing appID", details: nil))
                return
            }
            ScateCoreSDK.Init(appID: appId)
            result(nil)
        case "SetAdid":
            guard let args = call.arguments as? [String: Any],
                  let adid = args["adid"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing adid", details: nil))
                return
            }
            ScateCoreSDK.SetAdid(adid: adid)
            result(nil)
        case "Event":
            guard let args = call.arguments as? [String: Any],
                  let name = args["name"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing name", details: nil))
                return
            }
            ScateCoreSDK.Event(name: name)
            result(nil)
        case "EventWithValue":
            guard let args = call.arguments as? [String: Any],
                  let name = args["name"] as? String,
                  let value = args["value"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing name or value", details: nil))
                return
            }
            ScateCoreSDK.Event(name: name, customValue: value)
            result(nil)
        case "GetRemoteConfig":
            guard let args = call.arguments as? [String: Any],
                  let key = args["key"] as? String,
                  let defaultValue = args["defaultValue"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing key or defaultValue", details: nil))
                return
            }
            let value = ScateCoreSDK.GetRemoteConfig(key: key, defaultValue: defaultValue)
            result(value)
        case "AddListener":
            guard let args = call.arguments as? [String: Any],
                  let name = args["name"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing listener name", details: nil))
                return
            }
            addListener(name)
            result(nil)
        case "RemoveListener":
            guard let args = call.arguments as? [String: Any],
                  let name = args["name"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing listener name", details: nil))
                return
            }
            removeListener(name)
            result(nil)
        case "OnboardingStart":
            ScateCoreSDK.OnboardingStart()
            result(nil)
            
        case "OnboardingStep":
            guard let args = call.arguments as? [String: Any],
                  let step = args["step"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing step", details: nil))
                return
            }
            ScateCoreSDK.OnboardingStep(step: step)
            result(nil)
            
        case "OnboardingFinish":
            ScateCoreSDK.OnboardingFinish()
            result(nil)
            
        case "LoginSuccess":
            guard let args = call.arguments as? [String: Any],
                  let source = args["source"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing source", details: nil))
                return
            }
            ScateCoreSDK.LoginSuccess(source: source)
            result(nil)
            
        case "InterstitialAdShown":
            ScateCoreSDK.InterstitialAdShown()
            result(nil)
            
        case "InterstitialAdClosed":
            ScateCoreSDK.InterstitialAdClosed()
            result(nil)
            
        case "RewardedAdShown":
            ScateCoreSDK.RewardedAdShown()
            result(nil)
            
        case "RewardedAdClosed":
            ScateCoreSDK.RewardedAdClosed()
            result(nil)
            
        case "RewardedAdClaimed":
            ScateCoreSDK.RewardedAdClaimed()
            result(nil)
            
        case "BannerAdShown":
            ScateCoreSDK.BannerAdShown()
            result(nil)
            
        case "NotificationPermissionGranted":
            ScateCoreSDK.NotificationPermissionGranted()
            result(nil)
            
        case "NotificationPermissionDenied":
            ScateCoreSDK.NotificationPermissionDenied()
            result(nil)
            
        case "LocationPermissionGranted":
            ScateCoreSDK.LocationPermissionGranted()
            result(nil)
            
        case "LocationPermissionDenied":
            ScateCoreSDK.LocationPermissionDenied()
            result(nil)
            
        case "ATTPromptShown":
            ScateCoreSDK.ATTPromptShown()
            result(nil)
            
        case "ATTPermissionGranted":
            ScateCoreSDK.ATTPermissionGranted()
            result(nil)
            
        case "ATTPermissionDenied":
            ScateCoreSDK.ATTPermissionDenied()
            result(nil)
            
        case "PaywallShown":
            guard let args = call.arguments as? [String: Any],
                  let paywall = args["paywall"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.PaywallShown(paywall: paywall)
            result(nil)
            
        case "PaywallClosed":
            guard let args = call.arguments as? [String: Any],
                  let paywall = args["paywall"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.PaywallClosed(paywall: paywall)
            result(nil)
            
        case "PaywallAttempted":
            guard let args = call.arguments as? [String: Any],
                  let paywall = args["paywall"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.PaywallAttempted(paywall: paywall)
            result(nil)
            
        case "PaywallPurchased":
            guard let args = call.arguments as? [String: Any],
                  let paywall = args["paywall"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.PaywallPurchased(paywall: paywall)
            result(nil)
            
        case "PaywallCancelled":
            guard let args = call.arguments as? [String: Any],
                  let paywall = args["paywall"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.PaywallCancelled(paywall: paywall)
            result(nil)
            
        case "TabClicked":
            guard let args = call.arguments as? [String: Any],
                  let tab = args["tab"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing tab", details: nil))
                return
            }
            ScateCoreSDK.TabClicked(tab: tab)
            result(nil)
            
        case "FeatureClicked":
            guard let args = call.arguments as? [String: Any],
                  let feature = args["feature"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing feature", details: nil))
                return
            }
            ScateCoreSDK.FeatureClicked(feature: feature)
            result(nil)
            
        case "DailyStreakShown":
            ScateCoreSDK.DailyStreakShown()
            result(nil)
            
        case "DailyStreakClaimed":
            ScateCoreSDK.DailyStreakClaimed()
            result(nil)
            
        case "DailyStreakClosed":
            ScateCoreSDK.DailyStreakClosed()
            result(nil)   

        case "ShowPaywall":
            guard let args = call.arguments as? [String: Any],
                  let jsonString = args["jsonString"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.ShowPaywall(jsonString: jsonString)
            result(nil) 
        case "ShowOnboarding":
            guard let args = call.arguments as? [String: Any],
                  let jsonString = args["jsonString"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing paywall", details: nil))
                return
            }
            ScateCoreSDK.ShowOnboarding(jsonString: jsonString)
            result(nil)
        case "ClosePaywall":
            ScateCoreSDK.ClosePaywall()
            result(nil)   
        case "CloseOnboarding":
            ScateCoreSDK.CloseOnboarding()
            result(nil)  
        case "ClosePaidProductLoadingScreen":
            ScateCoreSDK.ClosePaidProductLoadingScreen()
            result(nil)  
        case "ShowEventList":
            ScateCoreSDK.ShowEventList()
            result(nil) 
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    private func addListener(_ name: String) {
        let observer = NotificationCenter.default.addObserver(forName: Notification.Name(name), object: nil, queue: nil) { [weak self] notification in
            self?.handleListener(notification: notification)
        }
        eventListeners[name] = observer
    }
    
    private func removeListener(_ name: String) {
        if let observer = eventListeners[name] {
            NotificationCenter.default.removeObserver(observer)
            eventListeners[name] = nil
        }
    }
    
    @objc func handleListener(notification: Notification) {
        var event: [String: Any] = [:]
   
        do{
            let eventName = notification.name.rawValue
            event["event"] = eventName
            event["data"] = notification.userInfo
            
            do {
                let eventData = try JSONSerialization.data(withJSONObject: event, options: [])
                if let jsonString = String(data: eventData, encoding: .utf8) {
                    DispatchQueue.main.async {
                        // Ensure eventSink operation is on main thread
                        self.eventSink?(jsonString)
                    }
                }
            } catch {
                print("Error converting event data to JSON: \(error.localizedDescription)")
            }
        }
    }
}
