

import UIKit

import Then
import SnapKit

class NotificationTableViewCell: UITableViewCell {
    
    static let id = "NotificationCell"
    
    // MARK: - Properties
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    let toggleSwitch = UISwitch().then {
        $0.onTintColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
    }

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupLayout()
       }

    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - Setup

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        toggleSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

