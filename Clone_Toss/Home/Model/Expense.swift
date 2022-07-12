//
//  Expense.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/12.
//

import Foundation

struct Asset {
    let name: String
    let value: Int
    
    static var value: [Asset] = [
        .init(name: "토스뱅크 통장", value: 100),
        .init(name: "KB 보통예금", value: 1000),
        .init(name: "입출금통장", value: 10000)
    ]
}
