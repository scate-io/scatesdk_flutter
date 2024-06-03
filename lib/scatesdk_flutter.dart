
import 'scatesdk_flutter_platform_interface.dart';

class ScateSDK {
 
  static Future<void> Init(String appID){
    return ScatesdkFlutterPlatform.instance.Init(appID);
  }

  static Future<void> SetAdid(String adid){
    return ScatesdkFlutterPlatform.instance.SetAdid(adid);
  }

  static Future<void> Event(String name){
    return ScatesdkFlutterPlatform.instance.Event(name);
  }

  static Future<void> EventWithValue(String name, String value){
    return ScatesdkFlutterPlatform.instance.EventWithValue(name, value);
  }

}
