
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
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    private lazy var costLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textAlignment = .right
    }

    private lazy var costView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func 테스트() {
        categoryImage.contentMode = .scaleAspectFit
        self.addSubviews(costView, categoryView)
        categoryView.addSubview(categoryImage)
        costView.addSubviews(categoryLabel ,costLabel)
        
        categoryView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.centerX.equalTo(categoryView)
            make.centerY.equalTo(categoryView)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        costView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryView).offset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(costView)
            make.width.equalTo(70)
            make.leading.equalTo(costView).offset(30)
        }
        costLabel.snp.makeConstraints { make in
            make.centerY.equalTo(costView)
            make.trailing.equalTo(costView).offset(-10)
            make.width.equalTo(100)
        }
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
