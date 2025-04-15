import Foundation

func solution(_ want:[String], _ number:[Int], _ discount:[String]) -> Int {
    
    var goods = Dictionary(uniqueKeysWithValues: zip(want, number))
    var count = discount.count
    
    var ans = 0
    
    for i in 0..<count {        
        if goods.allSatisfy { $0.value <= 0 } {
            ans += 1
        }
        
        if (count - i) < 10 {
            break
        } else {
            goods = Dictionary(uniqueKeysWithValues: zip(want, number))
            
            for j in i..<i+10 {
                let item = discount[j]
                if let good = goods[item] {
                    goods[item] = good - 1
                }
            }
        }
    }
    
    return ans
}