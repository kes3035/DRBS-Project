//
//  MemoFetcher.swift
//  DRBS
//
//  Created by 김은상 on 2023/07/03.
//

import UIKit
import FirebaseDatabase

struct MemoFetcher {
    static func memoFetcher(completion: @escaping([String:[Expense]]) -> Void) {
        let ref = Database.database().reference().child("메모")
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                guard let snapData = snapshot.value as? [String:[String:Any]] else {
                    print("받아오기 실패")
                    return }
                print(snapData)
                print("----")
                print(snapshot)
                let jsonData = try! JSONSerialization.data(withJSONObject: Array(snapData.values), options: [])
                do {
                    let decoder = JSONDecoder()
                    let memoList = try decoder.decode([String:[Expense]].self, from: jsonData)
                    completion(memoList)
                } catch let error {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
        
    
    private func andDataExist() {
//        let jsonData = try! JSONSerialization.data(withJSONObject: Array(snapData.values), options: [])
//        let decoder = JSONDecoder()
//        let memoList = try decoder.decode([String:[Expense]].self, from: jsonData)
//
//        do {
//
//            print(jsonData)
//            let memolist = try decoder.decode([Expense].self, from: jsonData)
//            print(self.expenseSnapshot)
//        } catch let error {
//            print("\(error.localizedDescription)")
//        }
    }
    private func andDataDoesntExist() {
        
    }
}
