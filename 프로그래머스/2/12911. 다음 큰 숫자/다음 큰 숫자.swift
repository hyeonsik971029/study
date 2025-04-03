import Foundation

func solution(_ n:Int) -> Int
{
    var ans = n
    var oneCount = String(n, radix: 2).filter{ $0 == "1" } .count
    
    while true {
        ans += 1
        if oneCount == String(ans, radix: 2).filter{ $0 == "1" } .count {
            break
        }
    }
    
    return ans
}