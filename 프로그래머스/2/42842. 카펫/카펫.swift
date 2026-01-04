import Foundation

// 카펫은 항상 직사각형 혹은 정사각형 모양을 유지한다..
// Int로 계산했을 때, 우연히 맞는 경우가 있음... 조심할 것...
func solution(_ brown:Int, _ yellow:Int) -> [Int] {

    var yellow_c: Double = 1.0
    var yellow_r: Double = Double(yellow)
    
    while yellow_r >= yellow_c {
        if yellow_r * 2 + yellow_c * 2 + 4.0 == Double(brown) {
            break
        } else {
            yellow_c += 1.0
            yellow_r = Double(yellow) / yellow_c
        }
    }
    
    let width = Int(yellow_r) + 2
    let hight = Int(yellow_c) + 2
    return [width, hight]
}