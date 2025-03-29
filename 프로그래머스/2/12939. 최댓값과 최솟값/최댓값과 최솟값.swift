func solution(_ s:String) -> String {
    let array = s.split(separator: " ").map { Int($0)! }
    
    return "\(array.min()!) \(array.max()!)"
}