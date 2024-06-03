import Flutter
import UIKit
import ScateSDK

public class ScatesdkFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "scatesdk_flutter", binaryMessenger: registrar.messenger())
    let instance = ScatesdkFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
