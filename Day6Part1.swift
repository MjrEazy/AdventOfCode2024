import Foundation

struct Coordinate: Hashable {
    let x: Int
    let y: Int
}

let directions = [(-1, 0), (0, 1), (1, 0), (0, -1)] // North, East, South, West

func readMap(fromFile filePath: String) -> (lab: [[Character]], startPosition: Coordinate)? {
    do {
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { Array($0) }
        
        for (rowIndex, row) in lines.enumerated() {
            if let colIndex = row.firstIndex(of: "^") {
                return (lines, Coordinate(x: rowIndex, y: colIndex))
            }
        }
        
        return nil
        
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

func moveGuard(lab: [[Character]], startPosition: Coordinate) -> Int {
    var visitedPositions: Set<Coordinate> = []
    var position = startPosition
    var directionIndex = 0  // 0 = North, 1 = East, 2 = South, 3 = West
    var currentPosition = startPosition
    var labCopy = lab
    
    visitedPositions.insert(currentPosition)
    
    while true {
        let (dx, dy) = directions[directionIndex]
        let newPosition = Coordinate(x: currentPosition.x + dx, y: currentPosition.y + dy)
        
        if newPosition.x < 0 || newPosition.x >= lab.count || newPosition.y < 0 || newPosition.y >= lab[0].count {
            break
        }
        
        if labCopy[newPosition.x][newPosition.y] == "#" {
            directionIndex = (directionIndex + 1) % 4
        } else {
            currentPosition = newPosition
            visitedPositions.insert(currentPosition)
        }
    }
    
    return visitedPositions.count
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day6_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day6_input.txt"
if let (lab, startPosition) = readMap(fromFile: filePath) {
    let result = moveGuard(lab: lab, startPosition: startPosition)
    print(result)
} else {
    print("Failed to read data from file.")
}
