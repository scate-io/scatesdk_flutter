package com.scate.scatesdk_flutter

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import com.scate.scatesdk.ScateCoreSDK
import com.scate.scatesdk.models.RemoteConfigListener;
import org.json.JSONObject
import android.os.Handler
import android.os.Looper

/** ScatesdkFlutterPlugin */
class ScatesdkFlutterPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var context: Context
  private var eventSink: EventSink? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "scatesdk_flutter")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "scatesdk_flutter_events")
    methodChannel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)
    context = flutterPluginBinding.applicationContext // Obtain application context here

    val remoteConfigListener = PluginRemoteConfigListener()
    ScateCoreSDK.addRemoteConfigListener(remoteConfigListener)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "Init" -> {
                val appID: String? = call.argument("appID")
                ScateCoreSDK.init(appID, context)
                result.success(null)
            }
            "SetAdid" -> {
                val adid: String? = call.argument("adid")
                ScateCoreSDK.SetAdid(adid)
                result.success(null)
            }
            "Event" -> {
                val name: String? = call.argument("name")
                ScateCoreSDK.event(name)
                result.success(null)
            }
            "EventWithValue" -> {
                val name: String? = call.argument("name")
                val value: String? = call.argument("value")
                ScateCoreSDK.event(name, value)
                result.success(null)
            }
            "GetRemoteConfig" -> {
                val key: String? = call.argument("key")
                val defaultValue: String? = call.argument("defaultValue")
                val value = ScateCoreSDK.getRemoteConfig(key, defaultValue)
                result.success(value)
            }
            "AddListener" -> {
                result.success(null)
            }
            "RemoveListener" -> {
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

  // StreamHandler methods
  override fun onListen(arguments: Any?, events: EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  inner class PluginRemoteConfigListener : RemoteConfigListener {
    override fun onRemoteConfigInitialized(success: Boolean) {
        println("PluginRemoteConfigListener")
        val event = mutableMapOf<String, Any>()

        // Event name
        val eventName = "Scate_RemoteConfigsReady"
        event["event"] = eventName

        // Event data (success status)
        val data = mutableMapOf<String, Any>()
        data["remoteConfigFetched"] = success
        event["data"] = data

        try {
            // Convert the event map to a JSON string
            val eventJson = JSONObject(event as Map<*, *>).toString()

            // Ensure the event is sent on the main thread
            Handler(Looper.getMainLooper()).post {
                eventSink?.success(eventJson)
            }
            
        } catch (e: Exception) {
            println("Error converting event data to JSON: ${e.localizedMessage}")
        }
    }
}
}
