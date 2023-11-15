Pod::Spec.new do |s|
  s.name        = "EWMIMQTTSDK"
  s.version     = "1.0.0"
  s.summary     = "MicroInverter MQTT Service"
  s.homepage    = "https://github.com/PuuuTao/EWMIMQTTSDK"
  s.license     = { :type => "MIT" }
  s.authors     = { "PuuuTao" => "kevinwang960105@gmail.com" }

  s.swift_version = "5.0"
  s.requires_arc = true
  s.ios.deployment_target = "14.0"
  s.source   = { :git => "https://github.com/PuuuTao/EWMIMQTTSDK.git", :tag => "1.0.0"}
  s.source_files = "Sources/EWMIMQTTSDK/**/*.{h,m,swift}"
end
