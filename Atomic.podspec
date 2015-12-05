Pod::Spec.new do |s|
  s.name = 'Atomic'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Atomic is a fast, safe way to make values atomic (thread-safe).'
  s.homepage = 'https://github.com/Adlai-Holler/Atomic'
  s.social_media_url = 'http://twitter.com/adlaih'
  s.authors = { 'Adlai Holler' => 'him@adlai.io' }
  s.source = { :git => 'https://github.com/Adlai-Holler/Atomic.git', :tag => 'v1.0.0' }

  s.ios.deployment_target = '7.0'
  
  s.source_files = 'Atomic/*.swift'

  s.requires_arc = true
end
