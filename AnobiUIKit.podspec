
Pod::Spec.new do |s|

  s.name             = 'AnobiUIKit'
  s.version          = '0.9.0'
  s.summary          = 'AnobiUIKit - collection of various UIKit-dependent classes and categories useful to Objective-C iOS Developer.'

  s.description      = <<-DESC
AnobiUIKit - collection of various UIKit-dependent classes and categories useful to Objective-C iOS Developer.

## Main features
AKAlert
AKAnimation
AKFormattedField
AKImagePicker
AKTableViewController
AKViewDispatcher

AKThemeManager
UIImage+Resize
UINavigationBar+AnobiKit
UIView+Autolayout
UIViewController+AnobiKit
DESC

  s.homepage     = "https://github.com/Anobisoft/AnobiUIKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Stanislav Pletnev" => "anobisoft@gmail.com" }
  s.social_media_url   = "https://twitter.com/Anobisoft"

  s.platform     = :ios, "9.3"

  s.source        = { :git => "https://github.com/Anobisoft/AnobiUIKit.git", :tag => s.version.to_s }
  s.source_files  = "AnobiUIKit/**/*.{h,m}"
  s.framework     = "UIKit"
  
  s.dependency "AnobiKit", '~> 0.14.0'
  
  s.requires_arc = true

end
