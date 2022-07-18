//
//  UIColor + Extension.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/18.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static var toss: UIColor {
        .init(hex: 0xE3F2Fd)
    }
}
