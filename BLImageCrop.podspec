
Pod::Spec.new do |s|

s.name         = "BLImageCrop"
s.version      = "1.0"
s.summary      = "图片剪裁"
s.description  = "轻量级的 图片剪裁"
s.homepage     = "https://github.com/IceTears1/BLImageCrop"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "binglei" => "642203775@qq.com" }
s.platform     = :ios
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/IceTears1/BLImageCrop.git", :tag => s.version }
s.source_files  = "BLImageCrop/**/*.{h,m}"
s.requires_arc = true

end
