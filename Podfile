# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['KiwiPods'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['MACH_O_TYPE'] = 'staticlib'
            end
        end
        if ['AWSMobileClient'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end

target 'PLAN-IT' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PLAN-IT
#  pod 'KiwiPods', :git => 'https://github.com/KiwiTechLLC/KiwiPods.git', :branch => 'swift5Update'
  pod 'MBProgressHUD'
  pod 'SDWebImage', '~> 5.0'
  pod 'IQKeyboardManagerSwift', '6.2.1'
  pod 'Alamofire', '~> 4.7'
  pod 'SwiftLint'
  pod 'Nantes'
  pod 'Plaid'
  pod 'HCVimeoVideoExtractor'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Charts'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'NVActivityIndicatorView'
  pod 'XCDYouTubeKit', '~> 2.8'
end
