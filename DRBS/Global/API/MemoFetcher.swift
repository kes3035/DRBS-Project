//
//  MemoFetcher.swift
//  DRBS
//
//  Created by 김은상 on 2023/07/03.
//

import UIKit
import FirebaseDatabase

struct MemoFetcher {
    //서버에서 가져와야할 데이터를 어떻게 다룰 것인가
    /*
     현재 저장되는 구조
     메모 {
        "2023-07-04" {
                "메모1" {
                    "비용" : "10000원"
                    "지출내역" : "스타벅스"
                    "카테고리" : "식비"
                    "메모" : "프리퀀시 적립 완료"
                    "날짜" : "2023-07-04"
                {
        }
     }
     
     ref.child("메모").oberveSingleEvent(of: .value) { snapshot in
     //이렇게 해서 스냅샷을 찍어오고,
        if snapshot.exist() {
        snapshot이 존재하면,
        
        guard let snapData = snapshot.value as? [String:[String:**Any**]] else { return }
        스냅샷 데이터를 타입캐스팅 해준다. 이 때 Any타입은 추후에 JSONParsing을 통해 Expense 타입으로 만들어줄 타입
        위 JSON 에서 "비용" : "10000" 에 해당하는 부분
     
        let jsonData = try! JSONSerialization.data(withSJONObject:  , options: [])
        JSONSerialization을 통해 JSON 데이터를 디코딩하기 위한 작업
            do {
            알맞은 포맷으로 성공하면,
            let decoder = JSONDecoder()
            let memoList = try decoder.decode([Expense].self, from: jsonData)
            completion(memoList)
            } catch let error {
            실패하면,
                print("\(error.localizedDescription)"
            }
        }
     }
     */
    
    
    
    static func memoFetcher(completion: @escaping([Expense]) -> Void) {
        let ref = Database.database().reference().child("메모")
//        ref.observeSingleEvent(of: .value) { snapshot,arg in
//            if snapshot.exists() {
//                guard let snapData = snapshot.value as? [String:[String:Any]] else {return}
//                print("\(snapData.values)")
//                for date in snapData.keys {
//                    let jsonData = try! JSONSerialization.data(withJSONObject: Array(arrayLiteral: snapData.values[date]["memo\(Expense.id)"]) , options: [])
//                    do {
//                        let decoder = JSONDecoder()
//                        let memoList = try decoder.decode([Expense].self, from: jsonData)
//                        print("\(memoList)")
//                        completion(memoList)
//                    } catch let error {
//                        print("\(error.localizedDescription) + okay?")
//                    }
//                }
//
//            }
//        }
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
