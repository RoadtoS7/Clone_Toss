//
//  HomeViewController+ScrollAnimation.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/15.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate {
    private var 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
        guard let header = collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath) else { return }

        let tabBarHeight = tabBar?.frame.height ?? .zero
        let scrollViewHeight = scrollView.frame.height
        let contentOffSet = scrollView.contentOffset.y
        let bottomViewHeight = expenseBottomView.frame.height
        let headerPosition = header.frame.origin
        
    
        if contentOffSet + scrollViewHeight - tabBarHeight - bottomViewHeight <= headerPosition.y {
            print("up detect")
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO
        
    }
}
