import Foundation

func solution(_ k:Int, _ dungeons:[[Int]]) -> Int {
    var permuteds = [[[Int]]]()
    var current = dungeons
    
    func permute(_ index: Int) {
        if index == dungeons.count {
            permuteds.append(current)
            return
        }
        
        for i in index..<current.count {
            current.swapAt(index, i)
            permute(index + 1)
            current.swapAt(index, i)
        }
    }
    
    permute(0)
    
    var maxCount = 0
    for permuted in permuteds {
        var k = k
        var count = 0
        for i in 0..<permuted.count {
            if permuted[i][0] > k {
                maxCount = max(maxCount, count)
            } else {
                k -= permuted[i][1]
                count += 1
            }
        }
        maxCount = max(maxCount, count)
    }
    
    return maxCount
}