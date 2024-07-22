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
