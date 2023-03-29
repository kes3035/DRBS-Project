//
//  SettingCellTableViewCell.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/21.
//

import UIKit

protocol SaveDelegate: AnyObject { func saveData() }

class SettingCellTableViewCell: UITableViewCell {

    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var insertNameTextField: UITextField!
    @IBOutlet weak var insertRateTextField: UITextField!
    
    
    func roundCell() {
            insertNameTextField.layer.cornerRadius = 50
            insertRateTextField.layer.cornerRadius = 50
        
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
        UserDefaults.standard.set(insertNameTextField, forKey: "text")
    }
}
