# Uncomment the next line to define a global platform for your project
platform :ios, '11.2'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'clift_iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for clift_iOS
  
  pod 'RealmSwift'
  pod 'Moya/RxSwift', '~> 11.0'
  pod 'ObjectMapper+Realm'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'TextFieldEffects'
  pod 'UITextField+Shake', '~> 1.2'
  pod 'Kingfisher' , '~> 5.0'
  pod 'GSMessages'
  pod 'GoogleMaps'
  pod 'DropDown'
  pod 'SideMenu'
  pod 'SwiftSoup'
  pod 'ImageSlideshow', '~> 1.8'
  pod 'GoogleSignIn'
  pod 'Stripe', '~> 20.0'
  pod 'IQKeyboardManagerSwift'

  # Pods for carouselImages
  pod 'moa', '~> 12.0'
  pod 'Auk', '~> 11.0'


  target 'clift_iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'clift_iOSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
