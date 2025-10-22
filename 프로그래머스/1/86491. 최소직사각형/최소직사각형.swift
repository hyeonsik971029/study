import Foundation

func solution(_ sizes:[[Int]]) -> Int {
    
    var maxValue = 0
    var minValue = 0
    for size in sizes {
        maxValue = max(maxValue, size.max()!)
        minValue = max(minValue, size.min()!)
    }
    return maxValue * minValue
}