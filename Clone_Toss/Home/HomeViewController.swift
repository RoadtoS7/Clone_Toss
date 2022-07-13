//
//  HomeViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit

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

let allData = [[Bank.value]] + [Asset.value] + [Promotion.value]
class HomeViewController: UINavigationController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        self.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierachy()
        configureDataSource()
    }
}

extension HomeViewController {
    private func configureHierachy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { return nil }
            let columns = sectionKind.columnCount
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // 무엇을 기준으로 0.2인가?
            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionKind.columnCount)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing:20)
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        let bankCellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell,
                                                                        indexPath: IndexPath,
                                                                        itemIdentifier: String)  in
            var config = cell.defaultContentConfiguration()
            config.text = Bank.value.name
            config.textProperties.color = .black
            
            cell.contentConfiguration = config
            cell.accessories = [.disclosureIndicator()]
        }
        
        let assetCellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell,
                                                                         indexPath: IndexPath,
                                                                         itemIdentifier: String)  in
            let asset = Asset.value[indexPath.row]
            
            var config = cell.defaultContentConfiguration()
            config.text = asset.name
            config.textProperties.color = .black
            
            config.secondaryText = String(format: "%d원", asset.value)
            
            cell.contentConfiguration = config
            cell.accessories = [.disclosureIndicator()]
        }
        
        let expenseCellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell,
                                                                           indexPath: IndexPath,
                                                                           itemIdentifier: String)  in
            let asset = Asset.value[indexPath.row]
            
            var config = cell.defaultContentConfiguration()
            config.text = asset.name
            config.textProperties.color = .black
            
            config.secondaryText = String(format: "%d원", asset.value)
            
            cell.contentConfiguration = config
            cell.accessories = [.disclosureIndicator()]
        }
        
        let promotionCellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell,
                                                                             indexPath: IndexPath,
                                                                             itemIdentifier: String)  in
            let promotion = Promotion.value[indexPath.row]
            
            var config = cell.defaultContentConfiguration()
            config.text = promotion.category
            config.secondaryText = promotion.title
            
            guard let imageName = promotion.imageName else { return }
            config.image = UIImage(systemName: imageName)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let sectionKind = SectionKind(rawValue: indexPath.section)!
            switch sectionKind {
            case .bank:
                return collectionView.dequeueConfiguredReusableCell(using: bankCellRegistration, for: indexPath, item: itemIdentifier)
                
            case .asset:
                return collectionView.dequeueConfiguredReusableCell(using: assetCellRegistration, for: indexPath, item: itemIdentifier)
                
            case .expense:
                return collectionView.dequeueConfiguredReusableCell(using: expenseCellRegistration, for: indexPath, item: itemIdentifier)
                
            case .promotion:
                return collectionView.dequeueConfiguredReusableCell(using: promotionCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        
        
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
