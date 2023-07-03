import Foundation
import FirebaseDatabase

class FirebaseManager {
    static func add(memo: Expense) {
        let rootRef = Database.database().reference()
        let memosRef = rootRef.child("메모")
    }
}
