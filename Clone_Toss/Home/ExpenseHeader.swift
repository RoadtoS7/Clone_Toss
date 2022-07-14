//
//  ExpenseHeader.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/13.
//

import UIKit

class ExpenseHeader: UICollectionReusableView {
    static let elementKind = "expense-supplementary-reuse-identifier"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ExpenseHeader {
    private func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(100), for: .horizontal)
        
        
        self.addSubview(label)

        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
