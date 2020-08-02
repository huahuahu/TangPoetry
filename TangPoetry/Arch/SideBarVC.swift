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

    enum Section {
        case main
    }
    enum Category: Int, CaseIterable {
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
                return []
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
        collectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        guard #available(iOS 14.0, *) else {
            fatalError()
        }

        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        listConfiguration.headerMode = .supplementary
//        listConfiguration.backgroundColor = .systemRed
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)

        return layout
    }

    private func configureDataSource() {
        guard #available(iOS 14.0, *) else {
            fatalError()
        }

        let headerCellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, _, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.text
            guard item.hasChildren else {
                fatalError()
            }
            content.textProperties.font = .preferredFont(forTextStyle: .title2)
            cell.accessories = [.outlineDisclosure(options: .init(style:.header))]
            cell.contentConfiguration = content
        }

        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, _, item) in
            var content = UIListContentConfiguration.sidebarCell()
            content.text = item.text
            guard !item.hasChildren else {
                fatalError()
            }
            content.textProperties.font = .preferredFont(forTextStyle: .body)
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collection, indexpath, item) -> UICollectionViewCell? in
            if item.hasChildren {
                return collection.dequeueConfiguredReusableCell(using: headerCellRegisteration, for: indexpath, item: item)
            } else {
                return collection.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexpath, item: item)
            }
        })

        let headerRegisteration = UICollectionView.SupplementaryRegistration<HSectionHeaderView>(elementKind: "Header8") { (headerView, _, _) in
//            let category = Category(rawValue: indexPath.section)
            headerView.updateTitle("预置")
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, index) in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegisteration, for: index)
            } else {
                fatalError()
            }
        }

        // init snapShot
        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        for category in Category.allCases {
            if category.items.isEmpty {
                let categoryItem = Item(text: category.textInCell, hasChildren: false)
                snapshot.append([categoryItem])
            } else {
                let categoryItem = Item(text: category.textInCell, hasChildren: true)
                snapshot.append([categoryItem])
                snapshot.append(category.items, to: categoryItem)
            }
        }
        dataSource.apply(snapshot, to: .main, animatingDifferences: false) {
            HLog.log(scene: .collectionView, str: "dataSource.apply to main success")
        }
    }
}

extension SideBarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard #available(iOS 14.0, *) else {
            fatalError()
        }
//        collectionView.deselectItem(at: indexPath, animated: true)
        let item = dataSource.itemIdentifier(for: indexPath)
        if item?.text == Category.personal.textInCell {
            splitViewController?.setViewController(SettingsVC(), for: .secondary)
        }
    }
}
