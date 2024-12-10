import Foundation

// DANGER! DANGER! Will Robinson!
// Brute forced, took several hours to run overnight in a playground :)  Need to re-write to optimise - recustion & memosition should do it and compile!
func evaluateExpression(_ expression: [String], usingOperators operators: [String]) -> Int? {
    var result = Int(expression[0])!
    
    for i in 1..<expression.count {
        let operatorSymbol = operators[i-1]
        let number = Int(expression[i])!
        
        switch operatorSymbol {
        case "*":
            result *= number
        case "+":
            result += number
        default:
            return nil
        }
    }
    
    return result
}

func processRow(testValue: Int, row: String) -> Int? {
    let numbers = row.split(separator: " ").map { String($0) }
    let numCount = numbers.count - 1
    let operatorCombinations: [String] = (0..<numCount).map { _ in "+" }
    
    var operatorPermutations = [[String]]()
    for i in 0..<(1 << numCount) {
        var currentOperators: [String] = []
        
        for j in 0..<numCount {
            if (i & (1 << j)) != 0 {
                currentOperators.append("*")
            } else {
                currentOperators.append("+")
            }
        }
        
        operatorPermutations.append(currentOperators)
    }
    
    for operators in operatorPermutations {
        if let result = evaluateExpression(numbers, usingOperators: operators), result == testValue {
            return testValue
        }
    }
    
    return nil
}

func processFile(filePath: String) -> Int {
    do {
        let fileContent = try String(contentsOfFile: filePath)
        let lines = fileContent.split(separator: "\n")
        
        var totalSum = 0
        
        for line in lines {
            let row = line.trimmingCharacters(in: .whitespaces)
            guard !row.isEmpty else { continue }
            
            let components = row.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            //print(components)
            guard components.count == 2,
                  let testValue = Int(components[0]) else {
                continue
            }
            //print(testValue)
            if let validTestValue = processRow(testValue: testValue, row: components[1]) {
                totalSum += validTestValue
            }
        }
        
        return totalSum
        
    } catch {
        print("Error reading file: \(error)")
        return 0
    }
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day7_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day7_input.txt"
let result = processFile(filePath: filePath)
print(result)
