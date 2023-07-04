

import UIKit

struct LocationModel {
    let leftTitle: String
    let rightItem: Bool
}

class LocationManager {
    static let shared = LocationManager()
    
    var locations = [
        LocationModel(leftTitle: "위치정보 이용동의 (선택)", rightItem: false)
    ]

    private init() {}
}
