//
//  Expense.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/12.
//

import Foundation

struct Asset: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let value: Int
    
    static var value: [Asset] = [
        .init(name: "토스뱅크 통장", value: 100),
        .init(name: "KB 보통예금", value: 1000),
        .init(name: "입출금통장", value: 10000)
    ]
}

struct Expense: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let subtitle: String
    let imageName: String
    let isTotalMenu: Bool
    
    static var value: [Expense] = [
        .init(title: "이번 달 쓴 금액", subtitle: "2,202,040원", imageName: "dollarsign.square", isTotalMenu: true),
        .init(title: "연체 전에 알려드려요.", subtitle: "빠져나갈 카드값 보기", imageName: "creditcard", isTotalMenu: false)
    ]
}
