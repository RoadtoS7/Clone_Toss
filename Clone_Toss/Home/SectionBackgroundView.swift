//
//  SectionBackgroundView.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/17.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class SectionBackgroundView: UICollectionReusableView {

    private var insetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemFill
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .toss
        addSubview(insetView)

        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            trailingAnchor.constraint(equalTo: insetView.trailingAnchor, constant: 15),
            insetView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
