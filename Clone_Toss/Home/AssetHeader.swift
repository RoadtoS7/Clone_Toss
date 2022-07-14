//
//  AssetHeader.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/13.
//

import UIKit

class AssetHeader: UICollectionReusableView {
    static let elementKind = "asset-supplementary-reuse-identifier"
    
    let label = UILabel()
    let arrowImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension AssetHeader {
    private func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(100), for: .horizontal)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .lightGray
        
        self.addSubview(label)
        self.addSubview(arrowImageView)

        let inset: CGFloat = 17
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            arrowImageView.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}
