//
//  SettingsVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configNav()
    }

    private func configNav() {
        //        navigationItem.title = "Settings"
    }
}

extension SettingsVC {
    enum Section: Int, CaseIterable {
        case color
        //        case splitVC
    }

    struct Item: Hashable {
        let title: String
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

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
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout.init(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else {
                HFatalError.fatalError()
            }
            switch section {
            case .color:
                let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let section = NSCollectionLayoutSection.list(using: listConfiguration,
                                                             layoutEnvironment: layoutEnvironment)
                return section

            //            case .splitVC:
            //                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            //                let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //
            //                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            //                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            //
            //                let section = NSCollectionLayoutSection(group: group)
            //                return section
            }
        }, configuration: configuration)
    }

    private func configDataSource() {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }

        let tintColorCellRegister = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, _, item) in
            var contentConfiguration = UICollectionViewListCell().defaultContentConfiguration()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.color = Settings.shared.tintColor ?? UIColor.black
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collection, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError()
            }
            switch section {
            case .color:
                return collection.dequeueConfiguredReusableCell(using: tintColorCellRegister, for: indexPath, item: item)
            }
        })
        collectionView.dataSource = dataSource

        dataSource.apply(getCurrentSnapShot())
    }

    func getCurrentSnapShot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        for section in Section.allCases {
            switch section {
            case .color:
                snapShot.appendSections([.color])
                snapShot.appendItems([Item(title: SettingOption.tintColor.description)])
            }
        }
        return snapShot
    }
}

extension SettingsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }
        let picker = UIColorPickerViewController()
        picker.modalPresentationStyle = .formSheet
        picker.delegate = self
        present(picker, animated: true) {
            HLog.log(scene: .settings, str: "color vc presented")
        }
    }
}

@available(iOS 14.0, *)
extension SettingsVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        HLog.log(scene: .settings, str: "\(#function)")
        Settings.shared.tintColor = viewController.selectedColor
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        HLog.log(scene: .settings, str: "\(#function)")
        dataSource.apply(getCurrentSnapShot())
    }
}
