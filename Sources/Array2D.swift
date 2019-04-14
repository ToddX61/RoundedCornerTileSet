/*
 From https://github.com/raywenderlich/swift-algorithm-club/tree/master/Array2D
 
 Slightly modified:
 conform to CustomStringConvertible
 add some convienence methods: walk(_:) and walkSurrounding(_:)
 */

import Foundation

public struct Array2D<T>{
    public let columns: Int
    public let rows: Int
    fileprivate var array: Array<T?>
  
    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    public subscript(column: Int, row: Int) -> T? {
        get { return array[row * columns + column] }
        set { array[row * columns + column] = newValue }
    }
}

// MARK: - CustomStringConvertible
extension Array2D: CustomStringConvertible {
    public var description: String { return "columns: /(columns) rows: /(rows)" }
}

// MARK: - Convienence methods
public extension Array2D {
    func walk(_ callback: @escaping (_ object: T?, _ stop: inout Bool) -> Void) {
        var stop = false
        for col in 0 ..< columns {
            for row in 0 ..< rows {
                callback(self[col, row], &stop)
                
                if stop { return }
            }
        }
    }
    
    func walkSurrounding(_ column: Int, row: Int, callback: (_ object: T?) -> Void) {
        let maxCol = min(column + 1, columns)
        let maxRow = min(row + 1, rows)
        
        for cidx in max(0, column - 1) ..< maxCol {
            for ridx in max(0, row - 1) ..< maxRow {
                callback(self[cidx, ridx])
            }
        }
    }
}

