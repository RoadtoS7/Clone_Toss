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
    
    let splitLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }

    init() {
        super.init(frame: .zero)
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExpenseBottomView {
    func createView() {
        self.backgroundColor = .white
        
        self.addSubview(label)
        self.addSubview(button)
        self.addSubview(splitLine)
        
        NSLayoutConstraint.activate([
            // Label
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20 + 17),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.heightAnchor.constraint(equalToConstant: HomeViewController.Constants.headerHeight),
            
            // button
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            // splitLine
            splitLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            splitLine.widthAnchor.constraint(equalTo: widthAnchor, constant: -30),
            splitLine.heightAnchor.constraint(equalToConstant: 0.5),
            splitLine.topAnchor.constraint(equalTo: label.bottomAnchor),
        ])
    }
}
