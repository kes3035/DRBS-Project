//
//  SideMenuCell.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/11.
//

import UIKit

class SideMenuCell: UITableViewCell {
    //MARK: - Properties
    lazy var iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .lightGray
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
       let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 15
        return sv
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        self.sendSubviewToBack(contentView)
        self.backgroundColor = .white
        self.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)])
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 45),
            iconImageView.heightAnchor.constraint(equalToConstant: 45)])

    }
    
    
    //MARK: - Actions


}
