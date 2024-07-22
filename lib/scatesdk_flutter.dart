import 'scatesdk_flutter_platform_interface.dart';

enum ScateEvents {
  REMOTE_CONFIG_READY,
}

extension ScateEventsExtension on ScateEvents {
  String get name {
    switch (this) {
      case ScateEvents.REMOTE_CONFIG_READY:
        return 'Scate_RemoteConfigsReady';
    }
  }
}

class ScateSDK {
  static final Map<String, Map<String, Function>> _listeners = {};

  static Future<void> Init(String appID) {
    return ScatesdkFlutterPlatform.instance.Init(appID);
  }

  static Future<void> SetAdid(String adid) {
    return ScatesdkFlutterPlatform.instance.SetAdid(adid);
  }

  static Future<void> Event(String name) {
    return ScatesdkFlutterPlatform.instance.Event(name);
  }

  static Future<void> EventWithValue(String name, String value) async {
    await ScatesdkFlutterPlatform.instance.EventWithValue(name, value);
  }

  static Future<String?> GetRemoteConfig(
      String key, String defaultValue) async {
    return await ScatesdkFlutterPlatform.instance
        .GetRemoteConfig(key, defaultValue);
  }

  static String AddListener(ScateEvents eventType, Function listener) {
    var name = eventType.name;
    final listenerId = DateTime.now().millisecondsSinceEpoch.toString();

    if (!_listeners.containsKey(name)) {
      _listeners[name] = {};
      ScatesdkFlutterPlatform.instance.AddListener(name);
      ScatesdkFlutterPlatform.instance.eventsStream.listen((event) {
        HandleEvent(name, event);
      });
    }

    _listeners[name]![listenerId] = listener;
    return listenerId;
  }

  static void RemoveListener(ScateEvents eventType, String listenerId) {
    var name = eventType.name;
    final listeners = _listeners[name];
    if (listeners != null) {
      listeners.remove(listenerId);
      if (listeners.isEmpty) {
        _listeners.remove(name);
        ScatesdkFlutterPlatform.instance.RemoveListener(name);
      }
    }
  }

  static void ClearListeners(ScateEvents eventType) {
    var name = eventType.name;
    _listeners.remove(name);
    ScatesdkFlutterPlatform.instance.RemoveListener(name);
  }

  static void HandleEvent(String name, dynamic event) {
    final listeners = _listeners[name];
    if (listeners != null) {
      listeners.values.toList().forEach((listener) {
        listener(event);
      });
    }
  }
}
