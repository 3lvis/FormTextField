use_frameworks!

# TODO: Remove this after all pods are converted to swift 3
def swift3_overrides
    pod 'Formatter', :git => 'https://github.com/nextforce/Formatter.git', :branch => 'swift-3'
    pod 'InputValidator', :git => 'https://github.com/nextforce/InputValidator.git', :branch => 'swift-3'
    pod 'Validation', :git => 'https://github.com/nextforce/Validation.git', :branch => 'swift-3'
end

abstract_target 'CocoaPods' do
  swift3_overrides
  
  pod 'FormTextField', path: "."
  pod 'Hex', :git => 'https://github.com/3lvis/Hex.git', :branch => 'feature/swift-3'

  target 'Native' do
  end

  target 'Custom' do
  end

  target 'Tests' do
  end
end
