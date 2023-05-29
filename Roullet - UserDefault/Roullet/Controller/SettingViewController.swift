//
//  SettingViewController.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/20.
//

import UIKit

class DataHandler: SaveDelegate {
    func saveRate() {
        if let rate = UserDefaults.standard.string(forKey: "rate") {
            print("saved: \(rate)")
        }
    }
    
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
    
    // 셀컬러의 넣는 배열
    lazy var outhers = cellColor.diffIndices(from: defaultColor)
    
    weak var savedelegate: SaveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //텍스트필드에 유저디폴트에 저장된 데이터를 표시하는 코드
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 저장된 데이터를 가져와서 셀의 textField에 표시
        if let savedData = UserDefaults.standard.array(forKey: "text") as? [String] {
            for i in 0..<tableView.numberOfRows(inSection: 0) {
                if i < savedData.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingCellTableViewCell {
                        cell.insertNameTextField.text = savedData[i]
                    }
                }
            }
        }
        
        if let savedRate = UserDefaults.standard.array(forKey: "rate") as? [String] {
            for i in 0..<tableView.numberOfRows(inSection: 0) {
                if i < savedRate.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingCellTableViewCell {
                        cell.insertRateTextField.text = savedRate[i]
                    }
                }
            }
        }
    }

    
    
    //MARK: 추가하는 버튼(+)
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if cellColor.count < 8 {
            //cllColor.append를 했으면 요소가 추가되니까 다시 지웠다가 생성해도 다시 생겨야 하는거 아닌가? 왜 지우면 다시 없어질까
            cellColor.append("cell\(outhers.first!).png")
            print("cell\(removeRow).png")

            outhers.remove(at: 0)
            tableView.reloadData()
        }
    }
    
    //MARK: 창을 닫는 버튼(X)
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: 저장버튼
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        //음식이름을 userDefault에 저장하는 코드
        var dataToSave = [String]()

            for i in 0..<tableView.numberOfRows(inSection: 0) {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingCellTableViewCell {
                    if let textFieldValue = cell.insertNameTextField.text {
                        dataToSave.append(textFieldValue)
                    }
                }
            }
            UserDefaults.standard.set(dataToSave, forKey: "text")
        
        // 룰렛의 Rate를 몇으로 할지 저장하는 코드
        var dataToSaveRate = [String]()
            
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingCellTableViewCell {
                if let rateFieldValue = cell.insertRateTextField.text {
                    dataToSaveRate.append(rateFieldValue)
                }
            }
        }
        UserDefaults.standard.set(dataToSaveRate, forKey: "rate")

        //커스텀 델리게이트
        dataHandler.saveData()
        dataHandler.saveRate()
        
        //화면을 닫는 코드
        self.dismiss(animated: true)
        }
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
    
    //테이블뷰 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK: 셀을 슬라이드하면 셀이 삭제되는 코드
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            // 삭제할 데이터 소스의 요소 제거
            self.cellColor.remove(at: indexPath.row)
            
            self.removeRow.append(indexPath.row)
            print("\(indexPath.row)")
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
