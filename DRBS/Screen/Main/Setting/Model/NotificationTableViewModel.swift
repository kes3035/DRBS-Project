

import UIKit

struct Notification {
    let leftTitle: String
    let rightItem: Bool
}

class NotificationManager {
    static let shared = NotificationManager()
    
    var notifications = [
        Notification(leftTitle: "앱 Push 알림 설정", rightItem: false)
    ]

    
}

