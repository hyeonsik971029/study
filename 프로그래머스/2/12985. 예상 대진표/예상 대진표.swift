import Foundation

func solution(_ n:Int, _ a:Int, _ b:Int) -> Int
{
    var ans = 0
    var a = a
    var b = b
    while a != b {
        ans += 1
        
        if a % 2 == 0 {
            a /= 2
        } else {
            a = (a + 1) / 2
        }
        
        if b % 2 == 0 {
            b /= 2
        } else {
            b = (b + 1) / 2
        }
    }

    return ans
}