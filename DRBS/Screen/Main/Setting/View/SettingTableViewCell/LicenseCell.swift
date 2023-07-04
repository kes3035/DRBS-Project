

import UIKit

import Then
import SnapKit

class LicenseCell: UITableViewCell {
    
    static let id = "LicenseCell"
    
    // MARK: - Properties
    
    private let stackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private let leftTitleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 16)
    }

    private let rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func setupLayout() {
        stackView.addArrangedSubview(leftTitleLabel)
        stackView.addArrangedSubview(rightButton)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
        }
    }

    func prepare(leftTitleText: String?) {
        self.leftTitleLabel.text = leftTitleText
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(leftTitleText: nil)
    }
}

