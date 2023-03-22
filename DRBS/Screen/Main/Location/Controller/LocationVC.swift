//
//  LocationVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/13.
//

import UIKit

class LocationVC: UIViewController {
    //MARK: - Properties
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "지역 설정"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    var address: String? {
        didSet {
            self.addressLabel.text = address
            if addressLabel.text == "지역을 설정하세요!" {
                detailTextField.isHidden = true
                editAdressButton.setTitle("Edit", for: .normal)
            } else {
                detailTextField.isHidden = false
                editAdressButton.setTitle("SAVE", for: .normal)
            }
        }
    }
    
    var addressLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.text = "지역을 설정하세요!"
        label.layer.borderWidth = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .systemGray5
        return label
    }()
    
    private let detailTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상세 주소를 입력해주세요. ex)403호"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00).cgColor
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    private lazy var mapButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        button.setTitle("지도 확인하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var editAdressButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNav()
    }
        
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(mainLabel)
        view.addSubview(addressLabel)
        view.addSubview(editAdressButton)
        view.addSubview(detailTextField)
        detailTextField.isHidden = true
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainLabel.heightAnchor.constraint(equalToConstant: 30)])
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            addressLabel.heightAnchor.constraint(equalToConstant: 40)])
        NSLayoutConstraint.activate([
            detailTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            detailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            detailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            detailTextField.heightAnchor.constraint(equalToConstant: 40)])
//        NSLayoutConstraint.activate([
//            mapButton.topAnchor.constraint(equalTo: detailTextField.bottomAnchor, constant: 30),
//            mapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            mapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//            mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            mapButton.heightAnchor.constraint(equalToConstant: 30)])
        NSLayoutConstraint.activate([
            editAdressButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            editAdressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            editAdressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            editAdressButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
    }
    func configureNav() {
        navigationItem.title = "위치 설정"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    //MARK: - Actions
    @objc func editButtonTapped() {
        if addressLabel.text == "지역을 설정하세요!" {
            let kakaoVC = KakaoZipCodeVC()
//            kakaoVC.modalPresentationStyle = .fullScreen
            //        self.navigationController?.pushViewController(kakaoVC, animated: true)
            self.present(kakaoVC, animated: true)
        } else {
            _ = UIContextualAction(style: .normal, title: "", handler: { _, _, _ in
                let alert = UIAlertController(title: "", message: "저장이 완료되었습니다", preferredStyle: .alert)
                let success = UIAlertAction(title: "확인", style: .default) { success in
                    self.editAdressButton.setTitle("Edit", for: .normal)
                    
                }
                alert.addAction(success)
                self.present(alert, animated: true)
            })
                                            
        }
    }

    @objc func mapButtonTapped() {
        print("디버그: 지도 확인하기 버튼 눌림")
    }
}

