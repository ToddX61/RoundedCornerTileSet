
import SpriteKit

class RoundedCornerTileMapNode: SKTileMapNode {
    enum BorderTilesInvalidNeighborType: Int {
        case empty = 0, filled = 1
    }

    enum NodeType: Int {
        case rounded = 0, inset = 1
    }

    // MARK: - Private Variables

    fileprivate var _grid: Array2D<Any>!

    // MARK: - Public Variables

    var grid: Array2D<Any> { return _grid }

    // MARK: - Public Class Functions

    // grid is a 2 dimensional array that specifies which [col,row] should be filled with the tileGroups (nil values are not filled)
    class func create(tileSet: SKTileSet, grid: Array2D<Any>) -> RoundedCornerTileMapNode? {
        guard tileSet.tileGroups.count >= RoundedCornerTileSet.TextureCount else { return nil }

        let tileMapNode = RoundedCornerTileMapNode(tileSet: tileSet, columns: grid.columns, rows: grid.rows, tileSize: tileSet.defaultTileSize)

        create(tileSet: tileSet, tileMapNode: tileMapNode, grid: grid)
        return tileMapNode
    }

    class func create(tileSet: SKTileSet, tileMapNode: RoundedCornerTileMapNode, grid: Array2D<Any>) {
        tileMapNode.enableAutomapping = false
        tileMapNode._grid = grid
        tileMapNode.tileSet = tileSet
        tileMapNode.fill()
    }

    // MARK: - Public Functions

    func fill() {
        let columns = grid.columns
        let rows = grid.rows

        for col in 0 ..< columns {
            for row in 0 ..< rows {
                let nodeType = Force.toBool(_grid[col, row]) ? NodeType.rounded : NodeType.inset
                let tileGroup = getTileGroup(nodeType: nodeType, col: col, row: row)

                setTileGroup(tileGroup, forColumn: col, row: row)
            }
        }
    }

    //    MARK: - Private Functions

    fileprivate func getTileGroup(nodeType: NodeType, col: Int, row: Int) -> SKTileGroup? {
        let surrounding = getSurrounding(col: col, row: row)
        let corners: FourCorners
        let indexOffset: Int

        switch nodeType
        {
        case .rounded:
            corners = roundedCorners(surrounding: surrounding)
            indexOffset = 0
        case .inset:
            corners = insetCorners(surrounding: surrounding)
            indexOffset = RoundedCornerTileSet.TextureCount
        }

        let index = corners.value

        assert(index >= 0 && index <= FourCorners.MaxDecimal)
        return tileSet.tileGroups[index + indexOffset]
    }

    fileprivate func getSurrounding(col: Int, row: Int) -> Directions {
        var directions = Directions()
        let columns = _grid.columns
        let rows = _grid.rows

        if col - 1 >= 0, row - 1 >= 0, Force.toBool(_grid[col - 1, row - 1]) {
            directions.insert(.southWest)
        }

        if row - 1 >= 0, Force.toBool(_grid[col, row - 1]) {
            directions.insert(.south)
        }

        if col + 1 < columns, row - 1 >= 0, Force.toBool(_grid[col + 1, row - 1]) {
            directions.insert(.southEast)
        }

        if col - 1 >= 0, Force.toBool(_grid[col - 1, row]) {
            directions.insert(.west)
        }

        if col + 1 < columns, Force.toBool(_grid[col + 1, row]) {
            directions.insert(.east)
        }

        if col - 1 >= 0, row + 1 < rows, Force.toBool(_grid[col - 1, row + 1]) {
            directions.insert(.northWest)
        }

        if row + 1 < rows, Force.toBool(_grid[col, row + 1]) {
            directions.insert(.north)
        }

        if col + 1 < columns, row + 1 < rows, Force.toBool(_grid[col + 1, row + 1]) {
            directions.insert(.northEast)
        }

        return directions
    }

    fileprivate func roundedCorners(surrounding: Directions) -> FourCorners {
        var corners = FourCorners()

        if surrounding.isDisjoint(with: Directions(arrayLiteral: .north, .west, .northWest)) {
            corners[.northWest] = true
        }

        if surrounding.isDisjoint(with: Directions(arrayLiteral: .north, .east, .northEast)) {
            corners[.northEast] = true
        }

        if surrounding.isDisjoint(with: Directions(arrayLiteral: .south, .west, .southWest)) {
            corners[.southWest] = true
        }

        if surrounding.isDisjoint(with: Directions(arrayLiteral: .south, .east, .southEast)) {
            corners[.southEast] = true
        }

        return corners
    }

    fileprivate func insetCorners(surrounding: Directions) -> FourCorners {
        var corners = FourCorners()

        if surrounding.isSuperset(of: Directions(arrayLiteral: .west, .north)) {
            corners[.northWest] = true
        }

        if surrounding.isSuperset(of: Directions(arrayLiteral: .north, .east)) {
            corners[.northEast] = true
        }

        if surrounding.isSuperset(of: Directions(arrayLiteral: .west, .south)) {
            corners[.southWest] = true
        }

        if surrounding.isSuperset(of: Directions(arrayLiteral: .south, .east)) {
            corners[.southEast] = true
        }

        return corners
    }
}
