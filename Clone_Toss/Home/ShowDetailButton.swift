//
//  ShowDetailButton.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/17.
//

import UIKit

class ShowDetailButton: UIButton {
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("내역", for: .normal)
        backgroundColor = .white
        
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
        
        configuration = buttonConfig
    }
}
