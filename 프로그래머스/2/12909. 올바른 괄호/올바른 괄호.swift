import Foundation

func solution(_ s:String) -> Bool
{
    var count: Int = 0
    
    s.forEach { sub in
        guard count >= 0 else { return }
               
        if sub == "(" { count += 1 }
        else { count -= 1 }
    }

    return count == 0
}