

import UIKit

import Then
import SnapKit
import AVFoundation

protocol ProfileImageCellDelegate: AnyObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didTapProfileImage(in cell: ProfileImageTableViewCell)
    func didTapCapturePhoto(in cell: ProfileImageTableViewCell)
    func showAlertGoToSetting(in cell: ProfileImageTableViewCell)
    func openImagePicker(in cell: ProfileImageTableViewCell)
}

class ProfileImageTableViewCell: UITableViewCell, UIContextMenuInteractionDelegate {
    
    weak var delegate: ProfileImageCellDelegate?
    
    static let id = "ProfileImageCell"
    
    // MARK: - Properties
    
    lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profile_image_placeholder")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 75
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.isUserInteractionEnabled = true
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        $0.addInteraction(contextMenuInteraction)
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - Method & Action
    
    private func setupCell() {
        contentView.addSubview(profileImageView)

        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.height.equalTo(150)
        }

        contentView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.width.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.top).offset(-16)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(16)
        }
    }

    func setImage(_ image: UIImage) {
        profileImageView.image = image
    }
    
    func configure(with model: ProfileImageModel) {
        if let image = model.image {
            self.setImage(image)
        }
    }
    
    @objc private func didTapProfileImageView() {
        delegate?.didTapProfileImage(in: self)
    }

    @objc private func capturePhoto() {
        delegate?.didTapCapturePhoto(in: self)
    }
    
    // MARK: - UIContextMenuInteractionDelegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        print("contextMenuInteraction called")
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let photoLibraryAction = UIAction(title: "사진 보관함", image: UIImage(systemName: "photo")) { _ in
                self.delegate?.didTapProfileImage(in: self)
            }
            
            let capturePhotoAction = UIAction(title: "사진 찍기", image: UIImage(systemName: "camera")) { _ in
                self.openCamera()
            }
            
            return UIMenu(title: "", children: [photoLibraryAction, capturePhotoAction])
        }
    }

    @objc private func openCamera() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard let self = self else { return }
            if isAuthorized {
                DispatchQueue.main.async {
                    self.delegate?.openImagePicker(in: self)
                }
            } else {
                self.delegate?.showAlertGoToSetting(in: self)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        self.profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
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
