//
//  MemoFetcher.swift
//  DRBS
//
//  Created by 김은상 on 2023/07/03.
//

import UIKit
import FirebaseDatabase

class MemoFetcher {
    //MARK: - Properties
    static let shared = MemoFetcher()
    let ref = Database.database().reference().child("메모")
    var expenses: [Expense] = []
    private init() {}
    
    
    
    //MARK: - Helpers
    func memoFetcher(completion: @escaping([Expense]) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                guard let value = snapshot.value as? [String: Any] else { return }
                print("디버깅 : value = \(value)")
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dataDecodingStrategy = .base64
                    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "Infinity", negativeInfinity: "-Infinity", nan: "NaN")
                    
                    let expenses = try decoder.decode([String: Expense].self, from: data)
                    let expenseArray = Array(expenses.values)
                    self.expenses = expenseArray
                    completion(expenseArray)
//                    print("디버깅: yourData = \(expenseArray)")
                } catch let error {
                    print("\(error.localizedDescription)")
                }
                
                
            }
        }
    }
        
    
//    private func andDataExist(value: [String:Any]) -> [Expense] {
//        let data = try! JSONSerialization.data(withJSONObject: Array(value.values), options: [])
//        let decoder = JSONDecoder()
//        let memoList = try? decoder.decode([Expense].self, from: data)
//        do {
//            guard let memolist = memoList else {
//                print("디버깅: andDataExist()에서 에러")
//                return []}
//            return memolist
//        }
//    }
    func memoAdded(completion: @escaping([Expense]) -> Void) {
        ref.observe(.childAdded) { snapshot,arg in
            guard let value = snapshot.value as? [String: Any] else {
                print("디버깅: 브레이크 포인트1")
                return }
            print("\(value)~~")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let decoder = JSONDecoder()
                let expense = try decoder.decode(Expense.self, from: jsonData)
                
                // Use the decoded 'expense' object as needed
                print(expense)
                self.expenses.append(expense)
                completion(self.expenses)
            } catch let error {
                print("\(error.localizedDescription)")
                print("디버깅: 브레이크 포인트2")
            }
        }
    }
}

//서버에서 가져와야할 데이터를 어떻게 다룰 것인가
/*
 현재 저장되는 구조
 메모 {
    "메모1" {
        "비용" : "10000원"
        "지출내역" : "스타벅스"
        "카테고리" : "식비"
        "메모" : "프리퀀시 적립 완료"
        "날짜" : "2023-07-04"
    {
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
