import Foundation

func solution(_ s:String) -> [Int] {
    
    var remain = s
    var removeZeroCnt = 0
    var whileCnt = 0
    
    while true {
        if remain == "1" { break }
        
        var tmp = remain.filter { $0 != "0" }
        removeZeroCnt += remain.count - tmp.count
        whileCnt += 1
        
        remain = String(tmp.count, radix: 2)
    }
    
    return [whileCnt, removeZeroCnt]
}