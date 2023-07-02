//
//  MainCell.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/22.
//

import UIKit

class MainCell: UITableViewCell {
    //MARK: - Properties
    let backgroundUIView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.cornerRadius = 8
        return view
    }()

    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        self.addSubview(backgroundUIView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            backgroundUIView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backgroundUIView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            backgroundUIView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            backgroundUIView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            
        ])
    }
    
    //MARK: - Actions


}
