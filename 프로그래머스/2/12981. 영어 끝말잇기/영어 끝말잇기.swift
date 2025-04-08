import Foundation

func solution(_ n:Int, _ words:[String]) -> [Int] {
    
    var check = [String]()
    check.append(words[0])
    
    for idx in 1..<words.count {
        if check.contains(words[idx]) {
            return [(idx%n)+1, (idx/n)+1]
        } else {
            check.append(words[idx])
        }
        
        let prev = check[idx-1]
        let curr = check[idx]
        if prev[prev.count-1] != curr[0] {
            return [(idx%n)+1, (idx/n)+1]
        }
    }
    
    return [0, 0]
}

extension String {
    
    subscript(_ index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)])
    }
}