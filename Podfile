use_frameworks!

abstract_target 'CocoaPods' do
  pod 'FormTextField', path: "."
  pod 'Hex'

  target 'Native' do
  end

  target 'Custom' do
  end

  target 'Tests' do
  end
end

post_install do |installer|
  puts "Configure Pod targets for Xcode 8 compatibility"
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '3.0'
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
  end
end
