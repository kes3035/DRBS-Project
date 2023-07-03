

import UIKit

import Then
import SnapKit

class LocationVC: UIViewController {

    // MARK: - Properties
    
    private let locationTableView = UITableView().then {
        $0.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.id)
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupTableView()
        

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupFooterView()
    }

    // MARK: - Navigation Bar
    
    private func setupNaviBar() {
        navigationItem.title = "위치 기반 서비스 이용 동의 설정"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
            $0.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Setup TableView
    
    private func setupTableView() {
        
        view.addSubview(locationTableView)
        locationTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        locationTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        locationTableView.separatorInsetReference = .fromCellEdges
        locationTableView.dataSource = self
        locationTableView.delegate = self
    }
    
    private func setupFooterView() {
        let footerLabel = UILabel().then {
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = .gray

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2

            let attributedString = NSMutableAttributedString(string: "• 위치기반서비스를 이용하기 위해서는 위치 선택, 접근권한에 먼저 동의하셔야 합니다.\n",
                                                             attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                                                             
            attributedString.append(NSMutableAttributedString(string: "\n• 선택 접근권한은 동의하지 않아도 서비스를 이용할 수 있으나, 해당 권한이 필요한 기능은 이용이 제한될 수 있습니다.",
                                                              attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]))

            $0.attributedText = attributedString
        }

        let footerView = UIView()
        footerView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }

        locationTableView.tableFooterView = footerView
        locationTableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
    }

}

    // MARK: - UITableViewDataSource, UITableViewDelegate

extension LocationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationManager.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.id, for: indexPath) as! LocationTableViewCell
        let locations = LocationManager.shared.locations[indexPath.row]
        cell.titleLabel.text = locations.leftTitle
        cell.toggleSwitch.isOn = locations.rightItem
        cell.selectionStyle = .none

        cell.onDetailsButtonTapped = { [weak self] in
            let locationDetailVC = LocationDetailVC()
            let navigationController = UINavigationController(rootViewController: locationDetailVC)
            navigationController.modalPresentationStyle = .automatic
            self?.present(navigationController, animated: true, completion: nil)
        }

        return cell
    }}
