#
# Be sure to run `pod lib lint ShowTime.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShowTime'
  s.version          = '1.0.0'
  s.summary          = 'A short description of ShowTime.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kanecheshire/ShowTime'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kanecheshire' => 'kane.cheshire@googlemail.com' }
  s.source           = { :git => 'https://github.com/kanecheshire/ShowTime.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kanecheshire'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ShowTime/Classes/**/*', 'ShowTime.swift'
end
