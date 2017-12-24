Pod::Spec.new do |s|
  s.name         = "LKCodingObject"
  s.version      = "1.4.0"
  s.summary      = "NSCoding conformed library"
  s.description  = <<-DESC
Properties can be archived/unarchived with conforming to NSCoding.
                   DESC
  s.homepage     = "https://github.com/lakesoft/LKCodingObject"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Hiroshi Hashiguchi" => "xcatsan@mac.com" }
  s.source       = { :git => "https://github.com/lakesoft/LKCodingObject.git", :tag => s.version.to_s }

  s.platform     = :ios, '11.0'
  s.requires_arc = true

  s.source_files = 'Classes/*'

end
