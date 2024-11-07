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
                "OnboardingStart" -> {
            ScateCoreSDK.OnboardingStart()
            result.success(null)
            }
            "OnboardingStep" -> {
                val step = call.argument<String>("step") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing step", null)
                    return
                }
                ScateCoreSDK.OnboardingStep(step)
                result.success(null)
            }
            "OnboardingFinish" -> {
                ScateCoreSDK.OnboardingFinish()
                result.success(null)
            }
            "LoginSuccess" -> {
                val source = call.argument<String>("source") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing source", null)
                    return
                }
                ScateCoreSDK.LoginSuccess(source)
                result.success(null)
            }
            "InterstitialAdShown" -> {
                ScateCoreSDK.InterstitialAdShown()
                result.success(null)
            }
            "InterstitialAdClosed" -> {
                ScateCoreSDK.InterstitialAdClosed()
                result.success(null)
            }
            "RewardedAdShown" -> {
                ScateCoreSDK.RewardedAdShown()
                result.success(null)
            }
            "RewardedAdClosed" -> {
                ScateCoreSDK.RewardedAdClosed()
                result.success(null)
            }
            "RewardedAdClaimed" -> {
                ScateCoreSDK.RewardedAdClaimed()
                result.success(null)
            }
            "BannerAdShown" -> {
                ScateCoreSDK.BannerAdShown()
                result.success(null)
            }
            "NotificationPermissionGranted" -> {
                ScateCoreSDK.NotificationPermissionGranted()
                result.success(null)
            }
            "NotificationPermissionDenied" -> {
                ScateCoreSDK.NotificationPermissionDenied()
                result.success(null)
            }
            "LocationPermissionGranted" -> {
                ScateCoreSDK.LocationPermissionGranted()
                result.success(null)
            }
            "LocationPermissionDenied" -> {
                ScateCoreSDK.LocationPermissionDenied()
                result.success(null)
            }
            "ATTPromptShown" -> {
                ScateCoreSDK.ATTPromptShown()
                result.success(null)
            }
            "ATTPermissionGranted" -> {
                ScateCoreSDK.ATTPermissionGranted()
                result.success(null)
            }
            "ATTPermissionDenied" -> {
                ScateCoreSDK.ATTPermissionDenied()
                result.success(null)
            }
            "PaywallShown" -> {
                val paywall = call.argument<String>("paywall") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing paywall", null)
                    return
                }
                ScateCoreSDK.PaywallShown(paywall)
                result.success(null)
            }
            "PaywallClosed" -> {
                val paywall = call.argument<String>("paywall") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing paywall", null)
                    return
                }
                ScateCoreSDK.PaywallClosed(paywall)
                result.success(null)
            }
            "PaywallAttempted" -> {
                val paywall = call.argument<String>("paywall") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing paywall", null)
                    return
                }
                ScateCoreSDK.PaywallAttempted(paywall)
                result.success(null)
            }
            "PaywallPurchased" -> {
                val paywall = call.argument<String>("paywall") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing paywall", null)
                    return
                }
                ScateCoreSDK.PaywallPurchased(paywall)
                result.success(null)
            }
            "PaywallCancelled" -> {
                val paywall = call.argument<String>("paywall") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing paywall", null)
                    return
                }
                ScateCoreSDK.PaywallCancelled(paywall)
                result.success(null)
            }
            "TabClicked" -> {
                val tab = call.argument<String>("tab") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing tab", null)
                    return
                }
                ScateCoreSDK.TabClicked(tab)
                result.success(null)
            }
            "FeatureClicked" -> {
                val feature = call.argument<String>("feature") ?: run {
                    result.error("INVALID_ARGUMENT", "Missing feature", null)
                    return
                }
                ScateCoreSDK.FeatureClicked(feature)
                result.success(null)
            }
            "DailyStreakShown" -> {
                ScateCoreSDK.DailyStreakShown()
                result.success(null)
            }
            "DailyStreakClaimed" -> {
                ScateCoreSDK.DailyStreakClaimed()
                result.success(null)
            }
            "DailyStreakClosed" -> {
                ScateCoreSDK.DailyStreakClosed()
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
