

import UIKit

import Then
import SnapKit

class AddressTableViewCell: UITableViewCell {
    
    static let id = "AddressCell"
    
    // MARK: - Properties
    
    
    
    
    
    
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    // MARK: - override

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Configure
    
    private func setupLayout() {

        
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(1)
        }
    }
    
    func configure(with model: AddressModel) {
        
    }

}
