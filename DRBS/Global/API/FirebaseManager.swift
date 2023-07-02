//
//  FirebaseManager.swift
//  DRBS
//
//  Created by 김은상 on 2023/06/23.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    static func add(memo: Expense) {
        let rootRef = Database.database().reference()
        let memosRef = rootRef.child("메모")
    }
}
