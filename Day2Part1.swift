import Foundation

func isSafeReport(levels: [Int]) -> Bool {
    guard levels.count > 1 else { return false }
    var increasing: Bool? = nil
    for i in 1..<levels.count {
        let diff = levels[i] - levels[i - 1]
        if abs(diff) < 1 || abs(diff) > 3 {
            return false
        }
        if increasing == nil {
            increasing = diff > 0
        } else {
            if (increasing! && diff < 0) || (!increasing! && diff > 0) {
                return false
            }
        }
    }
    return true
}

func processReports(filePath: String) -> Int {
    var safeCount = 0
    if let fileContents = try? String(contentsOfFile: filePath) {
        fileContents.enumerateLines { line, _ in
            let levels = line.split(separator: " ").compactMap { Int($0) }
            // print(levels)
            if isSafeReport(levels: levels) {
                safeCount += 1
            }
        }
    } else {
        print("Failed to open the file.")
    }
    return safeCount
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day2_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day2_input.txt"
let safeReports = processReports(filePath: filePath)
print(safeReports)
