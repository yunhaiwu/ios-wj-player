Pod::Spec.new do |s|

s.name         = "WJPlayerKit"
s.version      = "1.0"
s.summary      = "播放器开发包."

s.description  = <<-DESC
    播放器开发包，支持音频、视频，UI可根据业务定制~
DESC

s.homepage     = "https://github.com/yunhaiwu"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author             = { "吴云海" => "halayun@qq.com" }

s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git", :tag => "#{s.version}" }

s.frameworks = "Foundation", "UIKit", "AVFoundation"
s.exclude_files = "Example"

s.requires_arc = true


s.subspec 'Core' do |core|
    core.source_files = 'Classes/*.{h,m}'
    core.public_header_files = 'Classes/*.h'
end

end
