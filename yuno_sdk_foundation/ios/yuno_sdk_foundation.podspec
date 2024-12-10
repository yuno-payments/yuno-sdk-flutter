#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint yuno_sdk_foundation.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'yuno_sdk_foundation'
  s.version          = '0.4.0'
  s.summary          = 'A Yuno project'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://www.y.uno/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yuno' => 'support@yunopayments.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'YunoSDK', '1.20.0'
  s.platform = :ios, '14.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES'}
  s.swift_version = '5.0'
  s.static_framework = true
end
