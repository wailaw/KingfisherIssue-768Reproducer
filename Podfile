platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'KF768Reproducer' do
    pod 'Kingfisher', '3.13.1'
    pod 'RxSwift', '3.6.1'
    pod 'RxCocoa', '3.6.1'
    pod 'SnapKit', '3.2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
