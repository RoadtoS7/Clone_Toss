//
//  HomeViewController+DataSource.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/12.
//

import UIKit

extension HomeViewController {
    func bankCellHandler(cell: UICollectionViewListCell,
                         indexPath: IndexPath,
                         itemIdentifier: String) {
        var config = cell.defaultContentConfiguration()
        config.text = Bank.value.name
        config.textProperties.color = .black
        
        cell.contentConfiguration = config
        cell.backgroundColor = .clear
        cell.accessories = [.disclosureIndicator()]
    }
    
    func assetCellHandler(cell: UICollectionViewListCell,
                          indexPath: IndexPath,
                          itemIdentifier: String) {
        let asset = Asset.value[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = asset.name
        config.textProperties.color = .black
        config.textProperties.font = .systemFont(ofSize: 13)
        config.secondaryText = String(format: "%d원", asset.value)
        config.secondaryTextProperties.font = .systemFont(ofSize: 15)
        config.image = UIImage(systemName: "dollarsign.circle")
        cell.backgroundColor = .clear
        cell.contentConfiguration = config
        
        cell.accessories = [.customView(configuration: self.sendMoneyButtonConfig(using: asset))]
    }
    
    func sendMoneyButtonConfig(using asset: Asset) -> UICellAccessory.CustomViewConfiguration {
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
    
    func assetHeaderHandler(assetHeader: AssetHeader, elementKind: String, indexPath: IndexPath) {
        assetHeader.label.text = "자산"
    }
    
    func expenseHeaderHandler(expenseHeader: ExpenseHeader, elementKind: String, indexPath: IndexPath) {
        expenseHeader.label.text = "자산"
    }
    
    func monthCellHandler(cell: UICollectionViewListCell,
                          indexPath: IndexPath,
                          itemIdentifier: String) {
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
    
    func showExpenseDetailButtonConfig() -> UICellAccessory.CustomViewConfiguration {
        let button = ShowDetailButton()
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .trailing(displayed: .always))
    }
    
    func cardExpenseCellHandler(cell: UICollectionViewListCell,
                                indexPath: IndexPath,
                                itemIdentifier: String) {
        let expense = Expense.value[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = expense.title
        config.textProperties.color = .black
        config.secondaryText = String(format: "%d원", expense.subtitle)
        config.image = UIImage(systemName: expense.imageName)
        
        cell.contentConfiguration = config
        cell.accessories = [.disclosureIndicator()]
    }
    
    func promotionCellHandler(cell: UICollectionViewListCell,
                                indexPath: IndexPath,
                                itemIdentifier: String) {
        let promotion = Promotion.value[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = promotion.category
        config.secondaryText = promotion.title
        if let imageName = promotion.imageName {
            config.image = UIImage(systemName: imageName)
        }
        cell.contentConfiguration = config
    }
}
