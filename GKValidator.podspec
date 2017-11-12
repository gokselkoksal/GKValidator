Pod::Spec.new do |s|
  s.name         	= "GKValidator"
  s.version      	= "2.0.0"
  s.summary      	= "Swift validation library for fields and forms."
  s.description  	= "Swift validation library for fields and forms. Provides different validation options for different field/form states."
  s.homepage     	= "https://github.com/gokselkoksal/GKValidator"
  s.license      	= { :type => "MIT", :file => "LICENSE" }
  s.author         	= { "Göksel Köksal" => "gokselkoksal@gmail.com" }
  s.social_media_url = "http://twitter.com/gokselkk"
  s.platform     	= :ios, "8.0"
  s.source       	= { :git => "https://github.com/gokselkoksal/GKValidator.git", :tag => "v2.0.0" }
  s.source_files  	= "Pod/Classes/Core/**/*.{swift}"
end
