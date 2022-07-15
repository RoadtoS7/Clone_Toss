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
        label.text = "소비"
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("내역", for: .normal)
        button.backgroundColor = .white
        
        var buttonConfig = UIButton.Configuration.gray()
        buttonConfig.contentInsets = .init(top: 7, leading: 15, bottom: 9, trailing: 15)
        buttonConfig.titleAlignment = .center
        buttonConfig.cornerStyle = .medium
        buttonConfig.titleTextAttributesTransformer = .init({ attrContainer in
            var attrContainer = attrContainer
            attrContainer.foregroundColor = UIColor.lightGray
            attrContainer.font = UIFont.boldSystemFont(ofSize: 12)
            return attrContainer
        })
        
        button.configuration = buttonConfig
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        self.addSubview(label)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
