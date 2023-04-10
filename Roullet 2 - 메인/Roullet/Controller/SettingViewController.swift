//
//  SettingViewController.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/20.
//

import UIKit

class DataHandler: SaveDelegate {
    
    func saveData() {
        if let text = UserDefaults.standard.string(forKey: "text") {
            print("saved: \(text)")
        }
    }
}



class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    let dataHandler = DataHandler()

    var removeRow: [Int] = []
    let MyModel = "떡볶이"
    let cellName: String = "settingCell"
    
    let defaultColor: [String] = ["cell0.png", "cell1.png", "cell2.png", "cell3.png", "cell4.png", "cell5.png", "cell6.png", "cell7.png"]
    var cellColor : [String] = ["cell0.png", "cell1.png", "cell2.png", "cell3.png", "cell4.png", "cell5.png", "cell6.png", "cell7.png"]
    
    lazy var outhers = cellColor.diffIndices(from: defaultColor)
    
    
    weak var savedelegate: SaveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: 추가하는 버튼(+)
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if cellColor.count < 8 {
            //cellColor.count가 아니라 indexPath.row?를 넣어야할 것 같은데
            cellColor.append("cell\(outhers.first!).png")
//            print("cell\(removeRow).png")

            outhers.remove(at: 0)
            tableView.reloadData()
        }
    }
    
    //MARK: 지우는 버튼(-)
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: 저장버튼
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        var dataToSave = [String]()

            for i in 0..<tableView.numberOfRows(inSection: 0) {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingCellTableViewCell {
                    if let textFieldValue = cell.insertNameTextField.text {
                        dataToSave.append(textFieldValue)
                    }
                }
            }
            UserDefaults.standard.set(dataToSave, forKey: "text")

        dataHandler.saveData()
        
            self.dismiss(animated: true)
        }
    
    
    //저장버튼을 누르지 않았을 때 텍스트필드에 저장된 값이 나타나게 하는 코드
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        // 저장된 데이터를 가져와서 셀의 textField에 표시
//        if let savedData = UserDefaults.standard.array(forKey: "text") as? [String] {
//            for i in 0..<tableView.numberOfRows(inSection: 0) {
//                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingCellTableViewCell {
//                    cell.insertNameTextField.text = savedData[i]
//                }
//            }
//        }
//    }
    
    
}



//MARK: 셀에대한 델리게이트, 데이터 소스
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellColor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! SettingCellTableViewCell
        
        // delegate 설정
        settingCell.savedelegate = dataHandler
        
        // 화면에 이미지가 보이게 하는 코드
        let img = UIImage(named: "\(cellColor[indexPath.row])")
        settingCell.colorImage.image = img
        
        return settingCell
    }
    
    //MARK: 셀을 슬라이드하면 셀이 삭제되는 코드
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            // 삭제할 데이터 소스의 요소 제거
            self.cellColor.remove(at: indexPath.row)
            
            self.removeRow.append(indexPath.row)
//            print("\(indexPath.row)")
            // 셀 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            // 액션 처리 완료를 시스템에 알림
            completion(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "trash4")
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false // 스와이프로 전체 셀을 삭제하지 않고, 액션 버튼만 나오도록 설정
        
        return configuration
    }

}


extension Array where Element: Equatable {
    func diffIndices(from oldArray: [Element]) -> [Int] {
        self.indices.compactMap { index in
            if oldArray.indices.contains(index) {
                if self[index] != oldArray[index] {
                    return index
                }
            } else {
                return index
            }
            return nil
        }
    }
}
