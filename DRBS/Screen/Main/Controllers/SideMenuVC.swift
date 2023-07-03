

import UIKit

class SideMenuVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var drbsLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var termsAndConditionButton: UIButton!
    @IBOutlet weak var treatingPersonalInformation: UIButton!
    @IBOutlet weak var bottomLine: UIView!
    
    private var menu: [SideMenuModel] = [
    SideMenuModel(icon: UIImage(systemName: "map")!, title: "지역 설정"),
    SideMenuModel(icon: UIImage(systemName: "wand.and.stars")!, title: "메뉴 추천"),
    SideMenuModel(icon: UIImage(systemName: "dollarsign")!, title: "나눠 내기"),
    SideMenuModel(icon: UIImage(systemName: "gearshape")!, title: "설정")
    ]
    var defaultHighlightedCell: Int = 0

    
    //MARK: - LifeCycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureUI()
        userImageView.layer.cornerRadius = 30
        userImageView.clipsToBounds = true
        self.userImageView.image = UIImage(named: "쿠루루.png")
        
    }
    
    //MARK: - Helpers

    func setupTableView() {
        menuTableView.register(SideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")
        menuTableView.delegate = self
        menuTableView.dataSource = self
        self.menuTableView.separatorStyle = .none
        self.menuTableView.rowHeight = 75
    }

    func configureUI() {
        bottomLine.backgroundColor = .lightGray
    }
    
}

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("지역설정탭 눌림")
            let addressVC = AddressVC()
            self.navigationController?.pushViewController(addressVC, animated: true)
//            let calendarVC = CalendarVC()
//            self.navigationController?.pushViewController(calendarVC, animated: true)
        case 1:
            print("메뉴추천탭 눌림")
        case 2:
            print("나눠내기탭 눌림")
        case 3:
            let settingMainVC = SettingMainVC()
            self.navigationController?.pushViewController(settingMainVC, animated: true)
        default:
            break
        }
    }
}

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
    
    
}
