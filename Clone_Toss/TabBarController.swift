//
//  ViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit
import CoreGraphics

class TabBarController: UITabBarController {
    enum Constants {
        static let tabBarBorderWidth: CGFloat = 0.5
    }
    
    let expenseView: ExpenseBottomView = {
        let view = ExpenseBottomView()
        view.layer.cornerRadius = HomeViewController.Constants.cornerRaidus
        view.clipsToBounds = true
        
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var embededViewControlleres: [UIViewController] {
        [HomeViewController(), ViewController()]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.zPosition = 999
        
        view.addSubview(expenseView)

        self.navigationItem.prompt = "UITabBarController"
        self.viewControllers = embededViewControlleres
        embededViewControlleres.forEach { self.addChild($0) }
        
        NSLayoutConstraint.activate([
            expenseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            expenseView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            expenseView.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor, constant: HomeViewController.Constants.headerHeight),
            expenseView.widthAnchor.constraint(equalTo: tabBar.widthAnchor),
        ])
    }
}

