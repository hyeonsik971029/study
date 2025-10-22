import Foundation

func solution(_ numbers:[Int]) -> String {
    let sorted = numbers.sorted(by: { first, second in
        Int("\(first)\(second)")! > Int("\(second)\(first)")!
    })
    
    if sorted.first == 0 { return "0" }
    return sorted.map { "\($0)" }.reduce("", +)
}