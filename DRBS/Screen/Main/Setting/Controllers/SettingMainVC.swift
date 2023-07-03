

import UIKit

import Then
import SnapKit
import SafariServices

class SettingMainVC: UIViewController {
    
    // MARK: - Properties
    
    private let settingTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.id)
        $0.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.id)
        $0.register(OptionCell.self, forCellReuseIdentifier: OptionCell.id)
        $0.register(LicenseCell.self, forCellReuseIdentifier: LicenseCell.id)
        $0.register(AppVersionCell.self, forCellReuseIdentifier: AppVersionCell.id)
        $0.separatorColor = .opaqueSeparator
    }
    
    var dataSource = [SettingSection]()
    
    // 앱 버전 확인
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        
        let versionAndBuild: String = "\(version)"
        return versionAndBuild
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        refresh()
        
        self.view.addSubview(self.settingTableView)
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
        self.settingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Navigation Bar
    
    private func setupNaviBar() {
        navigationItem.title = "설정"
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

    
    func refresh() {
        
        // Notice
        let noticeName = NoticeModel(leftTitle: "공지사항")
        let noticeSection = SettingSection.notice([noticeName])
        
        
        // profile
        let profileName = ProfileModel(leftTitle: "프로필 설정")
        let profileSection = SettingSection.profile([profileName])
        
        // Option
        let optionNames = [
            OptionModel(leftTitle: "알림"),
            OptionModel(leftTitle: "위치 기반 서비스 이용 동의 설정")
        ]
        let optionSection = SettingSection.option(optionNames)
        
        // license
        let licenseNames = [
            LicenseModel(leftTitle: "개인정보처리방침"),
            LicenseModel(leftTitle: "오픈소스 라이선스")
        ]
        let licenseSection = SettingSection.license(licenseNames)
        
        // AppVersion
        let appVersionName = AppVersionModel(leftTitle: "앱 버전", rightTitle: version)
        let appVersionSection = SettingSection.appVersion([appVersionName])
        
        
        self.dataSource = [noticeSection, profileSection, optionSection, licenseSection, appVersionSection]
        self.settingTableView.reloadData()
    }
    
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingMainVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.dataSource[section] {
        case let .notice(noticeModel):
            return noticeModel.count
            
        case let .profile(profileModel):
            return profileModel.count
            
        case let .option(optionModels):
            return optionModels.count
            
        case let .license(licenseModels):
            return licenseModels.count
            
        case let .appVersion(appVersionModel):
            return appVersionModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.section] {
        case let .notice(noticeModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.id, for: indexPath) as! NoticeCell
            let noticeModel = noticeModel[indexPath.row]
            cell.prepare(leftTitleText: noticeModel.leftTitle)
            return cell
            
        case let .profile(profileModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.id, for: indexPath) as! ProfileCell
            let profileModel = profileModel[indexPath.row]
            cell.prepare(leftTitleText: profileModel.leftTitle)
            return cell
            
        case let .option(optionModels):
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.id, for: indexPath) as! OptionCell
            let optionModel = optionModels[indexPath.row]
            cell.prepare(leftTitleText: optionModel.leftTitle)
            return cell
            
        case let .license(licenseModels):
            let cell = tableView.dequeueReusableCell(withIdentifier: LicenseCell.id, for: indexPath) as! LicenseCell
            let licenseModel = licenseModels[indexPath.row]
            cell.prepare(leftTitleText: licenseModel.leftTitle)
            return cell
            
        case let .appVersion(appVersionModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: AppVersionCell.id, for: indexPath) as! AppVersionCell
            let appVersionModel = appVersionModel[indexPath.row]
            cell.prepare(leftTitleText: appVersionModel.leftTitle, rightTitleText: appVersionModel.rightTitle)
            return cell
        }
    }
    
    // 헤더 없애기
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView().then {
                $0.backgroundColor = .clear
            }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath.section] {
        case .notice(let noticeNames):
            let _ = noticeNames[indexPath.row]
            let noticeVC = NoticeVC()
            self.navigationController?.pushViewController(noticeVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            break
        case .profile(let profileNames):
            let _ = profileNames[indexPath.row]
            let profileVC = ProfileVC()
            self.navigationController?.pushViewController(profileVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            break
        case .option(let optionNames):
            let optionName = optionNames[indexPath.row]
            switch optionName.leftTitle {
            case "알림":
                let _ = optionNames[indexPath.row]
                let notificationVC = NotificationVC()
                self.navigationController?.pushViewController(notificationVC, animated: true)
                break
            case "위치 기반 서비스 이용 동의 설정":
                let _ = optionNames[indexPath.row]
                let locationVC = LocationVC()
                self.navigationController?.pushViewController(locationVC, animated: true)
                break
            default:
                break
            }
        case .license(let licenseNames):
            let licenseName = licenseNames[indexPath.row]
            switch licenseName.leftTitle {
            case "개인정보처리방침":
                if let privacyPolicyNotionUrl = URL(string: "https://ryuwon-project.notion.site/6c6aeeaae9a649368f3eb49260646ac4") {
                    let ppNotionSafariView = SFSafariViewController(url: privacyPolicyNotionUrl)
                    present(ppNotionSafariView, animated: true, completion: nil)
                }
                break
            case "오픈소스 라이선스":
                if let openSourceNotionUrl = URL(string: "https://ryuwon-project.notion.site/5e0f53a76d1e4907a99de0694296abcf") {
                    let opNotionSafariView = SFSafariViewController(url: openSourceNotionUrl)
                    present(opNotionSafariView, animated: true, completion: nil)
                }
                break
            default:
                break
            }
        case .appVersion:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
}
