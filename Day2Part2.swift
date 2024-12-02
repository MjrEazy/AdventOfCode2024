import Foundation

func isValidDiff(prev: Int, current: Int) -> Bool {
    let diff = current - prev
    return abs(diff) >= 1 && abs(diff) <= 3
}

// Function to check if the report is strictly increasing or decreasing
func checkReport(levels: [Int]) -> Bool {
    guard levels.count > 1 else { return false }

    var isIncreasing: Bool? = nil

    for i in 1..<levels.count {
        let diff = levels[i] - levels[i - 1]
        if !isValidDiff(prev: levels[i - 1], current: levels[i]) {
            return false
        }
        if isIncreasing == nil {
            isIncreasing = diff > 0
        } else if (isIncreasing! && diff < 0) || (!isIncreasing! && diff > 0) {
            return false
        }
    }

    return true
}

func isSafeReport(levels: [Int]) -> Bool {
    guard levels.count > 1 else { return false }
    if checkReport(levels: levels) {
        return true
    }
    for i in 0..<levels.count {
        var modifiedLevels = levels
        modifiedLevels.remove(at: i)
        if checkReport(levels: modifiedLevels) {
            return true
        }
    }
    return false
}

func processReports(filePath: String) -> Int {
    var safeCount = 0
    if let fileContents = try? String(contentsOfFile: filePath) {
        fileContents.enumerateLines { line, _ in
            let levels = line.split(separator: " ").compactMap { Int($0) }
            // print(levels)
            if isSafeReport(levels: levels) {
                // print("safe")
                safeCount += 1
            } else {
                //print("unsafe")
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
