//
//  HomeViewController.swift
//  Clone_Toss
//
//  Created by nylah.j on 2022/07/11.
//

import UIKit

enum SectionType: Int, CaseIterable {
    case bank = 0
    case asset = 1
    case expense = 2
    case promotion = 3
}

class HomeViewController: UINavigationController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.basicListLayout())
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
        
        let asset = Asset.value[indexPath.row]
        
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = asset.name
        contentConfig.textProperties.color = .black
        contentConfig.secondaryText = "\(asset.value)"
        contentConfig.image = UIImage(systemName: "dollarsign.circle")
        cell.contentConfiguration = contentConfig
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .lightGray
        cell.backgroundConfiguration = backgroundConfig
    }
    
    func basicListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private lazy var dataSource: DataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        self.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"), tag: 0)
        
        collectionView.dataSource = dataSource
        
        var snapShot = SnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(Asset.value.map({ $0.name }))
        dataSource.applySnapshotUsingReloadData(snapShot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}
