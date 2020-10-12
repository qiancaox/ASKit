Pod::Spec.new do |s|
  s.name             = "ASKit"
  s.version          = "1.0.0"
  s.summary          = "Commonly components"
  s.homepage         = "https://github.com/qiancaox/ASKit"
  s.license          = 'MIT'
  s.author           = { "Amt Super" => "qiancaoxiang@163.com" }
  s.source           = { :git => "https://github.com/qiancaox/ASKit.git", :tag => s.version.to_s }
  s.platform         = "ios", "8.0"
  s.swift_version    = '5.0'
  s.source_files     = "ASKit/*.swift"
  s.resource         = 'ASKit/Resource.bundle'
  
  s.dependency 'ASCore', '~>1.0.0'
  s.dependency 'SnapKit', '~>4.2.0'
  s.subspec "Toast_HUD" do |ss|
    ss.source_files  = "ASKit/Toast_HUD/*.swift"
  end
  s.subspec "TextField" do |ss|
    ss.source_files  = "ASKit/TextField/*.swift"
  end
end

