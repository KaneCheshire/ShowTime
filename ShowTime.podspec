#
# Be sure to run `pod lib lint ShowTime.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShowTime'
  s.version          = '2.5.2'
  s.summary          = 'The easiest way to show off your iOS taps and gestures for demos.'
  s.description      = <<-DESC
  ShowTime displays all your taps and gestures on screen, perfect for that demo, presentation or video.
  One file is all you need to turbo-boost your demos. ShowTime even displays the level of force you're applying, and can be configured to show the actual number of taps performed. Apple Pencil events are configurable and disabled by default.
  ShowTime works with single- and multi-window setups, as well as with Swift and Objective-C projects.
  ShowTime works best when mirroring your screen or recording through QuickTime. By default the size of the visual touches are 44pt; this mirrors Apple's guidelines for minimim hit size for buttons on iOS. You're free to change this though of course.
  Showing your gestures during demos helps give your audience a much clearer context on what's happening on your device. Consider trying ShowTime for your next demo!
                       DESC

  s.homepage         = 'https://github.com/kanecheshire/ShowTime'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'kanecheshire' => 'kane.cheshire@googlemail.com' }
  s.source           = { :git => 'https://github.com/kanecheshire/ShowTime.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kanecheshire'

  s.ios.deployment_target = '8.2'
  s.swift_version = '5.0'

  s.source_files = 'Sources/ShowTime/ShowTime.swift'
end
