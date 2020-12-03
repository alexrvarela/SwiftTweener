Pod::Spec.new do |s|
  s.name             = 'Tweener'
  s.version          = '2.1.1'
  s.summary          = 'Swift animation engine, make more powerful and creative Apps.'
  s.homepage         = 'https://github.com/alexrvarela/SwiftTweener'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alexrvarela' => 'https://github.com/alexrvarela' }
  s.source           = { :git => 'https://github.com/alexrvarela/SwiftTweener.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexrvarela'
  s.ios.deployment_target = '10.0'
  s.swift_version = "5.0"
  s.source_files = 'Source/*.{swift}'
end
