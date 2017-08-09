# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AliasWords' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'MGSwipeTableCell'
  pod "AHKNavigationController"
  pod 'UICountingLabel'
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/AdMob'
  pod ‘Kingfisher’
  pod 'RxCocoa',    '3.0.0-rc.1' 
  pod 'RxSwift',    '3.0.0-rc.1'
  # Pods for AliasWords

  target 'AliasWordsTests' do
    inherit! :search_paths
    pod 'Firebase'
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
