func solution(_ n:Int) -> Int {
    
    func fibo(_ target: Int) -> Int {
        guard target > 1 else { return target }
        
        var cache: [Int] = [0, 1]
        for t in 2...target {
            let remain = (cache[t-2] + cache[t-1]) % 1234567
            cache.append(remain)
        }
        return cache[target]
    }
    
    return fibo(n)
}