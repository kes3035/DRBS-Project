

import UIKit

import Then
import SnapKit

class PhoneNumebrTableViewCell: UITableViewCell {
    
    static let id = "PhoneNumberCell"
    
    // MARK: - Properties

    private lazy var phoneNumber = UILabel().then {
        $0.textColor = .systemGray3
        $0.numberOfLines = 0
    }

    private let rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .lightGray
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(phoneNumber)
        contentView.addSubview(rightButton)
        contentView.addSubview(separatorView)

        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    // MARK: - Configure
    
    private func setupLayout() {
        phoneNumber.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(20)
            $0.centerY.equalTo(contentView)
        }

        rightButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).offset(-20)
            $0.centerY.equalTo(contentView)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(1)
        }
    }
    
    func configure(with model: PhoneNumberModel) {
        if let number = model.phoneNumber, !number.isEmpty {
            phoneNumber.text = format(phoneNumber: number)
        } else {
            phoneNumber.text = "휴대폰 번호를 설정해주세요"
        }
    }

    private func format(phoneNumber: String) -> String {
        // 여기다가 핸드폰번호 Formatting 로직 구현해야함.
        return "•••-••••-••••"
    }

}
