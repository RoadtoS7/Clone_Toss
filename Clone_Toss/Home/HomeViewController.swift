//
//  HomeViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit
import Combine

enum SectionKind: Int, CaseIterable {
    case bank
    case asset
    case expense
    case promotion
    
    var columnCount: Int {
        switch self {
        case .bank, .asset, .expense: return 1
        case .promotion: return 1
        }
    }
}

class HomeViewController: UINavigationController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>
    
    var collectionView: UICollectionView!
    private var dataSource: DataSource!
    var expenseBottomView: ExpenseBottomView!
    
    var doingAnimation = false
    
    let button: ShowDetailButton = {
        let button = ShowDetailButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cancellableBag = Set<AnyCancellable>()
    
    var tabBar: UITabBar? { tabBarController?.tabBar }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"), tag: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        configureDataSource()
        detectScroll()
        
    }
}

// MARK: - View
extension HomeViewController {
    private func createView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = UIColor.toss
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        expenseBottomView = ExpenseBottomView()
        expenseBottomView.translatesAutoresizingMaskIntoConstraints = false
        expenseBottomView.backgroundColor = .white
       
        view.addSubview(collectionView)
        view.addSubview(expenseBottomView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height - 30),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            expenseBottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            expenseBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseBottomView.heightAnchor.constraint(equalToConstant: 50),
            expenseBottomView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

// MARK: - CollectionView.createLayout()
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { return nil }
            let background = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)
            
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .bank:
                section = self.bankSection()
                section.decorationItems = [background]
            
            case .asset:
                section = self.assetSection()
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: AssetHeader.elementKind, alignment: .top)
                section.decorationItems = [background]
                section.boundarySupplementaryItems = [headerItem]
            
            case .expense:
                section = self.expenseSection()
                section.decorationItems = [background]
                
            case .promotion:
                section = self.promotionSection()
            }
            
            
            return section
        }
        layout.register(
                    SectionBackgroundView.self,
                    forDecorationViewOfKind: SectionBackgroundView.reuseIdentifier)
        return layout
    }
    
    private func configureDataSource() {
        let bankCellRegistration = UICollectionView.CellRegistration (handler: bankCellHandler)
        let assetCellRegistration = UICollectionView.CellRegistration(handler: assetCellHandler)
        let assetHeaderRegistration = UICollectionView.SupplementaryRegistration<AssetHeader>(elementKind: AssetHeader.elementKind, handler: assetHeaderHandler)
        
        let expenseHeaderRegistration = UICollectionView.SupplementaryRegistration<ExpenseHeader>(elementKind: ExpenseHeader.elementKind, handler: expenseHeaderHandler)
        let monthExpenseCellRegistration = UICollectionView.CellRegistration(handler: monthCellHandler)
        let cardExpenseCellRegistration = UICollectionView.CellRegistration (handler: cardExpenseCellHandler)
        
        let promotionCellRegistration = UICollectionView.CellRegistration(handler: promotionCellHandler)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let sectionKind = SectionKind(rawValue: indexPath.section)!
            switch sectionKind {
            case .bank:
                return collectionView.dequeueConfiguredReusableCell(using: bankCellRegistration, for: indexPath, item: itemIdentifier)
                
            case .asset:
                return collectionView.dequeueConfiguredReusableCell(using: assetCellRegistration, for: indexPath, item: itemIdentifier)
                
            case .expense:
                return collectionView.dequeueConfiguredReusableCell(using: indexPath.row == .zero
                                                                    ? monthExpenseCellRegistration: cardExpenseCellRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
                
            case .promotion:
                return collectionView.dequeueConfiguredReusableCell(using: promotionCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            if kind == AssetHeader.elementKind {
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: assetHeaderRegistration, for: indexPath)
            }
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: expenseHeaderRegistration, for: indexPath)
        }
        
        var snapShot = SnapShot()
        
        let sectionIds = SectionKind.allCases.map { $0.rawValue }
        snapShot.appendSections(sectionIds)
        
        snapShot.appendItems([Bank.value.id], toSection: 0)
        snapShot.appendItems(Asset.value.map({ $0.id }), toSection: 1)
        snapShot.appendItems(Expense.value.map({ $0.id }), toSection: 2)
        snapShot.appendItems(Promotion.value.map({ $0.id }), toSection: 3)
        
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

