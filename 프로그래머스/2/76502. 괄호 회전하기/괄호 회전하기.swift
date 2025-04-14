import Foundation

// 연속된 순열의 합과 같은 순환 배열 문제
func solution(_ s:String) -> Int {
    
    let count = s.count
    var stack = [String]()
    var ans = 0
    
    for i in 0..<count {
        for j in i..<i+count {
            let val = s[j%count]
            if let last = stack.last {
                let first = last == "(" && val == ")"
                let second = last == "{" && val == "}"
                let thrid = last == "[" && val == "]"
                
                if first || second || thrid {
                    stack.popLast()
                } else {
                    stack.append(val)
                }
            } else {
                stack.append(val)
            }
        }
        if stack.isEmpty {
            ans += 1
        } else {
            stack = []
        }
    }
    
    return ans
}

extension String {
    subscript(_ index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)])
    }
}