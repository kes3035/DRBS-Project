
import UIKit

struct Expense: Codable, Equatable {
    
    var cost: String
    var category: String //Category
    var expenseText: String
    var memo: String
    var date: String
//    var doDictionary: [String : Any] {
//        let dict: [String : Any] = ["cost" : cost,
//                                    "category" : category,
//                                    "expenseText" : expenseText,
//                                    "memo" : memo,
//                                    "date" : date]
//        return dict
//    }
    var id: String
    init(cost: String, category: String, expenseText: String, memo: String, date: String, id: String) {
        self.cost = cost
        self.category = category
        self.expenseText = expenseText
        self.memo = memo
        self.date = date
        self.id = id
    }
}


