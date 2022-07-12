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
    }
}

