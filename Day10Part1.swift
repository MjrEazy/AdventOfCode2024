import Foundation

// Directions for movement (up, down, left, right)
let directions: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]

func parseMap(from filePath: String) -> [[Int]]? {
    do {
        let input = try String(contentsOfFile: filePath, encoding: .utf8)
        let rows = input.split(separator: "\n").map { String($0) }
        return rows.map { row in row.map { Int(String($0))! } }
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

func countValidTrails(from row: Int, col: Int, map: [[Int]], visited: inout [[Bool]]) -> Int {
    let targetHeight = 9
    var trailCount = 0
    var stack = [(row, col, 0)]
    
    while !stack.isEmpty {
        let (r, c, currentHeight) = stack.removeLast()
        
        visited[r][c] = true
        
        if currentHeight == targetHeight {
            //print(row, col)
            trailCount += 1
            continue
        }
        
        for (dr, dc) in directions {
            let newRow = r + dr
            let newCol = c + dc
            if newRow >= 0 && newRow < map.count && newCol >= 0 && newCol < map[0].count {
                let newHeight = map[newRow][newCol]
                if newHeight == currentHeight + 1 && !visited[newRow][newCol] {
                    stack.append((newRow, newCol, newHeight))
                }
            }
        }
    }
    return trailCount
}

func calculateTrailScores(map: [[Int]]) -> Int {
    var totalScore = 0
    let rows = map.count
    let cols = map[0].count
    var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
    
    for row in 0..<rows {
        for col in 0..<cols {
            if map[row][col] == 0 {
                visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
                totalScore += countValidTrails(from: row, col: col, map: map, visited: &visited)
            }
        }
    }
    
    return totalScore
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day10_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day10_input.txt"
if let map = parseMap(from: filePath) {
    let score = calculateTrailScores(map: map)
    print("Total: \(score)")
} else {
    print("Failed to read the map.")
}

