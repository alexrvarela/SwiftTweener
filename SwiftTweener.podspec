Pod::Spec.new do |s|
  s.name             = 'SwiftTweener'
  s.version          = '1.0.0'
  s.summary          = 'Animation engine for iOs, make more powerfull and creative Apps.'
  s.homepage         = 'https://github.com/alexrvarela/SwiftTweener'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alexrvarela' => 'https://github.com/alexrvarela' }
  s.source           = { :git => 'https://github.com/alexrvarela/SwiftTweener.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexrvarela'
  s.ios.deployment_target = '10.0'
  s.swift_version = "4.2"
  s.source_files = 'Source/*.{swift}'
end
