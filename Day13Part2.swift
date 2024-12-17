import Foundation

//let filePath = "/Users/David/Projects/AoC24/inputs/Day13_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day13_input.txt"
var lines: [String] = []
do {
    let content = try String(contentsOfFile: filePath, encoding: .utf8)
    lines = content.split(separator: "\n").map { String($0) }
} catch {
    print("Error reading file: \(error)")
}

var tokens = 0
var x1 = 0, y1 = 0, x2 = 0, y2 = 0

for line in lines {
    if line.hasPrefix("Button") {
        let parts = line.split(separator: " ")
        let button = parts[1].split(separator: ":")[0]
        if button == "A" {
            x1 = Int(parts[2].dropFirst(2).dropLast()) ?? 0
            y1 = Int(parts[3].dropFirst(2)) ?? 0
        } else {
            x2 = Int(parts[2].dropFirst(2).dropLast()) ?? 0
            y2 = Int(parts[3].dropFirst(2)) ?? 0
        }
    } else if line.hasPrefix("Prize") {
        let parts = line.split(separator: " ")
        let X = (Int(parts[1].dropFirst(2).dropLast()) ?? 0) + 10000000000000
        let Y = (Int(parts[2].dropFirst(2)) ?? 0) + 10000000000000
        let denominator = x1 * y2 - y1 * x2
        let tokensA = (Double(X * y2 - Y * x2)) / Double(denominator)
        let tokensB = (Double(Y * x1 - X * y1)) / Double(denominator)
        if tokensA == floor(tokensA) && tokensB == floor(tokensB) {
            tokens += Int((3 * tokensA) + tokensB)
        }
    }
}

print(tokens)
