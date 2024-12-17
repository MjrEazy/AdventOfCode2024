import Foundation

var A = 0
var B = 0
var C = 0
var program: [Int] = []
var outputs = [Int]()

func executeInstruction(opcode: Int, operand: Int) {
    var comboOperand = operand
    switch operand {
    case 4:  // combo operand, use register A
        comboOperand = A
    case 5:  // combo operand, use register B
        comboOperand = B
    case 6:  // combo operand, use register C
        comboOperand = C
    default:
        break
    }
    switch opcode {
    case 0: // adv: A = A / (2^operand)
        let divisor = Int(pow(2.0, Double(comboOperand)))
        A = A / divisor
    case 1: // bxl: B = B XOR operand
        B = B ^ comboOperand
    case 2: // bst: B = operand % 8
        B = comboOperand % 8
    case 3: // jnz: Jump if A != 0
        return
    case 4: // bxc: B = B XOR C (operand is ignored)
        B = B ^ C
    case 5: // out: Output the value of operand % 8
        outputs.append(comboOperand % 8)
    case 6: // bdv: B = A / (2^operand)
        let divisor = Int(pow(2.0, Double(comboOperand)))
        B = A / divisor
    case 7: // cdv: C = A / (2^operand)
        let divisor = Int(pow(2.0, Double(comboOperand)))
        C = A / divisor
    default:
        break
    }
}

func runProgram() {
    var instructionPointer = 0
    
    while instructionPointer < program.count {
        let opcode = program[instructionPointer]
        let operand = program[instructionPointer + 1]
        
        executeInstruction(opcode: opcode, operand: operand)
        
        if opcode == 3 {
            if A == 0 {
                instructionPointer += 2
            } else {
                instructionPointer = operand
                continue
            }
        } else {
            instructionPointer += 2
        }
    }
}

func loadProgram(from filename: String) {
    do {
        let fileURL = URL(fileURLWithPath: filename)
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = content.split(separator: "\n").map { String($0) }
        if let registerA = lines.first(where: { $0.contains("Register A:") })?.split(separator: ":").last?.trimmingCharacters(in: .whitespaces) {
            A = Int(registerA) ?? 0
        }
        if let registerB = lines.first(where: { $0.contains("Register B:") })?.split(separator: ":").last?.trimmingCharacters(in: .whitespaces) {
            B = Int(registerB) ?? 0
        }
        if let registerC = lines.first(where: { $0.contains("Register C:") })?.split(separator: ":").last?.trimmingCharacters(in: .whitespaces) {
            C = Int(registerC) ?? 0
        }
        if let programLine = lines.first(where: { $0.contains("Program:") })?.split(separator: ":").last?.trimmingCharacters(in: .whitespaces) {
            program = programLine.split(separator: ",").compactMap { Int($0) }
        }
        
    } catch {
        print("Error reading file: \(error)")
    }
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day17_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day17_input.txt"
loadProgram(from: filePath)
runProgram()
let result = outputs.map { String($0) }.joined(separator: ",")
print(result)
