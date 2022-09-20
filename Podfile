platform :ios, '9.0'

target 'FinalProject' do
  use_frameworks!

  # Architect
  pod 'MVVM-Swift', '1.1.0' # MVVM Architect for iOS Application.

  # Data
  pod 'ObjectMapper', '3.3.0', :inhibit_warnings => true # Simple JSON Object mapping written in Swift.
  pod 'RealmSwift', '3.17.3'

  # Network
  pod 'Alamofire', '4.8.2' # Elegant HTTP Networking in Swift.

  # Utils
  pod 'SwifterSwift', '~> 5.0'
  pod 'IQKeyboardManagerSwift', '~> 6.0.4', :inhibit_warnings => true
  pod 'SwiftUtils', '4.2', :inhibit_warnings => true

  # UI
  pod 'SVProgressHUD', '2.2.5'

  pod 'GoogleMaps'
  pod 'GooglePlaces'

  # Tool to enforce Swift style and conventions
  pod 'SwiftLint', '0.27.0'

  target 'FinalProjectTests' do
    inherit! :search_paths
  end

end

# Check pods for support swift version
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['Alamofire', 'ObjectMapper'].include? "#{target}"
            # Setting #{target}'s SWIFT_VERSION to 4.2\n
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
            else
            # Setting #{target}'s SWIFT_VERSION to default is 5.0
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
    end
end
