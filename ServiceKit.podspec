#
#  Be sure to run `pod spec lint ServiceKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "ServiceKit"
  s.version      = "1.0.1"
  s.summary      = "A Generic Rest Kit in swift"
  s.description  = "This framework was made to help developers to build their apps without having to worry about creating the service layer using urls and etc"
  s.homepage     = "https://github.com/KeyCar/ServiceKit"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "Leonardo" => "leonardo_rock@icloud.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "10.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/KeyCar/ServiceKit.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "ServiceKit", "ServiceKit/**/*.{h,m,swift}"
  s.exclude_files = "Classes/Exclude"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
