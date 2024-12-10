import Foundation

// Improved performance. Changed approach, realised that we can use the properties of addition & multiplication - if the last digits of the value are equal to n multiplication can only return the value if it is divisible by n - and work backwards recursively
// now subsecond instead of hours for part 1 and who knows how long for part 2 if I'd stuck with the original brute force approach
// the same approach works for part 1 and part2 just need to handle concatentation for part 2

// Recursive function to check if we can make the total using operands
func evaluateExpression(total: Int, operands: [Int], concat: Bool) -> Bool {
    
    // If total is negative, return false (invalid path)
    if total < 0 {
        return false
    }
    
    // Base case: If no operands are left and total is zero, we succeeded
    if total == 0 && operands.isEmpty {
        return true
    }
    
    // If there are operands left but total is non-zero, continue
    if total != 0 && operands.isEmpty {
        return false
    }
    
    // Pop the last operand
    var operandsCopy = operands
    let op = operandsCopy.removeLast()
    
    // Check if total is divisible by the operand (multiplication)
    let (quotient, remainder) = total.quotientAndRemainder(dividingBy: op)
    if remainder == 0 {
        if evaluateExpression(total: quotient, operands: operandsCopy, concat: concat) {
            return true
        }
    }
    
    // for Part 2 Check for concatenation
    if concat {
        let totalStr = String(total)
        let opStr = String(op)
        
        if totalStr.count > opStr.count && totalStr.hasSuffix(opStr) {
            let prefix = String(totalStr.prefix(totalStr.count - opStr.count))
            if let newTotal = Int(prefix), evaluateExpression(total: newTotal, operands: operandsCopy, concat: concat) {
                return true
            }
        }
    }
    
    // Try subtraction (addition case)
    return evaluateExpression(total: total - op, operands: operandsCopy, concat: concat)
}

func processFile(data: String) -> [(Int, [Int])] {
    
    var rows: [(Int, [Int])] = []
    
    let rowsArray = data.split(separator: "\n")
    for row in rowsArray {
        
        let components = row.split(separator: ":")
        guard components.count == 2 else { continue }
        
        let total = Int(components[0].trimmingCharacters(in: .whitespaces))!
        let numbers = components[1].trimmingCharacters(in: .whitespaces).split(separator: " ").map { Int($0)! }
        
        rows.append((total, numbers))
    }
    
    return rows
}

func part1(data: [(Int, [Int])]) -> Int {
    return data.filter { evaluateExpression(total: $0.0, operands: $0.1, concat: false) }.map { $0.0 }.reduce(0, +)
}

// Part 2: Check if the total can be made using addition, multiplication, or concatenation
func part2(data: [(Int, [Int])]) -> Int {
    return data.filter { evaluateExpression(total: $0.0, operands: $0.1, concat: true) }.map { $0.0 }.reduce(0, +)
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day7_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day7_input.txt"
do {
    let fileContent = try String(contentsOfFile: filePath)
    
    // Parse the input data
    let data = processFile(data: fileContent)
    
    // Calculate part 1 and part 2 results
    let result1 = part1(data: data)
    let result2 = part2(data: data)
    
    print("Part 1: \(result1)")
    print("Part 2: \(result2)")
    
} catch {
    print("Error reading file: \(error)")
}
