//
//  HomeViewController+ScrollAnimation.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/15.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
        guard let header = collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath) else { return }
        let headerPosition = header.frame.origin
        
        let tabBarHeight = tabBar?.frame.height ?? .zero
        let bottomViewHeight = expenseBottomView.frame.height
        let contentOffSet = scrollView.contentOffset.y
        
        
        // 위로
        if contentOffSet + scrollView.frame.height - tabBarHeight - bottomViewHeight <= headerPosition.y {
            print("up detect")
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO
    }
}
