Pod::Spec.new do |s|
  s.name             = "FormTextField"
  s.summary          = "A short description of FormTextField."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/3lvis/FormTextField"
  s.license          = 'MIT'
  s.author           = { "Elvis Nuñez" => "elvisnunez@me.com" }
  s.source           = { :git => "https://github.com/3lvis/FormTextField.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/3lvis'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Source'
end
