import Foundation

//let filePath = "/Users/David/Projects/AoC24/inputs/Day1_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day1_input.txt"

guard let fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
    print("Failed to read the file.")
    exit (EXIT_FAILURE)
}

// DANGER! DANGER! Will Robinson!  No error handling!
// Assumes lines always only have 2 elements per line and separated by newline with 3 spaces between them
let lines = fileContents.split(separator: "\n")
//print(lines)
let lists = lines.map { line -> (Int, Int) in
    let elements = line.split(separator: "   ")
    let first = Int(elements[0])!
    let second = Int(elements[1])!
    return (first, second)
}

let list1 = lists.map { $0.0 }.sorted()
let list2 = lists.map { $0.1 }.sorted()

//print("Array 1: \(list1)")
//print("Array 2: \(list2)")

var frequency = [Int: Int]()
for num in list2 {
    frequency[num, default: 0] += 1
}
var score = 0
for num in list1 {
    let similarity = frequency[num, default: 0]
    score += num * similarity
}

print(score)
