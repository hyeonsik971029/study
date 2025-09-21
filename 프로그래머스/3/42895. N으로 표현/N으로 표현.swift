import Foundation

func solution(_ N:Int, _ number:Int) -> Int {
    
    if N == number { return 1 }
    
    // dp[i] = N을 i번 사용해서 만들 수 있는 정수들의 집합 (i: 1...8)
    var dp  = Array(repeating: Set<Int>(), count: 9)
    
    // i번 이어붙인 값: N, NN, NNN, ...
    func concat(_ n: Int, count: Int) -> Int {
        var concat = 0
        for _ in 0..<count { concat = concat * 10 + n }
        return concat
    }
    
    for i in 1...8 {
        dp[i].insert(concat(N, count: i))
        
        if i >= 2 {
            for j in 1..<i {
                let firsts = dp[j]
                let seconds = dp[i - j]
                for first in firsts {
                    for second in seconds {
                        dp[i].insert(first + second)
                        dp[i].insert(first - second)
                        dp[i].insert(first * second)
                        if second != 0 { dp[i].insert(first / second) }
                        
                        dp[i].insert(second - first)
                        if first != 0 { dp[i].insert(second / first) }
                    }
                }
            }
        }
        
        if dp[i].contains(number) { return i }
    }
    
    return -1
}