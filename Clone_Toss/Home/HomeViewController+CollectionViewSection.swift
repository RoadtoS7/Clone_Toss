//
//  HomeViewController+CollectionViewSection.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/17.
//

import UIKit

extension HomeViewController {
    private func group(in section: SectionKind) -> NSCollectionLayoutGroup {
        let columnCount = section.columnCount
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupHeight = columnCount == 1 ? NSCollectionLayoutDimension.fractionalWidth(0.2) : NSCollectionLayoutDimension.fractionalWidth(0.2)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
        return group
    }
    
    func bankSection() -> NSCollectionLayoutSection {
        let group = group(in: .bank)
        let section = NSCollectionLayoutSection(group: group)
        let background = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing:20)
        section.decorationItems = [background]
        return section
    }
    
    func assetSection() -> NSCollectionLayoutSection {
        let group = group(in: .asset)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 20, trailing:20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: AssetHeader.elementKind, alignment: .topLeading)
        sectionHeader.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func expenseSection() -> NSCollectionLayoutSection {
        let group = group(in: .expense)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing:20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ExpenseHeader.elementKind, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func promotionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}
