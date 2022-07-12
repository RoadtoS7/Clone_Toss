//
//  Bank.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/12.
//

import Foundation

struct Bank: Identifiable {
    var id: String = UUID().uuidString
    
    let name: String
    static let value: Bank = .init(name: "토스 뱅크")
}
