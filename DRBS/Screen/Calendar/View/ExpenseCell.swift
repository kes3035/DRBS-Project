

import UIKit
import Then

class ExpenseCell: UITableViewCell {
    //MARK: - Properties
    private let background = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.layer.borderWidth = 3
    }
    
    private let expenseLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "지출 금액"
        $0.textAlignment = .left
        $0.textColor = .green
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    private let priceLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "5,900원"
        $0.textAlignment = .right
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    
    
    private lazy var saparateLine = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        view.layer.borderWidth = 3
    }
    
    private let breakdownLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "지출 내역"
        $0.textAlignment = .left
        $0.textColor = .green
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    private let expenses = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 3
        $0.text = "싸이버거 단품 콜라 반숙란 dksmfksmdkfmsdkfmsdkfmsk"
        $0.textColor = .black
        $0.textAlignment = .right
        $0.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        $0.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
    }
    
    private lazy var priceStack = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    var expense: Expense? {
        didSet {
            self.priceLabel.text = commaAdder(price: expense?.cost)
            self.expenses.text = expense?.memo
            self.background.layer.borderColor = configureBackgroundColor(category: self.expense!.category).cgColor
            self.saparateLine.backgroundColor = configureBackgroundColor(category: self.expense!.category)
            self.breakdownLabel.textColor = configureBackgroundColor(category: self.expense!.category)
            self.expenseLabel.textColor = configureBackgroundColor(category: self.expense!.category)
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
    
    func configureBackgroundColor(category: String) -> UIColor {
        switch category {
        case Category.all.rawValue :
            return UIColor.black
        case Category.food.rawValue :
            return UIColor.red
        case Category.utilityBill.rawValue :
            return UIColor(red: 0.61, green: 0.58, blue: 0.82, alpha: 1.00)
        case Category.etc.rawValue :
            return UIColor.green
        default:
            return UIColor.black
        }
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
