Pod::Spec.new do |s|
  s.name             = "TextField"
  s.summary          = "A TextField that supports formatters and input validators such as maximum length and regex"
  s.version          = "0.4.0"
  s.homepage         = "https://github.com/3lvis/TextField"
  s.license          = 'MIT'
  s.author           = { "Elvis Nuñez" => "elvisnunez@me.com" }
  s.requires_arc = true
  s.source_files = 'Source/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'Formatter', '~> 0.3.2'
  s.dependency 'InputValidator', '~> 0.6.2'
  s.dependency 'Hex', '~> 2.0'
end
