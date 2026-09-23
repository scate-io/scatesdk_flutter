#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint scatesdk_flutter.podspec` to validate before publishing.
#
require 'json'

scate_sdk_version = '7.0.20'

# ScateSDKFirebase logs purchases to Firebase. It is added when the app uses the firebase_analytics plugin on
# Firebase 12.5.0 or later, the version it needs; an app without Firebase is left as it is.
scate_app_firebase_version = lambda do
  app_dir = File.dirname(Pod::Config.instance.installation_root.to_s)
  plugins = JSON.parse(File.read(File.join(app_dir, '.flutter-plugins-dependencies'))).dig('plugins', 'ios') || []
  next nil unless plugins.any? { |plugin| plugin['name'] == 'firebase_analytics' }
  next $FirebaseSDKVersion if defined?($FirebaseSDKVersion)

  firebase_core = plugins.find { |plugin| plugin['name'] == 'firebase_core' }
  File.read(File.join(firebase_core['path'], 'ios', 'firebase_sdk_version.rb'))[/'(\d+\.\d+\.\d+)'/, 1]
rescue ::StandardError # Pod::StandardError would shadow it here
  nil
end
scate_firebase_version = scate_app_firebase_version.call

Pod::Spec.new do |s|
  s.name             = 'scatesdk_flutter'
  s.version          = '7.0.9'
  s.summary          = 'Scate SDK is made for developers to integrate Scate\'s services into their apps. Please visit https://www.scate.io for more information.'
  s.homepage         = 'https://github.com/scate-io/scatesdk_flutter.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Scate' => 'e@inscate.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency "ScateSDK", scate_sdk_version
  if scate_firebase_version && Gem::Version.new(scate_firebase_version) >= Gem::Version.new('12.5.0')
    s.dependency "ScateSDKFirebase", scate_sdk_version
  end
  s.dependency "Adjust/AdjustGoogleOdm", "~> 5.6.1"
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
