//
//  Promotion.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/12.
//

import Foundation

struct Promotion: Identifiable {
    let id: String = UUID().uuidString
    let category: String
    let title: String
    let imageName: String?
    
    static let value: [Promotion] = [
        .init(category: "52개 금융사", title: "대출 한도 조회", imageName: "bag.fill"),
        .init(category: "최근", title: "만보기", imageName: "heart.circle"),
        .init(category: "자주", title: "돈 같이 모으기", imageName: "dollarsign.circle"),
        .init(category: "인기", title: "더보기", imageName: nil)
    ]
}
