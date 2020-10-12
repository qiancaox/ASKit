Pod::Spec.new do |s|
  s.name             = "ASCore"
  s.version          = "1.0.0"
  s.summary          = "Utilities and Extensions commonly used in daily development"
  s.homepage         = "https://github.com/qiancaox/ASKit"
  s.license          = 'MIT'
  s.author           = { "Amt Super" => "qiancaoxiang@163.com" }
  s.source           = { :git => "https://github.com/qiancaox/ASKit.git", :tag => s.version.to_s }
  s.platform         = "ios", "8.0"
  s.swift_version    = '5.0'
  
  s.subspec "Utilities" do |ss|
    ss.source_files  = "ASCore/Utilities/*.swift"
  end
  s.subspec "Extensions" do |ss|
    ss.source_files  = "ASCore/Extensions/*.swift"
    ss.dependency 'ASCore/Utilities'
  end
  s.subspec "Keychain" do |ss|
    ss.source_files  = "ASCore/Keychain/*.swift"
    ss.dependency 'SAMKeychain', '~>1.5.3'
  end
  s.subspec "Networking" do |ss|
    ss.source_files  = "ASCore/Networking/*.swift"
    ss.dependency 'Moya/RxSwift', '~>13.0.1'
    ss.dependency 'HandyJSON', '~>5.0.2'
  end
  s.subspec "ReactiveX_Swift" do |ss|
    ss.source_files  = "ASCore/ReactiveX_Swift/*.swift"
    ss.dependency 'RxCocoa', '~>4.5.0'
  end
end

