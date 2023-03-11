//
//  SideMenuVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/11.
//

import UIKit
protocol SideMenuVCDelegate: AnyObject {
    func selectedCell(_ row: Int)
}

class SideMenuVC: UIViewController {
    //MARK: - Properties

    @IBOutlet weak var sideMenuWelcomeLabel: UILabel!
    
    @IBOutlet weak var sideMenuTitleLabel: UILabel!
    
    @IBOutlet weak var sideMenuUserIamgeView: UIImageView!
    
    @IBOutlet weak var sideMenuUserNameLabel: UILabel!
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    private var menu: [SideMenuModel] = [
    SideMenuModel(icon: UIImage(systemName: "map")!, title: "지역 설정"),
    SideMenuModel(icon: UIImage(systemName: "wand.and.stars")!, title: "메뉴 추천"),
    SideMenuModel(icon: UIImage(systemName: "dollarsign")!, title: "나눠 내기"),
    SideMenuModel(icon: UIImage(systemName: "gearshape")!, title: "설정")
    ]
    var defaultHighlightedCell: Int = 0

    weak var sideVCDelegate: SideMenuVCDelegate?
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHighlightedCell()
    }
    //MARK: - Helpers
    func configureUI() {
        
    }
    
    func setupTableView() {
        sideMenuTableView.register(SideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.separatorStyle = .none
        self.sideMenuTableView.rowHeight = 75
    }
    
    func setupHighlightedCell() {
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
    }
    //MARK: - Actions


}

//MARK: - UITableViewDelegate
extension SideMenuVC: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideVCDelegate?.selectedCell(indexPath.row)
    }
    
    
}
