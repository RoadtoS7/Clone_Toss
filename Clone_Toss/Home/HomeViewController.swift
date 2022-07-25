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
    
    var order: Int {
        Self.allCases.firstIndex(of: self)!
    }
}

class HomeViewController: UINavigationController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>
    
    enum Constants {
        static let interSectionSpacing: CGFloat = 16
        static let margin: CGFloat = 15
        static let headerHeight: CGFloat = 40
        static let cornerRaidus: CGFloat = 15
    }
    
    var collectionView: UICollectionView!
    var collectionViewHeight: CGFloat {
        collectionView.frame.height
    }
    
    private var dataSource: DataSource!
    
    let button: ShowDetailButton = {
        let button = ShowDetailButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var bottomExpenseView: ExpenseBottomView? {
        let tabBarController = parent as? TabBarController
        return tabBarController?.expenseView
    }
    
    var bottomExpenseViewHeight: CGFloat {
        guard let bottomExpenseView = bottomExpenseView else {
            return .zero
        }
        return bottomExpenseView.frame.height
    }
    
    var doingAnimation = false
    var cancellableBag = Set<AnyCancellable>()
    
    var isExpenseViewHidden = false
    
    var expenseBackground: UIView?
    var expenseBackgroundWidthConstraint: NSLayoutConstraint?
    
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
        collectionView.bounces = false
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height - 30),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

// MARK: - CollectionView.createLayout()
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.interSectionSpacing = Constants.interSectionSpacing
    
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { return nil }
            let background = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)

            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .bank:
                section = self.bankSection()
                section.decorationItems = [background]
            
            case .asset:
                section = self.assetSection()
                section.decorationItems = [background]
            
            case .expense:
                section = self.expenseSection()
                
            case .promotion:
                section = self.promotionSection()
            }
            
            
            return section
        }, configuration: layoutConfig)
       
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
        
        snapShot.appendItems([Bank.value.id], toSection: SectionKind.bank.order)
        snapShot.appendItems(Asset.value.map({ $0.id }), toSection: SectionKind.asset.order)
        snapShot.appendItems(Expense.value.map({ $0.id }), toSection: SectionKind.expense.order)
        snapShot.appendItems(Promotion.value.map({ $0.id }), toSection: SectionKind.promotion.order)
        
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    // MARK: - custom background view 만드는 코드
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard expenseBackground == nil else { return }
        
        let assetCellCount = collectionView.numberOfItems(inSection: SectionKind.asset.rawValue)
        
        guard indexPath.section == SectionKind.asset.rawValue,
              indexPath.row == assetCellCount - 1
        else { return }
    
        // headerHeight + cellHeight * 2
        let height = Constants.headerHeight + cell.frame.height * 2 + 20
        
        expenseBackground = createExpenseBackground()
        guard let expenseBackground = expenseBackground else { return }
        
        expenseBackground.layer.zPosition = -1
        collectionView.addSubview(expenseBackground)
        expenseBackgroundWidthConstraint = expenseBackground.widthAnchor.constraint(equalToConstant: view.bounds.width)
        
        NSLayoutConstraint.activate([
            expenseBackground.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            expenseBackgroundWidthConstraint!,
            expenseBackground.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: Constants.interSectionSpacing + 20),
            expenseBackground.heightAnchor.constraint(equalToConstant: height)
        ])
        
        collectionView.layoutIfNeeded()
    }
    
    private func createExpenseBackground() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRaidus
        view.clipsToBounds = true
        return view
    }
}

