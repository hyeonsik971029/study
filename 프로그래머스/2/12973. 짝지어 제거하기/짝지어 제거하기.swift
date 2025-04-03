import Foundation

func solution(_ s:String) -> Int{
    guard s.count > 1 else { return 0 }
    
    var tmp = [String]()
    for str in s {
        if tmp.isEmpty == false, tmp.last! == String(str) {
            tmp.popLast()
            continue
        }
        
        tmp.append(String(str))
    }
    
    return tmp.isEmpty ? 1 : 0
}