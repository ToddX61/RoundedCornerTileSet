Pod::Spec.new do |s|
s.name        = "RoundedCornerTileSet"
s.version     = "1.0.0"
s.summary     = "SwiftyJSON makes it easy to deal with JSON data in Swift"
s.homepage    = "https://github.com/ToddX61/RoundedCornerTileSet"
s.license     = { :type => "MIT" }
s.authors     = { "Todd Denlinger" => "todd at denlinger dot biz" }
s.requires_arc = true
s.swift_version = "4.0"
s.osx.deployment_target = "10.12"
s.ios.deployment_target = "10.0"
s.source   = { :git => "https://github.com/ToddX61/RoundedCornerTileSet.git", :tag => s.version }
s.source_files = "Sources/*.swift"
end
