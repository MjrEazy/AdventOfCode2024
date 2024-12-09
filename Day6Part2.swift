import Foundation

// Directions: N, E, S, W (up, right, down, left)
let directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]  // N, E, S, W

struct Coordinate: Hashable {
    let x: Int
    let y: Int
}

func readMap(fromFile filePath: String) -> (lab: [[Character]], startPosition: Coordinate)? {
    do {
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { Array($0) }
        
        // Find the starting position of the guard
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

func checkForLoop(lab: [[Character]], startPosition: Coordinate, startDirection: Int, obstaclePosition: Coordinate) -> Bool {
    var trace: [String: [Int]] = [:]
    var currentPosition = startPosition
    var directionIndex = startDirection
    
    while true {
        let (dx, dy) = directions[directionIndex]
        let newPosition = Coordinate(x: currentPosition.x + dx, y: currentPosition.y + dy)
        
        if newPosition.x < 0 || newPosition.x >= lab.count || newPosition.y < 0 || newPosition.y >= lab[0].count {
            return false
        }
        
        if lab[newPosition.x][newPosition.y] == "#" || newPosition == obstaclePosition {
            directionIndex = (directionIndex + 1) % 4
            continue
        }
        
        let positionKey = "\(newPosition.x),\(newPosition.y)"
        if let directionsAtPosition = trace[positionKey], directionsAtPosition.contains(directionIndex) {
            return true
        }
        
        trace[positionKey, default: []].append(directionIndex)
        currentPosition = newPosition
    }
}

func countWhereGuardGetsStuck(lab: [[Character]], startPosition: Coordinate) -> Int {
    var result: Set<Coordinate> = []
    var visitedPositions: Set<Coordinate> = []
    var currentPosition = startPosition
    var directionIndex = 0  // 0 = North, 1 = East, 2 = South, 3 = West
    
    while true {
        let (dx, dy) = directions[directionIndex]
        let newPosition = Coordinate(x: currentPosition.x + dx, y: currentPosition.y + dy)
        
        if newPosition.x < 0 || newPosition.x >= lab.count || newPosition.y < 0 || newPosition.y >= lab[0].count {
            break
        }
        
        if lab[newPosition.x][newPosition.y] == "#" {
            directionIndex = (directionIndex + 1) % 4
            continue
        }
        
        visitedPositions.insert(newPosition)
        currentPosition = newPosition
    }
    
//    print(visitedPositions.count)
    directionIndex = 0
    for position in visitedPositions {
        // Only test positions that are empty (".") and not already an obstacle
        if lab[position.x][position.y] == "." {
//            print(position)
            if checkForLoop(lab: lab, startPosition: startPosition, startDirection: directionIndex, obstaclePosition: position) {
                result.insert(position)
            }
        }
    }
    
    return result.count
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day6_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day6_input.txt"
if let (lab, startPosition) = readMap(fromFile: filePath) {
    let result = countWhereGuardGetsStuck(lab: lab, startPosition: startPosition)
    print(result)
} else {
    print("Failed to read data from file.")
}
