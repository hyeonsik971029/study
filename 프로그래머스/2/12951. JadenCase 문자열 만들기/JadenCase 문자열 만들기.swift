func solution(_ s:String) -> String {
    var ans = ""
    var isFirst = true
    
    s.forEach { sub in
        var subStr = " "
        if sub.isLetter || sub.isNumber {
            if isFirst {
                isFirst = false
                subStr = sub.uppercased()
            } else {
                subStr = sub.lowercased()
            }
        } else {
            isFirst = true
        }
               
        ans += subStr
    }
    
    return ans
}