
Pod::Spec.new do |s|

  s.name             = 'AnobiUIKit'
  s.version          = '0.4.4'
  s.summary          = 'AnobiUIKit - collection of various UIKit-dependent classes and categories useful to Objective-C iOS Developer.'

  s.description      = <<-DESC
AnobiUIKit - collection of various UIKit-dependent classes and categories useful to Objective-C iOS Developer.
---
AKAlert
AKAnimation
AKFormattedField
AKImagePicker
AKTableViewController
AKViewDispatcher
---
AKThemeManager
---
AKGradientView
AKGrainbomatedView
AKGridView
---
CALayer+XibConfiguration
UIColor+Hex
UIImage+Resize
UINavigationBar+AK
UIView+Autolayout
UIViewController+AK
DESC

  s.homepage     = "https://github.com/Anobisoft/AnobiUIKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Stanislav Pletnev" => "anobisoft@gmail.com" }
  s.social_media_url   = "https://twitter.com/Anobisoft"

  s.platform     = :ios, "8.3"

  s.source        = { :git => "https://github.com/Anobisoft/AnobiUIKit.git", :tag => "v#{s.version}" }
  s.source_files  = "AnobiUIKit/**/*.{h,m}"
  s.framework     = "UIKit"
  
  s.dependency "AnobiKit", '~> 0.5.0'
  
  s.requires_arc = true

end
