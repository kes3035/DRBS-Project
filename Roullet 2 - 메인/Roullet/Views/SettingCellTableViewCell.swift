//
//  SettingCellTableViewCell.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/21.
//

import UIKit

protocol SaveDelegate: AnyObject { func saveData() }

class SettingCellTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var insertNameTextField: UITextField!
    @IBOutlet weak var insertRateTextField: UITextField!
    
    var textFieldValue: String?
    
    weak var savedelegate: SaveDelegate?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldValue = textField.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}



extension SettingCellTableViewCell: SaveDelegate {
    func saveData() {
        if let text = insertNameTextField.text {
            UserDefaults.standard.set(text, forKey: "text")
                print("saved: \(text)")
        }
    }
}

