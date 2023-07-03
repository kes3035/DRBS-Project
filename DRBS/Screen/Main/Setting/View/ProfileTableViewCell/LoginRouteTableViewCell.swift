

import UIKit

import Then
import SnapKit

class LoginRouteTableViewCell: UITableViewCell {

    static let id = "LoginRouteCell"

    // MARK: - Properties

    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private lazy var loginIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit // 이미지 비율 유지
    }

    private lazy var emailLabel = UILabel().then {
        $0.textColor = .lightGray
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    var loginRoute: LoginRouteModel? {
        didSet {
            loginIconImageView.image = loginRoute?.loginIcon
            emailLabel.text = loginRoute?.email
        }
    }

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        contentView.addSubview(separatorView)
        containerView.addSubview(loginIconImageView)
        containerView.addSubview(emailLabel)

        
        setupLayout()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - Setup

    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        loginIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        emailLabel.snp.makeConstraints {
            $0.leading.equalTo(loginIconImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(1)
        }
    }

    
    func configure(with model: LoginRouteModel) {
        loginIconImageView.image = model.loginIcon
        emailLabel.text = model.email
    }


    // MARK: - override

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
