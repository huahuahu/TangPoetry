//
//  SideBarVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/29.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class SideBarVC: UIViewController {

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
    }

}

extension SideBarVC {

    enum Section: Int, CaseIterable {
        case sort
        case activity
        case write
        case personal

        var textInCell: String {
            switch self {
            case .sort:
                return "查看"
            case .activity:
                return "活动"
            case .write:
                return "写诗"
            case .personal:
                return "设置"
            }
        }

        var items: [Item] {
            switch self {
            case .sort:
                return PoetSortType.allCases.map { Item(text: $0.textForDisplay, hasChildren: false)}
            case .activity:
                return ActivityCategory.allCases.map { Item(text: $0.description, hasChildren: false)}
            case .write:
                return WriteType.allCases.map { Item(text: $0.description, hasChildren: false)}
            case .personal:
                return [Item(text: "设置", hasChildren: false)]
            }
        }

    }

    struct Item: Hashable {
        let text: String
        let hasChildren: Bool
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    struct ElementKind {
//        static let badge = "badge-element-kind"
//        static let background = "background-element-kind"
        static let sectionHeader = "section-header-element-kind"
        static let sectionFooter = "section-footer-element-kind"
//        static let layoutHeader = "layout-header-element-kind"
//        static let layoutFooter = "layout-footer-element-kind"
    }

    private func setupCollectionView() {
        guard #available(iOS 14.0, *) else {
            fatalError()
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        configureDataSource()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        guard #available(iOS 14.0, *) else {
            fatalError()
        }

        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        listConfiguration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40)), elementKind: ElementKind.sectionHeader, alignment: .top)
//        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40)), elementKind: ElementKind.sectionHeader, alignment: .bottom)

//        layout.configuration.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        return layout
    }

    private func configureDataSource() {
        guard #available(iOS 14.0, *) else {
            fatalError()
        }

        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.sidebarCell()
            content.text = item.text
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collection, indexpath, item) -> UICollectionViewCell? in
            return collection.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexpath, item: item)
        })

        let headerRegisteration = UICollectionView.SupplementaryRegistration<HSideBarTitleSupplementaryView>(elementKind: "Header") { (view, string, indexPath) in
            let section = Section(rawValue: indexPath.section)
            view.label.text = section?.textInCell
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, index) in
            HLog.log(scene: .collectionView, str: "supplementaryViewProvider kind: \(kind)")
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegisteration, for: index)
        }

        // init snapShot
        for section in Section.allCases {
            var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            snapshot.append(section.items)
            dataSource.apply(snapshot, to: section, animatingDifferences: false) {
                HLog.log(scene: .collectionView, str: "dataSource.apply to \(section) success")

            }
        }
    }
}
