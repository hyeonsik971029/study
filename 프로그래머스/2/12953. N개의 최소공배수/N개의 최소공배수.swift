// 2, 3, 5, 7로 더 이상 나눌 수 없을 때까지 나누기
// 나머지 * [2, 3, 5, 7] 갯수
func solution(_ arr:[Int]) -> Int {
    
    var arr = arr
    var max = arr.max()!
    var num = 2
    
    if max == 1 { return 1 }
    
    var ans = 1
    while num <= max {
        var check = false
        for idx in 0..<arr.count {
            if arr[idx] % num == 0 {
                arr[idx] /= num
                check = true
            }
        }
        
        if check {
            ans *= num
        } else {
            num += 1
        }
    }
    
    return ans * arr.reduce(1, *)
}