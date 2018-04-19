# AnobiUIKit

[![CI Status](http://img.shields.io/travis/Anobisoft/AnobiUIKit.svg?style=flat)](https://travis-ci.org/Anobisoft/AnobiUIKit)
[![Version](https://img.shields.io/cocoapods/v/AnobiUIKit.svg?style=flat)](http://cocoapods.org/pods/AnobiUIKit)
[![Downloads](https://img.shields.io/cocoapods/dt/AnobiUIKit.svg)](http://cocoapods.org/pods/AnobiUIKit)
[![Platform](https://img.shields.io/cocoapods/p/AnobiUIKit.svg?style=flat)](http://cocoapods.org/pods/AnobiUIKit)
[![Language](https://img.shields.io/github/languages/top/Anobisoft/AnobiUIKit.svg)](https://github.com/Anobisoft/AnobiUIKit)
[![License](https://img.shields.io/cocoapods/l/AnobiUIKit.svg?style=flat)](http://cocoapods.org/pods/AnobiUIKit)
[![Twitter](https://img.shields.io/badge/twitter-@Anobisoft-blue.svg?style=flat)](http://twitter.com/Anobisoft)

Collection of various UIKit-dependent classes and categories useful to Objective-C iOS Developer.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation with CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like **AnobiUIKit** in your projects. You can install it with the following command:
```
$ gem install cocoapods
```
#### Podfile
To integrate **AnobiUIKit** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
platform :ios, '8.3'
  use_frameworks!
  target 'TargetName' do
  pod 'AnobiUIKit'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
```
Then, run the following command:
```
$ pod install
```
## Requirements
Minimum iOS Target is ios **8.3**.

## License
AnobiUIKit is released under the MIT license. See LICENSE for details.

## Author

Stanislav Pletnev, anobisoft@gmail.com
