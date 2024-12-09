import Foundation

struct Rule: Hashable {
    let x: Int
    let y: Int
}

func readData(fromFile filePath: String) -> ([Rule], [[Int]])? {
    do {
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        let sections = fileContents.split(separator: "\n\n")

        var rules: [Rule] = []
        let ruleLines = sections[0].split(separator: "\n")
        for line in ruleLines {
            let parts = line.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2, let x = Int(parts[0]), let y = Int(parts[1]) {
                let rule = Rule(x: x, y: y)
                rules.append(rule)
            }
        }
        
        var pages: [[Int]] = []
        let pageLines = sections[1].split(separator: "\n")
        for line in pageLines {
            let pageNumbers = line.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            pages.append(pageNumbers)
        }
        
        return (rules, pages)
        
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

// Function to check if a list of pages is in valid order according to the rules
func isOrdered(pages: [Int], rules: [Rule]) -> Bool {
    // Create a map of each page to its index in the pages array
    var pageIndexMap: [Int: Int] = [:]
    for (index, page) in pages.enumerated() {
        pageIndexMap[page] = index
    }
    
    // Check each rule, and see if the before page comes before the after page
    for rule in rules {
        guard let before = pageIndexMap[rule.x], let after = pageIndexMap[rule.y] else {
            // If either of the pages is missing, we can ignore the rule
            continue
        }
        
        if before > after {
            return false
        }
    }
    
    return true
}

func sortPages(pages: [Int], rules: [Rule]) -> [Int] {
    var graph: [Int: [Int]] = [:]
    var inDegree: [Int: Int] = [:]
    
    for page in pages {
        graph[page] = []
        inDegree[page] = 0
    }
    
    for rule in rules {
        if pages.contains(rule.x) && pages.contains(rule.y) {
            graph[rule.x, default: []].append(rule.y)
            inDegree[rule.y, default: 0] += 1
        }
    }
    
    var queue: [Int] = pages.filter { inDegree[$0] == 0 }
    var sortedPages: [Int] = []
    
    while !queue.isEmpty {
        let currentPage = queue.removeFirst()
        sortedPages.append(currentPage)
        
        for neighbor in graph[currentPage, default: []] {
            inDegree[neighbor]! -= 1
            if inDegree[neighbor] == 0 {
                queue.append(neighbor)
            }
        }
    }

    // watch out for cycles
    if sortedPages.count != pages.count {
        return []
    }
    
    return sortedPages
}

func processUpdates(rules: [Rule], pages: [[Int]]) -> Int {
    var sumOfMiddlePages = 0
    
    for page in pages {
        if isOrdered(pages: page, rules: rules) {
            continue
        } else {
            //print(page)
            let sortedPage = sortPages(pages: page, rules: rules)
            if sortedPage.isEmpty {
                continue
            }
            //print(sortedPage)
            let middle = sortedPage[sortedPage.count / 2]
            //print(middle)
            sumOfMiddlePages += middle
        }
    }
    
    return sumOfMiddlePages
}

//let filePath = "/Users/David/Projects/AoC24/inputs/Day5_sample.txt"
let filePath = "/Users/David/Projects/AoC24/inputs/Day5_input.txt"
if let (rules, pages) = readData(fromFile: filePath) {
    
    //    print("Loaded Rules:")
    //    for rule in rules {
    //        print("x: \(rule.x), y: \(rule.y)")
    //    }
    
    //    print("\nLoaded Pages:")
    //    for page in pages {
    //        print(page)
    //    }
    
    let result = processUpdates(rules: rules, pages: pages)
    print(result)
    
} else {
    print("Failed to read data from file.")
}
