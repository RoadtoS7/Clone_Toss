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
        let isDownScroll = collectionView.contentOffsetPublisher
            .scan((CGFloat.zero, CGFloat.zero), { prev, contentOffset in
                let y = contentOffset.y
                let beforeY = prev.1
                return (beforeY, y)
            }).map { (beforeY, y) in
                beforeY < y
            }
        
        
        
        collectionView.contentOffsetPublisher
            .zip(isDownScroll)
            .drop(while: { (_, _) in
                self.doingAnimation
            })
            .sink { [weak self] contentOffset, isDownScroll in
                
                guard let self = self else { return }
                let reachedExpenseHeader = self.reachedExpenseHeader(whileDownScroll: isDownScroll, using: contentOffset)
                
                if reachedExpenseHeader && isDownScroll && self.expenseBottomView.isHidden == false {
                    self.doingAnimation = true
                    let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
                    guard let header = self.collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath) else { return  }
                    guard let expenseHeader = (header as? ExpenseHeader) else { return }
                        
                    let originButton = self.expenseBottomView.button
                    let buttonFrame = self.expenseBottomView.convert(originButton.frame, to: self.collectionView)
                    let button = ShowDetailButton(frame: buttonFrame)
                    let fromLocation = self.expenseBottomView.convert(originButton.frame.origin, to: self.collectionView)
                    button.backgroundColor = .red
                    button.layer.zPosition = 20
                    self.collectionView.addSubview(button)
                    
                    guard let cell = self.collectionView.cellForItem(at: indexPath) else { return }
                    guard let toButton = cell.subviews.filter { $0 is ShowDetailButton }.first else { return }
                    let toLocation = cell.convert(toButton.frame.origin, to: self.collectionView)
                    let yGap = toLocation.y - fromLocation.y
                    
                    self.expenseBottomView.button.isHidden = true
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
                        self.expenseBottomView.alpha = 0
                        let move = CGAffineTransform(translationX: 0, y: yGap)
                        button.frame.origin = toLocation
                    } completion: { isDone in
                        if isDone == false { return }
                        button.isHidden = true
                        self.expenseBottomView.isHidden = true
                        self.doingAnimation = false
                    }
                }
                
                if reachedExpenseHeader && isDownScroll == false && self.expenseBottomView.alpha == .zero {
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
                        self.expenseBottomView.alpha = 1
                    } completion: { isDone in
                        if isDone == false { return }
                        self.expenseBottomView.isHidden = false
                        self.doingAnimation = false
                    }
                }
            }.store(in: &cancellableBag)
    }
    
    private func reachedExpenseHeader(whileDownScroll isDownScroll: Bool, using contentOffset: CGPoint) -> Bool {
        let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
        guard let header = self.collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath) else { return false }
        
        let tabBarHeight = self.tabBar?.frame.height ?? .zero
        let scrollViewHeight = self.collectionView.frame.height
        let bottomViewHeight = self.expenseBottomView.frame.height
        let headerPosition = header.frame.origin
        
        let scrollHeight = contentOffset.y + (scrollViewHeight - tabBarHeight - bottomViewHeight)
        
        if isDownScroll {
            return scrollHeight >= headerPosition.y
        }
        return scrollHeight <= (headerPosition.y + header.frame.height)
    }
}
