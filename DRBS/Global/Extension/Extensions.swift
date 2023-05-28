//
//  Extensions.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/11.
//

import UIKit
//extension UIViewController {
//    
//    // With this extension you can access the MainViewController from the child view controllers.
//    func revealViewController() -> MainVC? {
//        var viewController: UIViewController? = self
//        
//        if viewController != nil && viewController is MainVC {
//            return viewController! as? MainVC
//        }
//        while (!(viewController is MainVC) && viewController?.parent != nil) {
//            viewController = viewController?.parent
//        }
//        if viewController is MainVC {
//            return viewController as? MainVC
//        }
//        return nil
//    }
//}

extension UserDefaults {
    var userLocation: Location {
        get {
            guard let data = UserDefaults.standard.data(forKey: "userLocation") else { return Location(location: "") }
            return (try? PropertyListDecoder().decode(Location.self, from: data)) ?? Location(location: "")
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "userLocation")
        }
    }
    
    var userDetailAddress: DetailAddress {
        get {
            guard let data = UserDefaults.standard.data(forKey: "userDetailAddress") else { return DetailAddress(detailAddress: "") }
            return (try? PropertyListDecoder().decode(DetailAddress.self, from: data)) ?? DetailAddress(detailAddress: "")
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "userDetailAddress")
        }
    }
}

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00).cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

extension UIView {
    func addTopBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: self.frame.size.width/10, y: 0, width: self.frame.size.width - self.frame.size.width/5, height: 1)
        bottomLine.backgroundColor = UIColor.systemGray4.cgColor
//        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

//struct Roulette: Codable {
//    var index: Int
//    var name: String
//    var rate: Int
//    var color: Int
//}
//
//extension UserDefaults {
//    var rouletteList: [Roulette] {
//        get {
//            guard let data = UserDefaults.standard.data(forKey: "roulette") else { return [] }
//            return (try? PropertyListDecoder().decode([Roulette].self, from: data)) ?? []
//        }
//        set {
//            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "roulette")
//        }
//    }
//}


