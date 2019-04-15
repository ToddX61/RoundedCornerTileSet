Pod::Spec.new do |s|
s.name        = "RoundedCornerTileSet"
s.version     = "1.0.2"
s.summary     = "Create and display rounded corner tile sets with Sprint and SpriteKit"
s.homepage    = "https://github.com/ToddX61/RoundedCornerTileSet"
s.license     = { :type => "MIT" }
s.authors     = { "Todd Denlinger" => "todd at denlinger dot biz" }
s.requires_arc = true
s.swift_version = "5.0"
s.osx.deployment_target = "10.12"
s.ios.deployment_target = "10.0"
s.source   = { :git => "https://github.com/ToddX61/RoundedCornerTileSet.git", :tag => s.version }
s.source_files = "Sources/*.swift"
end
