

import UIKit

enum MyColor: Int {
    case gray = 1
    case green = 2
    case red = 3
    
    var backgroundColor: UIColor {
        switch self {
        case .gray:
            return UIColor(red: 0.95, green: 0.93, blue: 0.76, alpha: 1.00)

//            return UIColor.systemGray5
        case .green:
//            return UIColor(red: 194/255, green: 237/255, blue: 234/255, alpha: 1)
            return UIColor(red: 0.80, green: 0.91, blue: 0.56, alpha: 1.00)

        case .red:
//            return UIColor(red: 0.75, green: 0.67, blue: 0.89, alpha: 1.00)
//            return UIColor(red: 0.38, green: 0.53, blue: 0.43, alpha: 1.00)
            return UIColor(red: 0.62, green: 0.75, blue: 0.55, alpha: 1.00)
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .gray:
//            return UIColor.darkGray
            return UIColor(red: 0.79, green: 0.85, blue: 0.71, alpha: 1.00)

        case .green:
//            return UIColor(red: 89/255, green: 190/255, blue: 183/255, alpha: 1)
            return UIColor(red: 0.67, green: 0.80, blue: 0.45, alpha: 1.00)

        case .red:
//            return UIColor(red: 0.39, green: 0.36, blue: 0.73, alpha: 1.00)
//            return UIColor(red: 0.24, green: 0.38, blue: 0.33, alpha: 1.00)
            return UIColor(red: 0.38, green: 0.60, blue: 0.40, alpha: 1.00)

        }
    }
}

