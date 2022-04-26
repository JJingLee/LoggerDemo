#
# Be sure to run `pod lib lint JKOLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKOLogger'
  s.version          = '0.2.0'
  s.summary          = 'JKOLogger.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://gitlab.jkopay.com.tw/Source/IOS/JKOSLogger'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'JKO Pay iOS' => 'jkopay.iOS@gmail.com' }
  s.source           = { :git => 'http://gitlab.jkopay.com.tw/Source/IOS/JKOSLogger.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.info_plist = {
    'CFBundleIdentifier' => 'com.jkos.JKOLogger'
  }
  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.jkos.JKOLogger'
  }

  s.ios.deployment_target = '11.0'
  s.swift_version        = '5'

  s.source_files = 'JKOLogger/Classes/**/*','JKOLogger/Classes/*'

  # s.resources            = 'JKOLogger/Assets/JKOLogger.xcassets'
  # s.resource_bundles = {
  #   'JKOLogger' => ['JKOLogger/Assets/**/*']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.ios.frameworks = 'UIKit', 'Foundation'
end
