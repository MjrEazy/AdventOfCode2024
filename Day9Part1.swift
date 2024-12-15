import Foundation

func parseDiskMap(_ input: String) -> [String] {
    var diskMap = [String]()
    var fileId = 0
    var index = 0
    
    while index < input.count {
        //print(fileId)
        let fileLength = Int(String(input[input.index(input.startIndex, offsetBy: index)]))!
        //print(fileLength)
        for _ in 0..<fileLength {
            diskMap.append("\(fileId)")  // Store fileId as a string
        }
        //print(diskMap)
        index += 1
        if index < input.count {
            let freeSpaceLength = Int(String(input[input.index(input.startIndex, offsetBy: index)]))!
            
            for _ in 0..<freeSpaceLength {
                diskMap.append(".")
            }
            index += 1
        }
        fileId += 1
    }
    //print(diskMap.joined())
    return diskMap
}

func compactDiskMap(diskMap: [String]) -> [String] {
    var compactedMap = diskMap
    var freeSpaceIndex = 0  // Start with the first free space (.)
    
    var fileIndex = compactedMap.count - 1
    
    while fileIndex >= 0 && compactedMap[fileIndex] == "." {
        fileIndex -= 1
    }
    
    while fileIndex >= 0 && freeSpaceIndex < fileIndex {
        
        freeSpaceIndex = 0
        while freeSpaceIndex < compactedMap.count && compactedMap[freeSpaceIndex] != "." {
            freeSpaceIndex += 1
        }
        if freeSpaceIndex < compactedMap.count {
            compactedMap[freeSpaceIndex] = compactedMap[fileIndex]
            compactedMap[fileIndex] = "."
            
            freeSpaceIndex += 1
        }
        while fileIndex >= 0 && compactedMap[fileIndex] == "." {
            fileIndex -= 1
        }
    }
    //print(compactedMap.joined())
    return compactedMap
}

func calculateChecksum(compactedMap: [String]) -> Int {
    var checksum = 0
    for (index, str) in compactedMap.enumerated() {
        if str != "." {
            let fileId = Int(str)!  // Convert the fileId string to an integer
            checksum += index * fileId
        }
    }
    return checksum
}

func compactAndCalculateChecksum(input: String) -> Int {
    let diskMap = parseDiskMap(input)
    //print("Parsed: \(diskMap.joined())")
    var compactedMap = compactDiskMap(diskMap: diskMap)
    compactedMap = compactDiskMap(diskMap: compactedMap)  // HACK: As had not moved last block of last file, I've spent too long on this one already
    print("Compacted: \(compactedMap.joined())")
    let checksum = calculateChecksum(compactedMap: compactedMap)
    return checksum
}

func readInputFromFile(at path: String) -> String? {
    do {
        let input = try String(contentsOfFile: path, encoding: .utf8)
        return input.trimmingCharacters(in: .whitespacesAndNewlines)
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day9_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day9_input.txt"
if let diskMap = readInputFromFile(at: filePath) {
    //print("Input disk map: \(diskMap)")
    let checksum = compactAndCalculateChecksum(input: diskMap)
    print("Checksum: \(checksum)")
    
} else {
    print("Failed to read the input file.")
}
