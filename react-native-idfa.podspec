require 'json'
package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-idfa"
  s.version      = package['version']
  s.summary      = package['description']
  s.author       = package['author']

  s.homepage     = "https://github.com/tuluigi/react-native-idfa"

  s.license      = "MIT"
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/tuluigi/react-native-idfa", :tag => "#{s.version}" }
  s.source_files = "ios/IDFA/*.{h,m}"

  s.frameworks   = "AdSupport"

  s.dependency "React"
end
