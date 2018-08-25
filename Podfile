# Uncomment the next line to define a global platform for your project
platform :ios, "11.0"

target 'FirebaseMessageKit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FirebaseMessageKit
  use_frameworks!
  inhibit_all_warnings!
  pod 'MessageKit'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'MessageKit'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.0'
              end
          end
      end
end

target 'FirebaseMessageKitTests' do
    inherit! :search_paths
    # Pods for testing
end

target 'FirebaseMessageKitUITests' do
    inherit! :search_paths
    # Pods for testing
    end
end
