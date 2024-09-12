import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'scatesdk_flutter_method_channel.dart';

abstract class ScatesdkFlutterPlatform extends PlatformInterface {
  /// Constructs a ScatesdkFlutterPlatform.
  ScatesdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScatesdkFlutterPlatform _instance = MethodChannelScatesdkFlutter();

  /// The default instance of [ScatesdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelScatesdkFlutter].
  static ScatesdkFlutterPlatform get instance => _instance;

  Stream<String> get eventsStream;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScatesdkFlutterPlatform] when
  /// they register themselves.
  static set instance(ScatesdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> Init(String appID) async {
    _instance.Init(appID);
  }

  Future<void> SetAdid(String adid) async {
    return _instance.SetAdid(adid);
  }

  Future<void> Event(String name) async {
    return _instance.Event(name);
  }

  Future<void> EventWithValue(String name, String value) async {
    return _instance.EventWithValue(name, value);
  }

  Future<String?> GetRemoteConfig(String key, String defaultValue) async {
    return _instance.GetRemoteConfig(key, defaultValue);
  }

  Future<void> AddListener(String name) async {
    return _instance.AddListener(name);
  }

  Future<void> RemoveListener(String name) async {
    return _instance.RemoveListener(name);
  }
}
