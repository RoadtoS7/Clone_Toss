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
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("내역", for: .normal)
        button.backgroundColor = .white
        
        var buttonConfig = UIButton.Configuration.gray()
        buttonConfig.contentInsets = .init(top: 7, leading: 15, bottom: 9, trailing: 15)
        buttonConfig.titleAlignment = .center
        buttonConfig.cornerStyle = .medium
        buttonConfig.titleTextAttributesTransformer = .init({ attrContainer in
            var attrContainer = attrContainer
            attrContainer.foregroundColor = UIColor.lightGray
            attrContainer.font = UIFont.boldSystemFont(ofSize: 12)
            return attrContainer
        })
        
        button.configuration = buttonConfig
        return button
    }()
    
    var cancellableBag = Set<AnyCancellable>()
    
    var tabBar: UITabBar? { tabBarController?.tabBar }
    
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
        createView()
        configureDataSource()
        detectScroll()
        
    }
}

// MARK: - View
extension HomeViewController {
    private func createView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
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
            
            switch sectionKind {
            case .bank:
                return self.bankSection()
            
            case .asset:
                return self.assetSection()
            
            case .expense:
                return self.expenseSection()
                
            case .promotion:
                return self.promotionSection()
            }
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
            config.textProperties.font = .systemFont(ofSize: 13)
            config.secondaryText = String(format: "%d원", asset.value)
            config.secondaryTextProperties.font = .systemFont(ofSize: 15)
            
            cell.contentConfiguration = config
            
            cell.accessories = [.customView(configuration: self.sendMoneyButtonConfig(using: asset))]
        }
        
        let assetHeaderRegistration = UICollectionView.SupplementaryRegistration<AssetHeader>(elementKind: AssetHeader.elementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = "자산"
        }
        
        let expenseHeaderRegistration = UICollectionView.SupplementaryRegistration<ExpenseHeader>(elementKind: ExpenseHeader.elementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = "소비"
        }
        
        let monthExpenseCellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell,
                                                                                indexPath: IndexPath,
                                                                                itemIdentifier: String)  in
            let expense = Expense.value[indexPath.row]
            var config = cell.defaultContentConfiguration()
            config.text = expense.title
            config.textProperties.color = .black
            config.textProperties.font = .systemFont(ofSize: 13)
            config.secondaryText = expense.subtitle
            config.secondaryTextProperties.font = .systemFont(ofSize: 15)
            config.image = UIImage(systemName: expense.imageName)
            
            cell.contentConfiguration = config
            cell.accessories = [.customView(configuration: self.showExpenseDetailButtonConfig())]
        }
        
        let cardExpenseCellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell,
                                                                               indexPath: IndexPath,
                                                                               itemIdentifier: String)  in
            let expense = Expense.value[indexPath.row]
            
            var config = cell.defaultContentConfiguration()
            config.text = expense.title
            config.textProperties.color = .black
            config.secondaryText = String(format: "%d원", expense.subtitle)
            config.image = UIImage(systemName: expense.imageName)
            
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
            if let imageName = promotion.imageName {
                config.image = UIImage(systemName: imageName)
            }
            cell.contentConfiguration = config
        }
        
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
    
    private func sendMoneyButtonConfig(using asset: Asset) -> UICellAccessory.CustomViewConfiguration {
        let button = UIButton()
        button.setTitle("송금", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        
        var buttonConfig = UIButton.Configuration.gray()
        buttonConfig.contentInsets = .init(top: 7, leading: 15, bottom: 9, trailing: 15)
        buttonConfig.titleAlignment = .center
        buttonConfig.cornerStyle = .medium
        buttonConfig.titleTextAttributesTransformer = .init({ attrContainer in
            var attrContainer = attrContainer
            attrContainer.foregroundColor = UIColor.lightGray
            attrContainer.font = UIFont.boldSystemFont(ofSize: 12)
            return attrContainer
        })
        
        button.configuration = buttonConfig
        
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .trailing(displayed: .always))
    }
    
    private func showExpenseDetailButtonConfig() -> UICellAccessory.CustomViewConfiguration {
        let button = ShowDetailButton()
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .trailing(displayed: .always))
    }
}

