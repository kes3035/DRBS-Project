
import UIKit

enum MyColor: Int {
    case utilityBill = 1
    case food = 2
    case etc = 3
    case all = 4
    
    var backgroundColor: UIColor {
        switch self {
        case .utilityBill:
            return UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00)
        case .food:
            return UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00)
        case .etc:
            return UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00)
        case .all:
            return UIColor.black
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .utilityBill:
            return UIColor(red: 0.79, green: 0.85, blue: 0.71, alpha: 1.00)
        case .food:
            return UIColor(red: 0.67, green: 0.80, blue: 0.45, alpha: 1.00)
        case .etc:
            return UIColor(red: 0.38, green: 0.60, blue: 0.40, alpha: 1.00)
        case .all:
            return UIColor.black
        }
    }
}

