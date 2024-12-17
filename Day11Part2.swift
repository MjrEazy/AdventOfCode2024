import Foundation

func readStones(from file: String) -> [Int: Int] {
    do {
        let content = try String(contentsOfFile: file, encoding: .utf8)
        let stones = content.split(separator: "\n")
            .flatMap { $0.split(separator: " ") }
            .compactMap { Int($0) }
        var stoneCounts: [Int: Int] = [:]
        for stone in stones {
            stoneCounts[stone, default: 0] += 1
        }
        return stoneCounts
    } catch {
        print("Error reading file: \(error)")
        return [:]
    }
}

func processStones(stones: [Int: Int]) -> [Int: Int] {
    var newStones: [Int: Int] = [:]
    
    for (n, numStone) in stones {
        let stringN = String(n)
        let mid = stringN.count / 2
        let rem = stringN.count % 2
        if n == 0 {
            newStones[1, default: 0] += numStone
        } else if rem != 0 {
            newStones[2024 * n, default: 0] += numStone
        } else {
            let divisor = Int(pow(10.0, Double(mid)))
            let (firstPart, secondPart) = (n / divisor, n % divisor)
            newStones[firstPart, default: 0] += numStone
            newStones[secondPart, default: 0] += numStone
        }
    }
    return newStones
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day11_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day11_input.txt"
var stones = readStones(from: filePath)
var sum = 0
for blink in 1...75 {
    stones = processStones(stones: stones)
    sum = stones.values.reduce(0, +)
}
print(sum)
