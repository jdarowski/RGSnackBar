#
# Be sure to run `pod lib lint RGSnackBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RGSnackBar'
  s.version          = '0.4.0'
  s.summary          = 'A small, yet robust and extensible snackbar for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
RGSnackBar is a small library that allows you to queue certain messages and later display them in a view you like.

It comes with default ways to display messages and a lot of possibilities.

More will come.
                       DESC

  s.homepage         = 'https://github.com/jdarowski/RGSnackBar'
  s.license          = { :type => 'MIT  ', :file => 'LICENSE' }
  s.author           = { 'kuvisit' => 'kuvisit@gmail.com' }
  s.source           = { :git => 'https://github.com/jdarowski/RGSnackBar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'RGSnackBar/Classes/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'SwiftPriorityQueue', '~> 1.1.0'
  s.dependency 'SteviaLayout', '~> 3.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.2' }
end
