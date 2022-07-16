//
//  CollectionView+Combine.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/15.
//

import UIKit
import Combine

extension UICollectionView {
    var contentOffsetPublisher: AnyPublisher<CGPoint, Never> {
           publisher(for: \.contentOffset)
               .eraseToAnyPublisher()
       }
}
