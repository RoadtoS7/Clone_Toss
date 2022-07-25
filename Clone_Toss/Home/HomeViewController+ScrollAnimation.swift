//
//  HomeViewController+ScrollAnimation.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/15.
//

import UIKit
import Combine


extension HomeViewController {
    func detectScroll() {
        collectionView.contentOffsetPublisher
            .sink { [weak self] contentOffset in
                guard let self = self else { return }
                let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
                let header = self.collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath)
                
                guard let headerBottomY = header?.frame.maxY,
                      self.bottomExpenseViewHeight != .zero
                else { return }
                
                let scrolledPosition = contentOffset.y + self.collectionViewHeight - self.bottomExpenseViewHeight - Constants.interSectionSpacing
                let isHidden =  scrolledPosition >= headerBottomY
                guard isHidden != self.isExpenseViewHidden else { return }
                self.animateExpenseBottomView(toHidden: isHidden)
            }.store(in: &cancellableBag)
    }
    
    
    func animateExpenseBottomView(toHidden: Bool) {
        self.isExpenseViewHidden = toHidden
        
        let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
        guard let cell = collectionView.cellForItem(at: indexPath),
              let button: UIButton =  cell.subviews.filter({ $0 is UIButton }).first as? UIButton
        else { return }
        
        let buttonOrigin = cell.convert(button.frame.origin, to: collectionView)
        let bottomViewButton = bottomExpenseView!.button
        let bototmViewButtonOrigin = bottomExpenseView!.convert(bottomViewButton.frame.origin, to: collectionView)
        
        if toHidden {
            let mockButton = ShowDetailButton(frame: .init(origin: bototmViewButtonOrigin, size: bottomViewButton.frame.size))
            self.collectionView.addSubview(mockButton)
            self.collectionView.layoutIfNeeded()
            
            self.bottomExpenseView?.isHidden = true
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.tabBarController?.tabBar.layer.cornerRadius = 20
                self.tabBarController?.tabBar.layer.borderWidth = TabBarController.Constants.tabBarBorderWidth
                self.expenseBackgroundWidthConstraint?.constant = self.view.bounds.width - Constants.margin
                 * 2
                
                self.bottomExpenseView?.clipsToBounds = true
                self.bottomExpenseView?.layer.borderWidth = 0.5
                self.bottomExpenseView?.layer.cornerRadius = Constants.cornerRaidus
                self.bottomExpenseView?.layer.borderColor = UIColor.lightGray.cgColor
                
                mockButton.frame.origin = buttonOrigin
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                mockButton.removeFromSuperview()
            }
        }
        else {
            let mockButton = ShowDetailButton(frame: .init(origin: buttonOrigin, size: button.frame.size))
            self.collectionView.addSubview(mockButton)
            self.collectionView.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.tabBarController?.tabBar.layer.cornerRadius = 0
                self.tabBarController?.tabBar.layer.borderWidth = 0

                self.expenseBackgroundWidthConstraint?.constant = self.view.bounds.width
                
                mockButton.frame.origin = bototmViewButtonOrigin
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.bottomExpenseView?.isHidden = false
                mockButton.removeFromSuperview()
            }
        }
        
    }
}

