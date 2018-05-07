
Pod::Spec.new do |s|

  s.name             = 'AnobiUIKit'
  s.version          = '0.3.9'
  s.summary          = 'AnobiUIKit - collection of various UIKit-dependent classes and categories useful to Objective-C iOS Developer.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
Description should be longer than summary.
more longer
much more longer
longer...
                       DESC

  s.homepage     = "https://github.com/Anobisoft/AnobiUIKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Stanislav Pletnev" => "anobisoft@gmail.com" }
  s.social_media_url   = "https://twitter.com/Anobisoft"

# s.platform     = :ios
  s.platform     = :ios, "8.3"
#  When using multiple platforms
# s.ios.deployment_target = "9.3"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Anobisoft/AnobiUIKit.git", :tag => "v#{s.version}" }
  s.source_files  = "AnobiUIKit/Classes/**/*.{h,m}"
  s.resources = "AnobiUIKit/Resources/*.plist"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '$(FRAMEWORK_SEARCH_PATHS)' }

end
