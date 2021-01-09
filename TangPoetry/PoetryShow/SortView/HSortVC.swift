//
//  HSortVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

@available(iOS 14.0, *)
final class HSortVC: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var selectedIndexPath: IndexPath?
    var sortType: PoetSortType = .genre {
        didSet {
            onSortTypeChange()
        }
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            if let transitionCoordinator = transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: { _ in
                    self.collectionView.deselectItem(at: selectedIndexPath, animated: true)
                }, completion: { [weak self] context in
                    if context.isCancelled {
                        self?.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
                    }
                })
            } else {
                self.collectionView.deselectItem(at: selectedIndexPath, animated: true)
            }
        }
    }

    private func configNav() {
        navigationItem.title = "按照\(sortType.textForDisplay)浏览"
        if self.splitViewController?.isCollapsed == true {

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
    }

    private func configTabBar() {
        tabBarItem = UITabBarItem(title: "浏览", image: UIImage(systemName: "paperplane"), selectedImage: UIImage(systemName: "paperplane.fill"))
    }

    private func onSortTypeChange() {
        dataSource.apply(getSnapShot(), animatingDifferences: false)
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
        collectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }

    private func getPoetSummaryCellConfiguration() -> UICollectionView.CellRegistration<HPoemSummaryPoetCell, Item> {
        return .init { cell, indexPath, item in
            //            var configuration = cell.defaultContentConfiguration()
            //            configuration.text = item.poem.title
            //            configuration.secondaryText = item.poem.author
            //            cell.contentConfiguration = configuration
            cell.updatePoem(item.poem)
        }
    }

    private func getGenreSummaryCellConfiguration() -> UICollectionView.CellRegistration<HPoemSummaryGenreCell, Item> {
        return .init { (cell, indexPath, item) in
            cell.updatePoem(item.poem)
            cell.clickGenreBlock = { [weak self] poem in
                guard let self = self else { return }
                guard let url = poem?.genre.url else {
                    HFatalError.fatalError("no genre url for \(poem?.genre.displayName)")
                }
                let configuration = SFSafariViewController.Configuration()
                let sfVC = SFSafariViewController(url: url, configuration: configuration)
                sfVC.dismissButtonStyle = .close
                self.present(sfVC, animated: true, completion: nil)
            }
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
            switch self.sortType {
            case .poet:
                return collectionView.dequeueConfiguredReusableCell(using: self.getGenreSummaryCellConfiguration(), for: indexPath, item: item)
            case .genre:
                return collectionView.dequeueConfiguredReusableCell(using: self.getPoetSummaryCellConfiguration(), for: indexPath, item: item)
            }
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

@available(iOS 14.0, *)
extension HSortVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let poem = dataSource.itemIdentifier(for: indexPath)?.poem else {
            HAssert.assertFailure("can not find poem in \(indexPath)")
            return
        }
        show(poem)
        if self.splitViewController?.isCollapsed != true {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

    func show(_ poem: Poem) {
        let options: [UIPageViewController.OptionsKey: Any] = [
            .spineLocation: NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)
        ]
        if self.splitViewController?.isCollapsed == true {
            let pageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: options)
            pageVC.dataSource = self
            pageVC.delegate = self
            let detailVC = DetailVC(poem: poem)
            pageVC.setViewControllers([detailVC], direction: .forward, animated: true)
            pageVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(pageVC, animated: true)
        } else {
            if let pageVC = self.splitViewController?.viewController(for: .secondary) as? UIPageViewController {
                let direction: UIPageViewController.NavigationDirection? = {
                    guard let detailsVC = pageVC.viewControllers as? [DetailVC] else {
                        HAssert.assertFailure()
                        return nil
                    }
                    let displayingPoems = detailsVC.compactMap { $0.poem }
                    if displayingPoems.contains(poem) {
                        HLog.log(scene: .collectionView, str: "poem is showings")
                        return nil
                    }
                    let snapShot = dataSource.snapshot()
                    guard let targetIndex = snapShot.indexOfItem(Item(poem: poem)),
                          let firstDisplayIndex = snapShot.indexOfItem(Item(poem: displayingPoems[0])) else {
                        HAssert.assertFailure("can not found index for poem")
                        return nil
                    }
                    if targetIndex < firstDisplayIndex {
                        return .reverse
                    } else {
                        return .forward
                    }
                }()
                if let direction = direction {
                    pageVC.setViewControllers([DetailVC(poem: poem)], direction: direction, animated: true, completion: nil)
                }
            } else {
                let pageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: options)
                pageVC.dataSource = self
                pageVC.delegate = self
                let detailVC = DetailVC(poem: poem)
                pageVC.setViewControllers([detailVC], direction: .forward, animated: true)
                pageVC.navigationItem.largeTitleDisplayMode = .never
                self.splitViewController?.setViewController(pageVC, for: .secondary)
            }
        }
    }
}

@available(iOS 14.0, *)
extension HSortVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let detailVC = viewController as? DetailVC else {
            HAssert.assertFailure()
            return nil
        }
        let poem = detailVC.poem
        let snapShot = dataSource.snapshot()
        guard let index = snapShot.indexOfItem(Item(poem: poem)) else {
            HAssert.assertFailure("\(poem) not in snapshot")
            return nil
        }
        guard index > 0 else {
            HLog.log(scene: .pageVC, str: "first poem, nothing before")
            return nil
        }
        let preiviousPoem = snapShot.itemIdentifiers[index-1].poem
        return DetailVC(poem: preiviousPoem)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let detailVC = viewController as? DetailVC else {
            HAssert.assertFailure()
            return nil
        }
        let poem = detailVC.poem
        let snapShot = dataSource.snapshot()
        guard let index = snapShot.indexOfItem(Item(poem: poem)) else {
            HAssert.assertFailure("\(poem) not in snapshot")
            return nil
        }
        guard index < snapShot.numberOfItems - 1  else {
            HLog.log(scene: .pageVC, str: "last poem, nothing after")
            return nil
        }
        let nextPoem = snapShot.itemIdentifiers[index+1].poem
        return DetailVC(poem: nextPoem)
    }
}

@available(iOS 14.0, *)
extension HSortVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            let detailVC = pageViewController.viewControllers?.first as? DetailVC
            pageViewController.navigationItem.rightBarButtonItem = detailVC?.navigationItem.rightBarButtonItem
        }
    }
}
