
import UIKit

struct Expense: Codable, Equatable {
    
    var cost: String
    var category: String //Category
    var expenseText: String
    var memo: String
    var date: String
    var doDictionary: [String : Any] {
        let dict: [String : Any] = ["cost" : cost,
                                    "category" : category,
                                    "expenseText" : expenseText,
                                    "memo" : memo,
                                    "date" : date]
        return dict
    }
    static var id: Int = 0
    init(cost: String, category: String, expenseText: String, memo: String, date: String) {
        self.cost = cost
        self.category = category
        self.expenseText = expenseText
        self.memo = memo
        self.date = date
        Self.id += 1
    }
}


