
import Foundation

enum Category: String, Codable {
    case utilityBill = "공과금"
    case food = "식비"
    case etc = "기타"
    case all = "전체"
    
    static func categoryImage(category: String) -> UIImage? {
        switch category {
        case Category.all.rawValue:
            return UIImage(systemName: "questionmark")
        case Category.utilityBill.rawValue:
            return UIImage(systemName: "dollarsign")
        case Category.food.rawValue:
            return UIImage(systemName: "fork.knife")
        case Category.etc.rawValue:
            return UIImage(systemName: "questionmark")
        default:
            return UIImage(systemName: "questionmark")
        }
    }
}
