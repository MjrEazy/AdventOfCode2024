import Foundation

struct Coordinate: Hashable {
    var x: Int
    var y: Int
}

func readMap(from filePath: String) -> [[Character]]? {
    do {
        let fileContent = try String(contentsOfFile: filePath)
        let rows = fileContent.split(separator: "\n").map { Array($0) }
        return rows
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

func getAntennas(from map: [[Character]]) -> [Character: [Coordinate]] {
    var antennas: [Character: [Coordinate]] = [:]

    for (rowIndex, row) in map.enumerated() {
        for (colIndex, cell) in row.enumerated() {
            if cell != "." {
                let coord = Coordinate(x: colIndex, y: rowIndex)
                if antennas[cell] == nil {
                    antennas[cell] = []
                }
                antennas[cell]?.append(coord)
            }
        }
    }

    return antennas
}

func isAntinode(row: Int, col: Int, map: [[Character]]) -> Bool {
    let height = map.count
    let width = map[0].count

    return row >= 0 && row < height && col >= 0 && col < width
}

func countAntinodes(in map: [[Character]]) -> Int {
    let height = map.count
    let width = map[0].count

    let antennas = getAntennas(from: map)
    var antinodes: Set<Coordinate> = Set()

    for locations in antennas.values {
        for i in 0..<locations.count {
            var r1: Int = 0, r2: Int = 0
            var c1: Int = 0, c2: Int = 0
            for j in i+1..<locations.count {
                (r1, c1) = (locations[i].y, locations[i].x)
                (r2, c2) = (locations[j].y, locations[j].x)

                let rowDiff = r2 - r1
                let colDiff = c2 - c1

                while (0 <= r1 && r1 < height) && (0 <= c1 && c1 < width) {
                    antinodes.insert(Coordinate(x: r1, y: c1))
                    r1 -= rowDiff
                    c1 -= colDiff
                }

                while (0 <= r2 && r2 < height) && (0 <= c2 && c2 < width) {
                    antinodes.insert(Coordinate(x: r2, y: c2))
                    r2 += rowDiff
                    c2 += colDiff
                }
            }
        }
    }

    return antinodes.count
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day8_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day8_input.txt"
if let map = readMap(from: filePath) {
    let result = countAntinodes(in: map)
    print("antinodes: \(result)")
    
} else {
    print("Failed to read map.")
}
