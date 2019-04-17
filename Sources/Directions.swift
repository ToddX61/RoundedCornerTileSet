
import Foundation

// see: https://nshipster.com/optionset/
public protocol Option: RawRepresentable, Hashable, CaseIterable {}

public extension Set where Element: Option {
    var rawValue: Int {
        var rawValue = 0
        for (index, element) in Element.allCases.enumerated() {
            if contains(element) {
                rawValue |= (1 << index)
            }
        }

        return rawValue
    }
}

public enum Direction: String, Option {
    case northWest, north, northEast, west, east, southWest, south, southEast
}

public extension Set where Element == Direction {
    static var all: Set<Direction> {
        return Set(Element.allCases)
    }
}

public typealias Directions = Set<Direction>

public enum Corners: Int, CustomStringConvertible, CaseIterable {
    case northWest = 0, northEast, southWest, southEast
    public var description: String { return "\(rawValue)" }
}

public struct FourCorners: CustomStringConvertible {
    public static let MaxDecimal = 15
    private var _corners: [Int]

    public init() { _corners = Array<Int>(repeating: 0, count: 4) }

    public init?(decimal: Int) {
        guard decimal >= 0, decimal <= FourCorners.MaxDecimal else { return nil }

        let str = String(decimal, radix: 2).pad(with: "0", toLength: 4)
        _corners = [Int]()

        for c in str {
            _corners.append(c == "1" ? 1 : 0)
        }
    }

    public init(directions: Directions) {
        self.init()

        if directions.contains(.northWest) {
            _corners[Corners.northWest.rawValue] = 1
        }

        if directions.contains(.northEast) {
            _corners[Corners.northEast.rawValue] = 1
        }

        if directions.contains(.southWest) {
            _corners[Corners.southWest.rawValue] = 1
        }

        if directions.contains(.southEast) {
            _corners[Corners.southEast.rawValue] = 1
        }
    }

    public subscript(corner: Corners) -> Bool {
        get {
            for (idx, aCorner) in Corners.allCases.enumerated() {
                if corner == aCorner {
                    return _corners[idx] != 0
                }
            }

            return false
        }
        set {
            for (idx, aCorner) in Corners.allCases.enumerated() {
                if corner == aCorner {
                    _corners[idx] = newValue ? 1 : 0
                }
            }
        }
    }

    // returns an integer representation of a binary number >= 0 && <= 15
    public var value: Int { return Int(description, radix: 2)! }

    // returns a string representation of a binary number >= 0 && <= 15
    public var description: String {
        var result = ""

        for integer in _corners {
            result.append(integer == 1 ? "1" : "0")
        }
        return result
    }
}
