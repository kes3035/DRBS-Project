//
//  MemoFetcher.swift
//  DRBS
//
//  Created by 김은상 on 2023/07/03.
//

import UIKit
import FirebaseDatabase
/*
 메모패쳐는 서버에서 메모와 관련된 통신을 하기 위한 커스텀 클래스
 보통 API관련 커스텀 클래스는 싱글톤 패턴을 채택!
 ref => 파이어베이스 데이터베이스에 접근! .child("")를 통해 하위에 접근
 
 
 func memoFetcher()
 completion을 통해 [Expense] 타입을 바깥으로 던져줄 수 있고,
 ref를 딱 한 번 관찰해서
 만약 스냅샷(사진을 찍어오는 것 = 데이터를 가져오는 것)이 있으면,
 스냅샷의 밸류를 옵셔널 바인딩한 뒤,
 데이터를 JSONDecoder로 디코딩하여 배열화 하고 expenses 배열에 담아서 completion으로 던져줌
 
 print(value)
 print(snapshot) 해보면 어떤 형식인지 알 수 있음!
 
 
childAdded같은 경우엔 자식이 추가될 때마다 트리거되는데,(데이터를 추가할 때)
 [String:Any]타입으로 타입 캐스팅 해서 마찬가지로 json형식을 디코딩해주고 배열에 담아 반환
 
 현재는 TabbarVC에서 childAdded를 통해 데이터를 전달
 왜냐면 앱이 처음 실행될 때, Added도 트리거 됨! 그래서 굳이 memoFetcher를 해주지 않아도 됨!
 
 */



class MemoFetcher {
    //MARK: - Properties
    static let shared = MemoFetcher()
    let ref = Database.database().reference().child("메모")
    var expenses: [Expense] = []
    
    //MARK: - LifeCycle
    private init() {}
    
    //MARK: - Helpers
    func memoFetcher(completion: @escaping([Expense]) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                guard let value = snapshot.value as? [String: Any] else { return }
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
                } catch let error { print("\(error.localizedDescription)") }
            }
        }
    }

    
    
    func memoAdded(completion: @escaping([Expense]) -> Void) {
        ref.observe(.childAdded) { snapshot,arg in
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let decoder = JSONDecoder()
                let expense = try decoder.decode(Expense.self, from: jsonData)
                self.expenses.append(expense)
                completion(self.expenses)
            } catch let error { print("\(error.localizedDescription)") }
        }
    }
    
    func memoUpdated(completion: @escaping([Expense]) -> Void) {
        ref.observe(.childChanged) { snapshot, arg in
            
            
            
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
