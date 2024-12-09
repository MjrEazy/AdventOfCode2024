import Foundation

typealias Grid = [[Character]]

struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

let word = "MAS"

func checkXShape(grid: Grid, row: Int, col: Int) -> Bool {
    if row - 1 >= 0 && col - 1 >= 0 && row + 1 < grid.count && col + 1 < grid[0].count {
        let topLeft = grid[row - 1][col - 1]
        let bottomRight = grid[row + 1][col + 1]
        let topRight = grid[row - 1][col + 1]
        let bottomLeft = grid[row + 1][col - 1]
        let diagonal1Valid = (topLeft == "M" && bottomRight == "S") || (topLeft == "S" && bottomRight == "M")
        let diagonal2Valid = (topRight == "M" && bottomLeft == "S") || (topRight == "S" && bottomLeft == "M")
        return diagonal1Valid && diagonal2Valid
    }
    return false
}

func findOccurrences(in grid: Grid) -> Set<Coordinate> {
    var validPositions = Set<Coordinate>()
    
    for rowIndex in 0..<grid.count {
        for colIndex in 0..<grid[rowIndex].count {
            if grid[rowIndex][colIndex] == "A" {
                if checkXShape(grid: grid, row: rowIndex, col: colIndex) {
                    validPositions.insert(Coordinate(row: rowIndex, col: colIndex))
                }
            }
        }
    }
    return validPositions
}

func readGrid(fromFile filePath: String) -> Grid? {
    do {
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        let rows = fileContents.split(separator: "\n").map { Array($0) }
        return rows as Grid
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day4_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day4_input.txt"
if let grid = readGrid(fromFile: filePath) {
    let occurrences = findOccurrences(in: grid)
    let count = occurrences.count
    print("valid X-MAS shapes: \(count)")  // Should print the count of valid XMAS patterns
} else {
    print("Failed to read grid from file.")
}
