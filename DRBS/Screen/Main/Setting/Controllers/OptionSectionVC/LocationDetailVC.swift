

import UIKit

import Then
import SnapKit

class LocationDetailVC: UIViewController {

    // MARK: - Properties

//    private let contentTextView = UITextView().then {
//        <#code#>
//    }
    
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviBar()
        
        view.backgroundColor = .white
    }
    

    
    // MARK: - Navigation Bar

    private func setupNaviBar() {
        navigationItem.title = "위치기반서비스 이용동의(선택)"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    // MARK: - Setup Layout
    
    

}
