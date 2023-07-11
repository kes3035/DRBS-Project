
import UIKit
import SideMenu
import FSCalendar

class TabbarVC: UITabBarController {
    //MARK: - Properties
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
           
    }
    
    //MARK: - Helpers
    func setupTabbbar() {
        
    }
    
    func setupTabbar() {
        //        self.delegate = self
        let memoFetcher = MemoFetcher.shared
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        self.tabBar.layer.borderWidth = 2
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller1 = storyboard.instantiateViewController(withIdentifier: "RecommandVC") as? RecommandVC else { return }
        guard let controller2 = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
        memoFetcher.memoFetcher { memo in
            controller2.expenseSnapshot = memo
            controller2.memo = memo
        }
        guard let controller3 = storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
        guard let controller4 = storyboard.instantiateViewController(withIdentifier: "CheckListVC") as? CheckListVC else { return }
        guard let controller5 = storyboard.instantiateViewController(withIdentifier: "MyPageVC") as? MyPageVC else { return }
        controller1.tabBarItem.image = UIImage(systemName: "person")
        controller2.tabBarItem.image = UIImage(systemName: "calendar")
        controller4.tabBarItem.image = UIImage(named: "checklist.png")
        controller5.tabBarItem.image = UIImage(systemName: "person")
        let nav1 = UINavigationController(rootViewController: controller1)
        let nav2 = UINavigationController(rootViewController: controller2)
        let nav3 = UINavigationController(rootViewController: controller3)
        nav3.title = ""
        let nav4 = UINavigationController(rootViewController: controller4)
        let nav5 = UINavigationController(rootViewController: controller5)
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        self.selectedIndex = 2
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        menuButton.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        menuButton.setTitle("D", for: .normal)
        menuButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
    }
   
    
    //MARK: - Actions
    @objc func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
    }
    
}
//MARK: - SideMenuVCDelegate

 
    


