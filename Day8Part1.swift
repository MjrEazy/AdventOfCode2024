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
                // Cell contains an antenna with some frequency
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
            for j in i+1..<locations.count {
                let (r1, c1) = (locations[i].y, locations[i].x)
                let (r2, c2) = (locations[j].y, locations[j].x)

                let rowDiff = r2 - r1
                let colDiff = c2 - c1

                let (r1New, c1New) = (r1 - rowDiff, c1 - colDiff)
                if isAntinode(row: r1New, col: c1New, map: map) {
                    antinodes.insert(Coordinate(x: c1New, y: r1New))
                }

                let (r2New, c2New) = (r2 + rowDiff, c2 + colDiff)
                if isAntinode(row: r2New, col: c2New, map: map) {
                    antinodes.insert(Coordinate(x: c2New, y: r2New))
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
