//
//  ViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit
import CoreGraphics

class TabBarController: UITabBarController {
    let expenseView: ExpenseBottomView = {
        let view = ExpenseBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var expenseViewMinWidth: CGFloat { expenseView.frame.width - 15 * 2 }
    
    let splitLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()

    let embededViewControlleres = [HomeViewController(),
                           ViewController()]
    
    
    // test
    var showCount = 0
    var closeCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.zPosition = 999
        
        view.addSubview(expenseView)
        expenseView.addSubview(splitLine)

        self.navigationItem.prompt = "UITabBarController"
        self.viewControllers = embededViewControlleres
        embededViewControlleres.forEach { self.addChild($0) }
        
        NSLayoutConstraint.activate([
            expenseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseView.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor, constant: 50),
            expenseView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            splitLine.centerXAnchor.constraint(equalTo: expenseView.centerXAnchor),
            splitLine.bottomAnchor.constraint(equalTo: expenseView.topAnchor, constant: -5),
            splitLine.widthAnchor.constraint(equalTo: expenseView.widthAnchor, constant: -30),
            splitLine.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        
        
        /// show
        tabBar.layer.borderColor = UIColor.white.cgColor
        
   
    }

    func showExpenseView() {
        if expenseView.isHidden == false  { return }
        tabBar.layer.borderColor = UIColor.white.cgColor
        
        // transitioningView 생성
        let transitioningView = transitioningView()
        view.addSubview(transitioningView)
  
        
        let widthConstraint = transitioningView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30)
        NSLayoutConstraint.activate([
            transitioningView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthConstraint,
            transitioningView.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor, constant: 50),
            transitioningView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            widthConstraint.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.expenseView.isHidden = false
            self.splitLine.isHidden = false
            transitioningView.removeFromSuperview()
        }
        
        showCount += 1
        print("showCount: \(showCount)")
    }
    
    func transitioningView() -> UIView {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topBoarder = CALayer()
        let borderHeight: CGFloat = 2
        topBoarder.borderWidth = borderHeight
        topBoarder.borderColor = UIColor.lightGray.cgColor
        topBoarder.frame = CGRect(x: .zero, y: -1, width: view.bounds.width, height: borderHeight)
        view.layer.addSublayer(topBoarder)
        
        return view
    }
    
    
    func createTransitioninView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        let topBoarder = CALayer()
        let borderHeight: CGFloat = 2
        
        topBoarder.borderWidth = borderHeight
        topBoarder.borderColor = UIColor.lightGray.cgColor
        topBoarder.frame = CGRect(x: 0, y: -1, width: view.frame.width, height: borderHeight)
        view.layer.addSublayer(topBoarder)
        
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }
    
    func closeExpenseView() {
        // tabbar 조정
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.clipsToBounds = true
        
        if expenseView.isHidden { return }
        
        // dismiss 애니메이션 뷰
        let dismissingView = dismissingView()
        view.addSubview(dismissingView)
        
        let widthConstraint = dismissingView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            dismissingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dismissingView.heightAnchor.constraint(equalTo: self.expenseView.heightAnchor),
            widthConstraint
        ])
    
        view.layoutIfNeeded()
        
        // 기존 뷰 사라짐
        expenseView.isHidden = true
        splitLine.isHidden = true
       
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            widthConstraint.constant = self.expenseView.frame.width - 30
            self.view.layoutIfNeeded()
        } completion: { _ in
            dismissingView.removeFromSuperview()
        }
        
        closeCount += 1
        print("closeCount: \(closeCount)")
    }
    
    private func dismissingView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }
}

