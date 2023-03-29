//
//  SettingViewController.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/20.
//

import UIKit



class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
//    var textFieldManager = TextFieldMannager()
    

    
    let MyModel = "떡볶이"
    let cellName: String = "settingCell"
    var cellColor : Array<String> = ["blue.png", "red.png", "yellow.png", "brown.png", "black.png", "darkgray.png", "orange.png", "purple.png"]
    
    weak var savedelegate: SaveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    //MARK: 추가하는 버튼(+)
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if cellColor.count < 8 {
            cellColor.append("cell\(cellColor.count)")
            tableView.reloadData()
            
        }

    }
    
    //MARK: 지우는 버튼(-)
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: 저장버튼
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        savedelegate?.saveData()
        

    }
    
    
    
}



//MARK: 셀에대한 델리게이트, 데이터 소스
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellColor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! SettingCellTableViewCell
        
        settingCell.roundCell()

        
        //MARK: 화면에 이미지가 보이게 하는 코드
        let img = UIImage(named: "\(cellColor[indexPath.row])")
        settingCell.colorImage.image = img
        

        
        return settingCell
    }
    
    //MARK: 셀을 슬라이드하면 셀이 삭제되는 코드
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            cellColor.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}


