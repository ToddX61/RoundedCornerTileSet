
import SpriteKit

enum GridTileSetError: Error {
    case runtimeError(String)
}

extension String {
    public func pad(with padding: Character, toLength length: Int) -> String {
        let paddingWidth = length - count
        guard 0 < paddingWidth else { return self }

        return String(repeating: padding, count: paddingWidth) + self
    }
}

class Force {
    class func toBool(_ value: Any?, defaultValue: Bool = false) -> Bool {
        if let obj = value as? Bool {
            return obj
        }
        else if let obj = value as? Int {
            return (obj != 0 && obj != -1)
        }
        else {
            return defaultValue
        }
    }
}

class RoundedCornerTileSet {
// As of macos 10.14 and IOS 11, I couln't make SpriteKit's tile groups correctly handle complex custom groups. See:
// https://stackoverflow.com/questions/52198373/custom-group-in-tilemap-set-does-not-select-the-proper-tile
// https://gamedevelopment.tutsplus.com/tutorials/how-to-use-tile-bitmasking-to-auto-tile-your-level-layouts--cms-25673

    // MARK: - Constants

    // number of images in a grid tile set / 2
    // that is: (rounded corner tile count + inset corner tile count) / 2
    static let TextureCount = 16
    static let DefaultTileSetName = "RoundedCornerTileSet"

    // MARK: - Public Class Functions

    class func create(textures: TextureCache,
                      tileSetName: String = RoundedCornerTileSet.DefaultTileSetName,
                      roundedImagePrefix: String = "rounded_",
                      insetImagePrefix: String = "inset_") throws -> SKTileSet {
//
        var groups: [SKTileGroup] = [SKTileGroup]()

        do {
            try create(textures: textures, imagePrefix: roundedImagePrefix, groups: &groups)
            try create(textures: textures, imagePrefix: insetImagePrefix, groups: &groups)
        }
        catch {
            throw error
        }

        guard !groups.isEmpty else { throw GridTileSetError.runtimeError("No textures loaded") }

        if groups.isEmpty || groups[0].rules.isEmpty || groups[0].rules[0].tileDefinitions.isEmpty {
            throw GridTileSetError.runtimeError("No textures loaded")
        }

        let tileSet = SKTileSet(tileGroups: groups, tileSetType: .grid)

        tileSet.defaultTileSize = groups[0].rules[0].tileDefinitions[0].size
        tileSet.name = DefaultTileSetName
        tileSet.type = .grid

        return tileSet
    }

    // MARK: - Private Class Functions

    fileprivate class func create(textures: TextureCache, imagePrefix: String, groups: inout [SKTileGroup]) throws {
        for idx in 0 ..< RoundedCornerTileSet.TextureCount {
            let str = String(idx, radix: 2).pad(with: "0", toLength: 4)
            let textureName = "\(imagePrefix)\(str)"

//            useful for ensuring your atlas has the correct number of textures
//            print("TileGroup Index: \(idx) named: \(textureName)")

            guard let texture = textures[textureName]
            else {
                throw GridTileSetError.runtimeError("Error loading texture: \(textureName)")
            }

            let definition = SKTileDefinition(texture: texture)
            definition.placementWeight = 1
            let group = SKTileGroup(tileDefinition: definition)
            groups.append(group)
        }
    }
}
