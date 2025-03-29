import Foundation

// B 배열 원소들의 가능한 조합
func solution(_ A:[Int], _ B:[Int]) -> Int
{
    let sortA = A.sorted()
    let reverseSortB = B.sorted(by: >)
    
    var ans = 0
    zip(sortA, reverseSortB).forEach { a, b in
        ans += a * b
    }
    
    return ans
}