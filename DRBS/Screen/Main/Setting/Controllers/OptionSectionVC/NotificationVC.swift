

import UIKit

import Then
import SnapKit
import UserNotifications

class NotificationVC: UIViewController {
    
    // MARK: - Properties

    private let notificationTableView = UITableView().then {
        $0.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.id)
    }
    
    
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviBar()
        setupTableView()
        
        // 옵저버를 등록하여 앱이 포그라운드로 진입할 때마다 알림 권한 상태를 다시 확인하고 UserDefaults에 저장하는 코드
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            self.checkNotificationAuthorizationStatus { isAuthorized in
                UserDefaults.standard.set(isAuthorized, forKey: "NotificationAuthorizationStatus")
            }
        }


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupFooterView()
        
    }
    
    // MARK: - Setup TableView

    private func setupTableView() {
        view.addSubview(notificationTableView)

        notificationTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        notificationTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        notificationTableView.separatorInsetReference = .fromCellEdges
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
    }

    private func setupFooterView() {
        
        let footerLabel = UILabel().then {
            $0.text = "• DRBS에서 누릴 수 있는 다양한 혜택을 푸시알림을 통해 받아보실 수 있습니다."
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = .gray
        }

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.notificationTableView.frame.width, height: 50))
        footerView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }

        notificationTableView.tableFooterView = footerView
        notificationTableView.layoutIfNeeded()
        
    }


    // MARK: - Navigation Bar

    func setupNaviBar() {
        navigationItem.title = "알림"
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
    
    
    @objc private func switchToggled(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? NotificationTableViewCell,
              let indexPath = notificationTableView.indexPath(for: cell) else {
            return
        }

        let _ = NotificationManager.shared.notifications[indexPath.row]

        if sender.isOn {
            checkNotificationAuthorizationStatus { isAuthorized in
                if isAuthorized {
                    // 알림 권한이 이미 허용된 경우
                    self.requestNotificationAuthorization(forCell: cell)
                } else {
                    // 알림 권한이 거부되었을 경우 사용자에게 설정 앱으로 이동할 것을 제안
                    let alertController = UIAlertController(title: "알림 권한 필요", message: "알림 기능을 사용하려면 설정 앱에서 알림 권한을 허용해야 합니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "설정", style: .default) { _ in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    })
                    alertController.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
                        // 토글 스위치를 꺼진 상태로 되돌림.
                        sender.isOn = false
                    })
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            // 알림 끄기
            disableNotifications()
        }
    }


    // 알림 권한 요청에 대한 사용자의 응답을 처리
    private func requestNotificationAuthorization(forCell cell: NotificationTableViewCell) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                // 알림 권한이 허용되었거나 거부되었을 경우 UserDefaults에 저장
                UIApplication.shared.registerForRemoteNotifications()
                UserDefaults.standard.set(granted, forKey: "NotificationAuthorizationStatus")
                if !granted {
                    // 토글 스위치를 꺼진 상태로 되돌림.
                    cell.toggleSwitch.isOn = false
                }
            }
        }
    }


    // 알림 권한 상태를 확인하는 함수
    private func checkNotificationAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        if UserDefaults.standard.bool(forKey: "NotificationAuthorizationStatus") {
            // 이전에 권한이 이미 허용된 경우
            completion(true)
            return
        }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isAuthorized = settings.authorizationStatus == .authorized
                completion(isAuthorized)
                UserDefaults.standard.set(isAuthorized, forKey: "NotificationAuthorizationStatus")
            }
        }
    }

    // 이미 전달된 알림을 모두 제거
    private func disableNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    // 앱이 포그라운드로 돌아올 때마다 토글 상태를 확인하고 업데이트 하는 코드
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkNotificationAuthorizationStatus { isAuthorized in
            UserDefaults.standard.set(isAuthorized, forKey: "NotificationAuthorizationStatus")
            self.notificationTableView.reloadData()
        }
    }




    // 앱이 포그라운드로 돌아올 때 토글 상태를 업데이트하려면 아래 메서드 작성
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationTableView.reloadData()
    }




    
}

    // MARK: - UITableViewDataSource, UITableViewDelegate

extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationManager.shared.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.id, for: indexPath) as! NotificationTableViewCell
            let notifications = NotificationManager.shared.notifications[indexPath.row]
            cell.titleLabel.text = notifications.leftTitle
            cell.toggleSwitch.isOn = notifications.rightItem

            // 토글 스위치 이벤트 대상 설정
            cell.toggleSwitch.removeTarget(nil, action: nil, for: .valueChanged)
            cell.toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
            cell.selectionStyle = .none

            return cell
    }
    


}
