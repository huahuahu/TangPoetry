//
//  DebugVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/22.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

@available(iOS 14, *)
final class DebugVC: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HDebugSection, HDebugItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureCollectionView()
        // Do any additional setup after loading the view.
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.delegate = self
        configureCollectionViewDataSource()
    }

    private func configureNav() {
        navigationItem.title = "Debug"
        navigationItem.largeTitleDisplayMode = .never
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func getCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, HDebugItem> {
        return UICollectionView.CellRegistration { (cell, _, item) in
            HLog.log(scene: .collectionView, str: "cell")
            var content = UIListContentConfiguration.groupedFooter()
            content.text = item.title
            cell.contentConfiguration = content
            let backgroundContent = UIBackgroundConfiguration.listGroupedCell()
            cell.backgroundConfiguration = backgroundContent
        }
    }

    private func getHeaderRegistration() -> UICollectionView.SupplementaryRegistration<HSectionHeaderView> {
        return .init(elementKind: "UICollectionView.elementKindSectionHeader") { [weak self] (headerView, kind, indexPath) in
            guard let self = self else { return }
            HLog.log(scene: .collectionView, str: "header")
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
//            var content = UIListContentConfiguration.groupedHeader()
//            content.text = section.rawValue
//            headerView.contentConfiguration = content
//            let backgroundContent = UIBackgroundConfiguration.listGroupedHeaderFooter()
//            headerView.backgroundConfiguration = backgroundContent
            headerView.updateTitle(section.rawValue)
        }
    }

    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HDebugSection, HDebugItem>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: self.getCellRegistration(), for: indexPath, item: item)
        })

        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, index) in
            guard let self = self else { return nil }
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: self.getHeaderRegistration(), for: index)
            } else {
                fatalError()
            }
        }

        collectionView.dataSource = dataSource

        var snapshot = NSDiffableDataSourceSnapshot<HDebugSection, HDebugItem>()
        for section in HDebugSection.allCases {
            snapshot.appendSections([section])
            snapshot.appendItems(section.debugItems)
        }
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }

}

@available(iOS 14, *)
extension DebugVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            HFatalError.fatalError()
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        item.action(self)
    }
}
