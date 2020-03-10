
Pod::Spec.new do |s|
  s.name         = "RNNetinterfaces"
  s.version      = "1.0.0"
  s.summary      = "RNNetinterfaces"
  s.description  = <<-DESC
                  RNNetinterfaces
                   DESC
  s.homepage     = "https://github.com/author/RNNetinterfaces.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "liagnhwajou@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/author/RNNetinterfaces.git", :tag => "master" }
  s.source_files  = "ios/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  