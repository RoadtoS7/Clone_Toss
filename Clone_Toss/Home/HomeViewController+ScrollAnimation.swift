//
//  HomeViewController+ScrollAnimation.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/15.
//

import UIKit
import Combine

class ScaleCalculator {
    static func xScaleFactor(initialFrame: CGRect, finalFrame: CGRect, presenting: Bool) -> CGFloat {
        presenting ?
        initialFrame.width / finalFrame.width :
        finalFrame.width / initialFrame.width
    }

    static func yScaleFactor(initialFrame: CGRect, finalFrame: CGRect, presenting: Bool) -> CGFloat {
        presenting ?
          initialFrame.height / finalFrame.height :
          finalFrame.height / initialFrame.height
    }
}

extension HomeViewController {
    func detectScroll() {
        let isDownScroll = collectionView.contentOffsetPublisher
        // (beforebefore, before)
            .scan((CGFloat.zero, CGFloat.zero), { prev, contentOffset in
                let y = contentOffset.y
                let beforeY = prev.1
                return (beforeY, y)
            }).flatMap({ beforeY, y in
                Just(beforeY < y)
            })
        
        collectionView.contentOffsetPublisher
            .zip(isDownScroll)
            .filter({ (_, isDownScroll) in isDownScroll })
            .filter { [weak self] offset, isDownScroll in
                // MARK: expense background에 닿았는지 체크한다.
                let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
                let header = self?.collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath)
                let headerOrigin = header?.frame.origin ?? .zero
                
                let collectionViewHeight = self?.collectionView.frame.height ?? .zero
                
                let scrolledLength = offset.y + collectionViewHeight - (self?.bottomExpenseViewHeight ?? .zero)
                return scrolledLength >= headerOrigin.y
            }.sink { _ in
                self.closeExpenseBottomView()
            }.store(in: &cancellableBag)
        
        collectionView.contentOffsetPublisher
            .zip(isDownScroll)
            .filter({ (_, isDownScroll) in isDownScroll == false })
            .filter { [weak self] offset, isDownScroll in
                // MARK: expense background에 닿았는지 체크한다.
                let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
                let header = self?.collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath)
                let headerOrigin = header?.frame.origin ?? .zero
                
                let collectionViewHeight = self?.collectionView.frame.height ?? .zero
                
                let scrolledLength = offset.y + collectionViewHeight - (self?.bottomExpenseViewHeight ?? .zero)
                return scrolledLength <= headerOrigin.y
            }.sink { _ in
                self.showExpenseBottomView()
            }.store(in: &cancellableBag)
            
//        collectionView.contentOffsetPublisher
//            .zip(isDownScroll)
//            .flatMap({  [weak self] (offset, isDownScroll) -> AnyPublisher<Bool, Never> in
//                // MARK: expense background에 닿았는지 체크한다.
//                let indexPath = IndexPath(row: 0, section: SectionKind.expense.rawValue)
//                let header = self?.collectionView.supplementaryView(forElementKind: ExpenseHeader.elementKind, at: indexPath)
//                let headerOrigin = header?.frame.origin ?? .zero
//
//                let collectionViewHeight = self?.collectionView.frame.height ?? .zero
//
//                let scrolledLength = offset.y + collectionViewHeight - (self?.bottomExpenseViewHeight ?? .zero)
//
//
//                // MARK: Scroll Down
//                if isDownScroll {
//                    if scrolledLength >= headerOrigin.y {
//                        return Just(isDownScroll).eraseToAnyPublisher()
//                    }
//                }
//
//
//                // MARK: Scroll Up
//                if isDownScroll == false {
//                    if scrolledLength <= headerOrigin.y {
//                        return Just(isDownScroll).eraseToAnyPublisher()
//                    }
//                }
//                return Empty().eraseToAnyPublisher()
//            })
//            .sink { isDownScroll in
//                print("isDownScroll: \(isDownScroll)")
//                if isDownScroll {
//                    self.closeExpenseBottomView()
//                    return
//                }
//                self.showExpenseBottomView()
//            }.store(in: &cancellableBag)
    }
}
