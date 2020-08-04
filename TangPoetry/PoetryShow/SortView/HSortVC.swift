//
//  HSortVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 14.0, *)
final class HSortVC: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var sortType: PoetSortType = .genre

    struct Section: Hashable {
        let title: String
    }

    struct Item: Hashable {
        let poem: Poem
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
        configCollectionView()
    }

    private func configNav() {
        navigationItem.title = "按照\(sortType.textForDisplay)浏览"

        let poetryAction =  UIAction(title: "诗人", handler: { [weak self] (_) in
            self?.sortType = .poet
            self?.onSortTypeChange()
        })
        let genreAction = UIAction(title: "体裁", handler: { [weak self] (_) in
            self?.sortType = .genre
            self?.onSortTypeChange()
        })
        switch sortType {
        case .genre:
            genreAction.state = .on
        case .poet:
            poetryAction.state = .on
        }

        let menu = UIMenu(title: "切换排序方式", children: [
            poetryAction, genreAction
        ])
        let primaryAction = UIAction(handler: { _ in
            HLog.log(scene: .navBar, str: "primaryAction clicked")
        })
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(systemItem: .organize, primaryAction: nil, menu: menu)

    }

    private func configTabBar() {
        tabBarItem = UITabBarItem(title: "浏览", image: UIImage(systemName: "paperplane"), selectedImage: UIImage(systemName: "paperplane.fill"))
    }

    private func onSortTypeChange() {
        dataSource.apply(getSnapShot(), animatingDifferences: true)
        configNav()
    }
}

// MARK: Config CollectionView
@available(iOS 14.0, *)
extension HSortVC {
    private func configCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        configDataSource()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }

    private func getCellConfiguration() -> UICollectionView.CellRegistration<HPoemSummaryPoetCell, Item> {
        return .init { cell, indexPath, item in
//            var configuration = cell.defaultContentConfiguration()
//            configuration.text = item.poem.title
//            configuration.secondaryText = item.poem.author
//            cell.contentConfiguration = configuration
            cell.updatePoem(item.poem)
        }
    }

    private func getSectionHeaderConfiguration() -> UICollectionView.SupplementaryRegistration<HSectionHeaderView> {
        return .init(elementKind: "Header") { [weak self] (headerView, string, indexPath) in
            guard let self = self else {
                return
            }
            guard let item = self.dataSource.itemIdentifier(for: indexPath) else {
                HFatalError.fatalError()
            }
            switch self.sortType {
            case .genre:
                headerView.updateTitle(item.poem.genre.displayName)
            case .poet:
                headerView.updateTitle(item.poem.author)
            }
        }
    }

    private func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self](collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: self.getCellConfiguration(), for: indexPath, item: item)
        })

        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self else {
                return nil
            }
            guard kind == UICollectionView.elementKindSectionHeader else {
                HFatalError.fatalError()
            }
            return collectionView.dequeueConfiguredReusableSupplementary(using: self.getSectionHeaderConfiguration(), for: indexPath)
        }
        dataSource.apply(getSnapShot(), animatingDifferences: false, completion: nil)
    }

    private func getSnapShot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        switch sortType {
        case .genre:
            for genre in Genre.allCases {
                snapShot.appendSections([.init(title: genre.displayName)])
                snapShot.appendItems(DataProvider.shared.poemsOfGenre(genre).map { Item(poem: $0)})
            }
        case .poet:
            for poet in DataProvider.shared.authors {
                if let poems = DataProvider.shared.authorPoemsMap[poet],
                   !poems.isEmpty {
                    snapShot.appendSections([Section(title: poet)])
                    snapShot.appendItems(poems.map { Item(poem: $0)})
                } else {
                    HAssert.assertFailure("poet \(poet) has no poem")
                }
            }
        }
        return snapShot
    }
}
