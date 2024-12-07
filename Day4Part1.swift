import Foundation

// Define the grid as a 2D array of characters
typealias Grid = [[Character]]

// Directions for searching "XMAS" in the grid
let directions: [(Int, Int)] = [
    (0, 1),    // Horizontal right
    (0, -1),   // Horizontal left
    (1, 0),    // Vertical down
    (-1, 0),   // Vertical up
    (1, 1),    // Diagonal down-right
    (-1, -1),  // Diagonal up-left
    (1, -1),   // Diagonal down-left
    (-1, 1)    // Diagonal up-right
]

let word = "XMAS"
let wordLength = word.count

func isWordAt(grid: Grid, row: Int, col: Int, direction: (Int, Int)) -> Bool {
    for i in 0..<wordLength {
        let newRow = row + i * direction.0
        let newCol = col + i * direction.1
        if newRow < 0 || newRow >= grid.count || newCol < 0 || newCol >= grid[0].count || grid[newRow][newCol] != word[word.index(word.startIndex, offsetBy: i)] {
            return false
        }
    }
    return true
}

func findOccurrences(of word: String, in grid: Grid) -> [(Int, Int, (Int, Int))] {
    return grid.enumerated().flatMap { (rowIndex, row) in
        row.enumerated().flatMap { (colIndex, _) in
            // Check each direction
            directions.compactMap { direction in
                if isWordAt(grid: grid, row: rowIndex, col: colIndex, direction: direction) {
                    return (rowIndex, colIndex, direction)
                } else {
                    return nil
                }
            }
        }
    }
}
