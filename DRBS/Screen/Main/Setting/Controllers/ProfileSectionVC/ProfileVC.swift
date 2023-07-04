

import UIKit

import Then
import SnapKit
import AVFoundation

class ProfileVC: UIViewController, ProfileImageCellDelegate {
    
    func openImagePicker(in cell: ProfileImageTableViewCell) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        self.present(pickerController, animated: true)
    }

    
    
    // MARK: - Properties
    
    private let profileTableView = UITableView().then {
        $0.register(ProfileImageTableViewCell.self, forCellReuseIdentifier: ProfileImageTableViewCell.id)
        $0.register(LoginRouteTableViewCell.self, forCellReuseIdentifier: LoginRouteTableViewCell.id)
        $0.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.id)
        $0.register(NickNameTableViewCell.self, forCellReuseIdentifier: NickNameTableViewCell.id)
        $0.register(PhoneNumebrTableViewCell.self, forCellReuseIdentifier: PhoneNumebrTableViewCell.id)
        $0.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.id)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    var middleButton: UIButton?
    
    var dataSource = [ProfileSection]()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNav()
        setupLayout()
        setupData()
        
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        if let tabBarController = self.tabBarController as? TabbarVC {
            for subview in tabBarController.view.subviews {
                if let button = subview as? UIButton, button.currentTitle == "D" {
                    self.middleButton = button
                    break
                }
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 탭바 숨기기
        self.tabBarController?.tabBar.isHidden = true
        self.middleButton?.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 페이지가 사라질 때 탭바와 중간 버튼 다시 보이게 하기
        self.tabBarController?.tabBar.isHidden = false
        self.middleButton?.isHidden = false
    }
    
    
    
    // MARK: - Navigation Bar
    
    private func configureNav() {
        navigationItem.title = "프로필 설정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
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
    
    @objc private func saveButtonTapped() {
        
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        view.addSubview(profileTableView)
        profileTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
        
    }
    
    
    // MARK: - Setup Data
    
    private func setupData() {
        dataSource = [
            .profileImage([ProfileImageModel(image: UIImage(named: "defaultImage"))]),
            .loginRoute([LoginRouteModel(loginIcon: UIImage(named: "icon"), email: "example@example.com")]),
            .name([NameModel(name: "")]),
            .nickName([NickNameModel(nickName: "")]),
            .phoneNumber([PhoneNumberModel(phoneNumber: "")]),
            .address([AddressModel(address: "")])
        ]
    }
    
    
    
    // MARK: - Method & Action
    
    func didTapProfileImage(in cell: ProfileImageTableViewCell) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func didTapProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func didTapCapturePhoto(in cell: ProfileImageTableViewCell) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard isAuthorized else {
                self?.showAlertGoToSetting(in: cell)
                return
            }
            
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.sourceType = .camera
                pickerController.delegate = self
                self?.present(pickerController, animated: true)
            }
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        })
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = .identity
        })
    }

    
    // MARK: - 카메라 접근 권한을 확인하고 설정으로 이동하는 기능
    
    func showAlertGoToSetting(in cell: ProfileImageTableViewCell) {
        let alertController = UIAlertController(
            title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            message: "설정 > DRBS 탭에서 접근을 활성화 할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let goToSettingAlert = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default) { _ in
                guard
                    let settingURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingURL)
                else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    
}








// MARK: - Extension ImagePickerController

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileImageTableViewCell {
                cell.setImage(pickedImage)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.dataSource.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch dataSource[section] {
            case .profileImage(let models):
                return models.count
            case .loginRoute(let models):
                return models.count
            case .name(let models):
                return models.count
            case .nickName(let models):
                return models.count
            case .phoneNumber(let models):
                return models.count
            case .address(let models):
                return models.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section] {
            case .profileImage(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.id, for: indexPath) as! ProfileImageTableViewCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.configure(with: models[indexPath.row])
                return cell
            case .loginRoute(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: LoginRouteTableViewCell.id, for: indexPath) as! LoginRouteTableViewCell
                cell.selectionStyle = .none
                cell.configure(with: models[indexPath.row])
                return cell
            case .name(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: NameTableViewCell.id, for: indexPath) as! NameTableViewCell
                cell.selectionStyle = .none
                cell.configure(with: models[indexPath.row])
                return cell
            case .nickName(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: NickNameTableViewCell.id, for: indexPath) as! NickNameTableViewCell
                cell.selectionStyle = .none
                cell.configure(with: models[indexPath.row])
                return cell
            case .phoneNumber(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumebrTableViewCell.id, for: indexPath) as! PhoneNumebrTableViewCell
                cell.selectionStyle = .none
                cell.configure(with: models[indexPath.row])
                return cell
            default:
                return UITableViewCell()
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        
        switch dataSource[section] {
            case .loginRoute(_):
                titleLabel.text = "이메일"
                titleLabel.textColor = .lightGray
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                headerView.backgroundColor = UIColor.clear
            case .name(_):
                titleLabel.text = "이름"
                titleLabel.textColor = .lightGray
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                headerView.backgroundColor = UIColor.clear
            case .nickName(_):
                titleLabel.text = "닉네임"
                titleLabel.textColor = .lightGray
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                headerView.backgroundColor = UIColor.clear
            case .phoneNumber(_):
                titleLabel.text = "휴대폰 번호"
                titleLabel.textColor = .lightGray
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                headerView.backgroundColor = UIColor.clear
            case .address(_):
                titleLabel.text = "주소"
                titleLabel.textColor = .lightGray
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                headerView.backgroundColor = UIColor.clear
            default:
                return nil
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath.section] {
        case .phoneNumber(_):
            let phoneNumberVC = PhoneNumberVC()
            navigationController?.pushViewController(phoneNumberVC, animated: true)
        case .address(_):
            let addressVC = AddressVC()
            navigationController?.pushViewController(addressVC, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource[section] {
            case .loginRoute(_), .name(_), .nickName(_), .phoneNumber(_), .address(_):
                return 30 // 원하는 높이
            default:
                return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.section] {
            case .profileImage(_):
                return 182 // 이미지뷰의 높이 + 상하 패딩
            default:
                return UITableView.automaticDimension
        }
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}
