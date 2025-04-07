func solution(_ n:Int) -> Int {
    
    if n == 1 { return 1 }
    if n == 2 { return 2 }
    
    var ans = [Int](repeating: 0, count: 20001)
    ans[1] = 1
    ans[2] = 2
    
    for idx in 3...n {
        ans[idx] = (ans[idx-2] + ans[idx-1]) % 1234567
    }
    
    return ans[n]
}
