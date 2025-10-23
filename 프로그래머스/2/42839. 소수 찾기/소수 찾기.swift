import Foundation

func solution(_ numbers:String) -> Int {
    
    func permute(_ arr: [String]) -> [String] {
        
        if arr.count == 0 { return [] }

        return (0..<arr.count).flatMap { idx -> [String] in
            var removed = arr
            let element = String(removed.remove(at: idx))
            return [element] + permute(removed).map { element + $0 }
        }
    }
    
    func isPrime(_ value: Int) -> Bool? {
        
        if value < 2 { return false }
        for idx in 2..<value {
            if value % idx == 0 { return false }
        }
        return true
    }
    
    let toArr = numbers.compactMap { String($0) }
    let toPermute = permute(toArr).map { Int($0)! }
    
    return Set(toPermute).filter { (isPrime($0) ?? false) }.count
}