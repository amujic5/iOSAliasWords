# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'AliasWords' do
  use_frameworks!

  # Pods for AliasWords
  pod 'MGSwipeTableCell'
  pod "AHKNavigationController"
  pod 'UICountingLabel'
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/AdMob'
  pod ‘Kingfisher’
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end