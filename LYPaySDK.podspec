#
#  Be sure to run `pod spec lint LYPaySDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "LYPaySDK"
  s.version      = "1.0.0"
  s.summary      = "聚合SDK demo  "

  s.description  = <<-DESC
            内部集成了微信支付、支付宝支付、百度支付、苹果支付、银联支付、京东支付，微信支付宝加密算法放在本地的
                   DESC

  s.homepage     = "https://github.com/hqq-iOS/LeYingPay"
  s.license      = "MIT"
  s.author             = { "heqinqin" => "546551235@qq.com" }
   s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/hqq-iOS/LeYingPay.git", :tag => "1.0.0" }
  s.requires_arc = true

s.subspec 'Core' do |core|
    core.source_files = 'LYPaySDK/Core/**/*.{h,m}'
    core.requires_arc = true
    core.ios.library = 'c++', 'stdc++', 'z'
    core.frameworks = 'CFNetwork', 'SystemConfiguration', 'Security'
    core.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end

s.subspec 'AliPay' do |alipay|
    alipay.frameworks = 'CoreMotion' , 'CoreTelephony'
    alipay.vendored_frameworks = 'LYPaySDK/Channel/AliPay/AlipaySDK.framework'
    alipay.dependency 'LYPaySDK/Core'
  end


  s.subspec 'WXPay' do |wx|
    wx.frameworks = 'CoreTelephony'
    wx.vendored_libraries = 'LYPaySDK/Channel/WXPay/libWeChatSDK.a'
    wx.ios.library = 'sqlite3'    
    wx.dependency 'LYPaySDK/Core'
  end

  s.subspec 'UnionPay' do |unionpay|
    unionpay.frameworks = 'QuartzCore'
    unionpay.vendored_libraries = 'LYPaySDK/Channel/UnionPay/paymentcontrol/libs/libPaymentControl.a'
    unionpay.dependency 'LYPaySDK/Core'
  end

 s.subspec 'ApplePay' do |apple|
      apple.frameworks = 'QuartzCore','PassKit'
    apple.vendored_libraries = 'LYPaySDK/Channel/ApplePay/libs/libUPAPayPlugin.a'
    apple.dependency 'LYPaySDK/Core'
  end

  s.subspec 'JDPay' do |jd|
      jd.frameworks = 'QuartzCore','PassKit'
    jd.vendored_libraries = 'LYPaySDK/Channel/JDPay/libJDPay.a'
    jd.dependency 'LYPaySDK/Core'
  end


  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "AFNetworking", "~> 3.1.0"
  s.dependency "SDWebImage", "~> 4.1.0"
  s.dependency "Reachability", "~> 3.2"

end
