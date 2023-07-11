
import UIKit
import Then
import SnapKit

class ExpenseCell: UITableViewCell {
    //MARK: - Properties
    
    var expense: Expense? {
        didSet {
            self.costLabel.text = commaAdder(price: expense?.cost) + "원"
            self.categoryLabel.text = self.expense?.category
            self.categoryView.backgroundColor = configureBackgroundColor(category: self.expense!.category)
            self.categoryImage.image = Category.categoryImage(category: self.expense!.category)
        }
    }
    
    private lazy var categoryView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var categoryImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .white
        $0.clipsToBounds = true
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private lazy var expenseLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.text = "지출"
    }
    
    private lazy var costLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textAlignment = .left
    }

    private lazy var 스택뷰 = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func 테스트() {
        self.addSubview(스택뷰)
        self.addSubview(categoryView)
        categoryView.addSubview(categoryImage)
//        categoryView.addSubview(categoryLabel)
        스택뷰.addSubviews(categoryLabel ,costLabel)
        
    
        NSLayoutConstraint.activate([
            categoryView.widthAnchor.constraint(equalToConstant: 30),
            categoryView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            categoryView.heightAnchor.constraint(equalToConstant: 30),
            
            categoryImage.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryImage.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor),
            categoryImage.heightAnchor.constraint(equalToConstant: 25),
            categoryImage.widthAnchor.constraint(equalToConstant: 25),
            
            categoryLabel.centerYAnchor.constraint(equalTo: 스택뷰.centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: 70),
            categoryLabel.leadingAnchor.constraint(equalTo: 스택뷰.leadingAnchor),
            
            스택뷰.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            스택뷰.leadingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: 10),
            스택뷰.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            스택뷰.heightAnchor.constraint(equalToConstant: 30),



//            지출내역레이블.centerYAnchor.constraint(equalTo: 스택뷰.centerYAnchor),
//            지출내역레이블.leadingAnchor.constraint(equalTo: 스택뷰.leadingAnchor, constant: 10),
//            지출내역레이블.widthAnchor.constraint(equalToConstant: 50),

            costLabel.centerYAnchor.constraint(equalTo: 스택뷰.centerYAnchor),
            costLabel.trailingAnchor.constraint(equalTo: 스택뷰.trailingAnchor, constant: -10),
            costLabel.widthAnchor.constraint(equalToConstant: 100),
            
            
        ])
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        //configureUI()
        //setupConstraints()
        테스트()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.categoryView.layer.cornerRadius = self.categoryView.frame.height/2

    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    
    
    
    
    
    func configureBackgroundColor(category: String) -> UIColor {
        switch category {
        case Category.all.rawValue :
            return UIColor.black
        case Category.food.rawValue :
            return UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00)
        case Category.utilityBill.rawValue :
            return UIColor(red: 0.61, green: 0.58, blue: 0.82, alpha: 1.00)
        case Category.etc.rawValue :
            return UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00)
        default:
            return UIColor.black
        }
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
