//
//  ViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit

class TabBarController: UITabBarController {
    let tabViewController = [HomeViewController(),
                             ViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.prompt = "UITabBarController"
        self.setViewControllers(tabViewController, animated: false)
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.borderWidth = 1
        self.tabBar.clipsToBounds = true
    }
}

