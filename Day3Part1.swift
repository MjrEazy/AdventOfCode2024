import Foundation

func calculateSum(from fileContent: String) -> Int {
    var totalSum = 0
    let lines = fileContent.split(whereSeparator: \.isNewline)

    for line in lines {
        let pattern = #"mul\((\d{1,3}),(\d{1,3})\)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: line.utf8.count)
        let matches = regex?.matches(in: String(line), options: [], range: range)
        
        if let matches = matches {
            let matchStrings = matches.map { match in String(line[Range(match.range, in: line)!]) }
            print(matchStrings)
            for match in matches {
                if let xRange = Range(match.range(at: 1), in: line), let yRange = Range(match.range(at: 2), in: line) {
                    if let x = Int(String(line[xRange])), let y = Int(String(line[yRange])) {
                        totalSum += x * y
                    }
                }
            }
        }
    }
    return totalSum
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day3_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day3_input.txt"
do {
    let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
    let total = calculateSum(from: fileContent)
    print(total)
} catch {
    print("Failed to read the file: \(error)")
}
