//
//  Category.swift
//  DRBS
//
//  Created by 김은상 on 2023/05/01.
//

import Foundation

enum Category: String, Codable {
    case utilityBill = "공과금"
    case food = "식비"
    case etc = "기타소비"
    case all = "전체"
}
