import Foundation

func preprocessInput(_ input: String) -> String {
    var result = ""
    var isInsideDisabledBlock = false
    var index = input.startIndex
    
    while index < input.endIndex {
        let remainingSubstring = input[index...]
        if isInsideDisabledBlock {
            if remainingSubstring.hasPrefix("do()") {
                isInsideDisabledBlock = false
                result.append("do()")
                index = input.index(index, offsetBy: 4)
            } else {
                index = input.index(after: index)
            }
        } else {
            if remainingSubstring.hasPrefix("don't()") {
                isInsideDisabledBlock = true
                index = input.index(index, offsetBy: 7)
            } else {
                result.append(input[index])
                index = input.index(after: index)
            }
        }
    }
    return result
}

func calculateSum(from fileContent: String) -> Int {
    var totalSum = 0
    let cleanedContent = preprocessInput(fileContent)
    let pattern = #"mul\((\d{1,3}),(\d{1,3})\)"#
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: cleanedContent.utf16.count)
    let matches = regex?.matches(in: cleanedContent, options: [], range: range)
    
    for match in matches ?? [] {
        if let xRange = Range(match.range(at: 1), in: cleanedContent),
        let yRange = Range(match.range(at: 2), in: cleanedContent) {
        if let x = Int(String(cleanedContent[xRange])), let y = Int(String(cleanedContent[yRange])) {
                totalSum += x * y
            }
        }
    }
    return totalSum
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day3_sample2.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day3_input.txt"
do {
    let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
    let total = calculateSum(from: fileContent)
    print(total)
} catch {
    print("Failed to read the file: \(error)")
}
