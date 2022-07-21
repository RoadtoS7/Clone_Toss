//
//  CustomTabBar.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/19.
//

import UIKit


class CustomTabBar: UITabBar {
    enum Tab: Int, CaseIterable {
        case home
        case benefit
        case remit
        case stock
        case allMeny
        
        var title: String {
            switch self {
            case .home:     return "홈"
            case .benefit:  return "혜택"
            case .remit:    return "송금"
            case .stock:    return "주식"
            case .allMeny:  return "전체"
            }
        }
        
        var imageName: String {
            switch self {
            case .home:     return "house.fill"
            case .benefit:  return "diamond.inset.filled"
            case .remit:    return "dollarsign.circle.fill"
            case .stock:    return "diamond.inset.filled"
            case .allMeny:  return "line.3.horizontal.circle"
            }
        }
    }
    
    enum Constant {
        static let tabMargin = 2
        static let tabCount = 5
    }
    
    var expenseBottomView: ExpenseBottomView = {
        let view = ExpenseBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var splitLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()

    var tabItemHeight: CGFloat {
        frame.height
    }
    
    var tabItems: [UITabBarItem]!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(frame: .zero)
        createView()
    }
    
    func showWithExpenseView() {
        expenseBottomView.isHidden = true
    }
    
    func showWithoutExpenseView() {
        expenseBottomView.isHidden = false
    }
    
    var expanedHeight: CGFloat {
        expenseBottomView.frame.height
    }
}

extension CustomTabBar {
    func createView() {
        createTabBar()
        createConstraint()
    }
    
    private func createTabBar() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        tabItems = Tab.allCases.map { tab -> UITabBarItem in
            let image = UIImage(systemName: tab.imageName)
            return UITabBarItem(title: tab.title, image: image, tag: tab.rawValue)
        }
        
        
        items = tabItems
    }
    
    private func createConstraint() {
        NSLayoutConstraint.activate([
            expenseBottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            expenseBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            expenseBottomView.heightAnchor.constraint(equalToConstant: self.frame.height + 10),
            
            splitLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            splitLine.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5),
            splitLine.widthAnchor.constraint(equalToConstant: self.frame.width - 8),
            self.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

