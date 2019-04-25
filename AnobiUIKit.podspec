
Pod::Spec.new do |s|

  s.name             = 'AnobiUIKit'
  s.version          = '0.9.0'
  s.summary          = 'AnobiUIKit - iOS Developer helpers collection.'

  s.description      = <<-DESC
AnobiUIKit - iOS Developer helpers collection.

## Main features
AKAlert
AKImagePicker

AKThemeManager
AKViewDispatcher

## Main helpers
AKFormattedField
AKAnimation
UIImage+Resize
UIViewController+AnobiKit
AKTableViewController
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
