//
//  ViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.prompt = "UITabBarController"
        self.viewControllers = [HomeViewController(tabBarHeight: self.tabBar.frame.height),
                                ViewController()]
        
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.borderWidth = 1
        self.tabBar.clipsToBounds = true
    }
}

