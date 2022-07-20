//
//  ViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit

class TabBarController: UITabBarController {
    let expenseView: ExpenseBottomView = {
        let view = ExpenseBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let splitLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(expenseView)
        view.addSubview(splitLine)

        self.navigationItem.prompt = "UITabBarController"
        self.viewControllers = [HomeViewController(tabBarHeight: self.tabBar.frame.height),
                                ViewController()]
        
        NSLayoutConstraint.activate([
            expenseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseView.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor, constant: 100),
            
            splitLine.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            splitLine.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -5),
            splitLine.widthAnchor.constraint(equalTo: tabBar.widthAnchor, constant: -50),
            splitLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.closeExpenseView()
    }
    
    func showExpenseView() {
        expenseView.isHidden = false
        splitLine.isHidden = false
        self.tabBar.layer.borderColor = UIColor.white.cgColor
    }
    
    func closeExpenseView() {
        expenseView.isHidden = true
        splitLine.isHidden = true

        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.clipsToBounds = true
    }
}

