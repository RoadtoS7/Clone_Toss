//
//  SectionBackgroundView.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/17.
//

import UIKit

class SectionBackgroundView: UICollectionReusableView {
    static var reuseIndetifier: String  = "SectionBackgroundView"
    
    private var insetView: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemFill
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        self.addSubview(insetView)
        
        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            trailingAnchor.constraint(equalTo: insetView.trailingAnchor, constant: 15),
            insetView.topAnchor.constraint(equalTo: topAnchor),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
