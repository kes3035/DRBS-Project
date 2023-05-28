//
//  Expense.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/29.
//

import UIKit

struct Expense {
    
    var cost: String
    var category: String //Category
    var expenseText: String
    var memo: String
    
    var doDictionary: [String : Any] {
        let dict: [String : Any] = ["cost" : cost,
                                    "category" : "\(category)",
                                    "expenseText" : expenseText,
                                    "memo" : memo]
        return dict
    }
}


