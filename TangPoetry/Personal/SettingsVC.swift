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
    private var dataSource: UICollectionViewDiffableDataSource<SettingSection, Item>!
    private var settings = Settings.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configNav()
    }

    private func configNav() {
        navigationItem.title = "Settings"
    }
}

extension SettingsVC {
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
            guard let section = SettingSection(rawValue: sectionIndex) else {
                HFatalError.fatalError()
            }
            switch section {
            case .tintColor:
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                listConfiguration.headerMode = .supplementary
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

        let tintColorCellRegister = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, _, item) in
            guard let self = self else { return }
            var contentConfiguration = UICollectionViewListCell().defaultContentConfiguration()
            contentConfiguration.text = item.title
            if let currentColor = self.settings.tintColor {
                contentConfiguration.textProperties.color = currentColor
            }
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        }
        let switchCellRegister = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, _, item) in
            guard let self = self else { return }
            var contentConfiguration = UICollectionViewListCell().defaultContentConfiguration()
            contentConfiguration.text = item.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            let alphaSwitch = UISwitch()
            alphaSwitch.addTarget(self, action: #selector(self.onColorPickerSwitchChange(sender:)), for: .valueChanged)
            alphaSwitch.isOn = self.settings.colorPickerSupportAlpha
            cell.accessories = [.customView(configuration: .init(customView: alphaSwitch, placement: .trailing()))]
        }

        dataSource = UICollectionViewDiffableDataSource<SettingSection, Item>(collectionView: collectionView, cellProvider: { (collection, indexPath, item) -> UICollectionViewCell? in
            guard let section = SettingSection(rawValue: indexPath.section) else {
                fatalError()
            }
            switch section {
            case .tintColor:
                guard let option = SettingSection.ColorOption(rawValue: item.title) else {
                    HFatalError.fatalError()
                }
                switch option {
                case .changeTintColor:
                    return collection.dequeueConfiguredReusableCell(using: tintColorCellRegister, for: indexPath, item: item)
                case .supportAlpha:
                    return collection.dequeueConfiguredReusableCell(using: switchCellRegister, for: indexPath, item: item)

                }
            }
        })

        let header = UICollectionView.SupplementaryRegistration<HSideBarTitleSupplementaryView>(elementKind: "header") { (view, _, indexPath) in
            guard let section = SettingSection(rawValue: indexPath.section) else {
                HFatalError.fatalError()
            }
            view.label.text = section.description
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let section = SettingSection(rawValue: indexPath.section) else {
                HFatalError.fatalError()
            }
            if kind == UICollectionView.elementKindSectionHeader, section == .tintColor {
                return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
            } else {
                HFatalError.fatalError()
            }

        }
        collectionView.dataSource = dataSource

        dataSource.apply(getCurrentSnapShot())
    }

    func getCurrentSnapShot() -> NSDiffableDataSourceSnapshot<SettingSection, Item> {
        var snapShot = NSDiffableDataSourceSnapshot<SettingSection, Item>()
        for section in SettingSection.allCases {
            switch section {
            case .tintColor:
                snapShot.appendSections([.tintColor])
                snapShot.appendItems(section.items)
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
        if let currentTintColor = settings.tintColor {
            picker.selectedColor = currentTintColor
        }
        picker.supportsAlpha = settings.colorPickerSupportAlpha
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
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        HLog.log(scene: .settings, str: "\(#function)")
        settings.tintColor = viewController.selectedColor
        dataSource.apply(getCurrentSnapShot())
        view.window?.tintColor = viewController.selectedColor
    }
}

extension SettingsVC {
    @objc private func onColorPickerSwitchChange(sender: UISwitch) {
        settings.colorPickerSupportAlpha = sender.isOn
        dataSource.apply(getCurrentSnapShot())
    }
}
