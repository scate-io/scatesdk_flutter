#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint scatesdk_flutter.podspec` to validate before publishing.
#
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
  # The iOS SDK binary ships inside this package instead of coming from the ScateSDK pod:
  # CocoaPods trunk is read-only from 2 December 2026. sdk-release.sh replaces it each release.
  s.vendored_frameworks = 'ScateSDK.xcframework'
  s.dependency "Adjust/AdjustGoogleOdm", "~> 5.6.1"
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
