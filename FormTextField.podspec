Pod::Spec.new do |s|
  s.name             = "FormTextField"
  s.summary          = "A UITextField that supports formatters and input validators such as maximum length and regex"
  s.version          = "0.12.0"
  s.homepage         = "https://github.com/3lvis/FormTextField"
  s.license          = 'MIT'
  s.author           = { "Elvis Nuñez" => "elvisnunez@me.com" }
  s.source           = { :git => "https://github.com/3lvis/FormTextField.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/3lvis'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'Formatter', '~> 0.3.3'
  s.dependency 'InputValidator', '~> 0.9.1'
end
