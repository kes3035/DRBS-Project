
import UIKit

import Then
import SnapKit

class MyPageVC: UIViewController {
    
    // MARK: - Properties
    
    private let myPageTableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    
    
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
    }
    
    
    
    
    
    // MARK: - Method & Configure
    
    func configureNav() {
        navigationItem.title = "마이페이지"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToSideMenu" {
//            let sideMenuVC = segue.destination as! TestSideMenu
//            present(sideMenuVC, animated: true)
//
//        }
//
//    }

}
