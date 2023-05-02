//
//  ExpenseCell.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/29.
//

import UIKit

class ExpenseCell: UITableViewCell {
    //MARK: - Properties
    private let background: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "지출 금액"
        label.textAlignment = .left
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 20)
        
       return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5,900원"
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    
    
    private lazy var saparateLine: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        view.layer.borderWidth = 3
        return view
    }()
    
    private let breakdownLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "지출 내역"
        label.textAlignment = .left
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let expenses: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "싸이버거 단품 콜라 반숙란 dksmfksmdkfmsdkfmsdkfmsk"
        label.textColor = .black
        label.textAlignment = .right
        label.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        label.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        return label
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    var expense: Expense? {
        didSet {
            self.priceLabel.text = commaAdder(price: expense?.cost)
            self.expenses.text = expense?.memo
            self.background.layer.borderColor = expense?.background.cgColor
            self.saparateLine.backgroundColor = expense?.background
            self.breakdownLabel.textColor = expense?.background
            self.expenseLabel.textColor = expense?.background
        }
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    
    func configureUI() {
        self.addSubview(background)
        priceStack.addArrangedSubview(expenseLabel)
        priceStack.addArrangedSubview(priceLabel)
        background.addSubview(priceStack)
        setLineDot(view: saparateLine, color: UIColor.red)
        background.addSubview(saparateLine)
        background.addSubview(breakdownLabel)
        background.addSubview(expenses)
        expenses.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            priceStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 5),
            priceStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15),
            priceStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -15),
            priceLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            saparateLine.topAnchor.constraint(equalTo: priceStack.bottomAnchor, constant: 0),
            saparateLine.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 0),
            saparateLine.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: 0),
//            saparateLine.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        NSLayoutConstraint.activate([
            breakdownLabel.topAnchor.constraint(equalTo: saparateLine.bottomAnchor, constant: 5),
            breakdownLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15),
            breakdownLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            expenses.topAnchor.constraint(equalTo: saparateLine.bottomAnchor, constant: 5),
            expenses.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -15),
            expenses.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -5),
            expenses.widthAnchor.constraint(equalToConstant: 100),
            expenses.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
    }
    
    func setLineDot(view: UIView, color: UIColor) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: view.bounds).cgPath
        view.layer.addSublayer(borderLayer)
    }
    
    //MARK: - Actions
    func commaAdder(price: String?) -> String {
        let integerPrice = Int(price ?? "0") ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: integerPrice)) ?? "0"
        return formattedNumber
    }

    
    

    
}
