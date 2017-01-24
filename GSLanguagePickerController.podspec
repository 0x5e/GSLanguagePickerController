#
# Be sure to run `pod lib lint GSLanguagePickerController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GSLanguagePickerController'
  s.version          = '1.1.0'
  s.summary          = 'Support in-app runtime language switch, without application relaunch.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
GSLanguagePickerController is the imitate version of `Settings > General > Language & Region > iPhone Langage` ViewController. Support dynamic language switch, without application relaunch. The localizedString comes from `UIKit.framework/*.lproj` & `NSLocale`, no additional resources required.
                       DESC

  s.homepage         = 'https://github.com/0x5e/GSLanguagePickerController'
  s.screenshot       = 'https://github.com/0x5e/GSLanguagePickerController/blob/master/screenshoot.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaosen' => '0x5e@sina.cn' }
  s.source           = { :git => 'https://github.com/0x5e/GSLanguagePickerController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GSLanguagePickerController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GSLanguagePickerController' => ['GSLanguagePickerController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
