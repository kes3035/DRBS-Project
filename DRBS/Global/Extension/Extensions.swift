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
}
