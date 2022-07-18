//
//  ExpenseBottomView.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/15.
//

import Foundation
import UIKit

class ExpenseBottomView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.text = "소비"
        return label
    }()
    
    let button: ShowDetailButton = {
        let button = ShowDetailButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        self.addSubview(label)
        self.addSubview(button)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20 + 17),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
