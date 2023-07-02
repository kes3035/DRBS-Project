//
//  testVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/21.
//

import UIKit
import SideMenu
class SideMenuNav: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.7
        self.leftSide = true
        self.statusBarEndAlpha = 0.0
        self.presentDuration = 0.5
        self.dismissDuration = 0.5
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
