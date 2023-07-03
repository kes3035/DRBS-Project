

import UIKit

import Then
import SnapKit

class NameTableViewCell: UITableViewCell {
    
    static let id = "NameCell"
    
    // MARK: - Properties
    
    private var textField = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clearButtonMode = .whileEditing
        $0.placeholder = "이름을 입력하세요"
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        contentView.addSubview(separatorView)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    // MARK: - Configure
    
    private func setupLayout() {
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.lessThanOrEqualToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(1)
        }

    }
    
    func configure(with model: NameModel) {
        textField.text = model.name
        textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension NameTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.separatorView.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.separatorView.backgroundColor = .systemGray5
        }
    }
    

}
