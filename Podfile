# Uncomment this line to define a global platform for your project
platform :ios, '12.0'
# Uncomment this line if you're using Swift
use_frameworks!

workspace 'EssentialApp'
project 'EssentialApp/EssentialApp.xcodeproj'
project 'EssentialFeed/EssentialFeed.xcodeproj'

def ui_pods
pod 'SwiftFormat/CLI', '~> 0.49'
end

target 'EssentialApp' do
    project 'EssentialApp/EssentialApp.xcodeproj'
    ui_pods
    end
