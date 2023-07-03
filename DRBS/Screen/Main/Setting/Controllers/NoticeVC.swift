

import UIKit

import Then
import SnapKit

class NoticeVC: UIViewController {
    
    // MARK: - Properties

    private let noticeTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.estimatedRowHeight = 110 // 대략적인 높이값
        $0.rowHeight = UITableView.automaticDimension // 실제 높이 계산
        $0.separatorColor = .opaqueSeparator
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviBar()
        
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: "NoticeTableViewCell")

        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        
    }
    
    // MARK: - Navigation Bar
    
    private func setupNaviBar() {
        navigationItem.title = "공지사항"
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
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NoticeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as! NoticeTableViewCell

        let item = noticeData[indexPath.row]

        cell.configure(title: item.title, date: item.date)
        
        cell.selectionStyle = .none

        return cell
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // 셀의 separator 인셋을 지정하여 separator의 좌우 여백을 조절
            if let cell = cell as? NoticeTableViewCell {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
        }
    
}
