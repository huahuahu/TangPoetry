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
        let valueType: SettingSection.OptionType
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
            guard SettingSection(rawValue: sectionIndex) != nil else {
                HFatalError.fatalError()
            }
            var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            listConfiguration.headerMode = .supplementary
            let layoutSection = NSCollectionLayoutSection.list(using: listConfiguration,
                                                         layoutEnvironment: layoutEnvironment)
            return layoutSection
        }, configuration: configuration)
    }

    private func configDataSource() {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }

        let emptyCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, _, item) in
            guard let self = self else { return }
            var contentConfiguration = UICollectionViewListCell().defaultContentConfiguration()
            contentConfiguration.text = item.title
            if item.title == SettingSection.ColorOption.changeTintColor.description {
                if let currentColor = self.settings.tintColor {
                    contentConfiguration.textProperties.color = currentColor
                }
            }
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        }

        let selectionCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, _, item) in
            guard let self = self else { return }
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = item.title
            if item.title == SettingSection.SplitVCOption.preferredDisplayMode.description {
                contentConfiguration.secondaryText = "\(self.settings.splitVCPreferredDisplayMode)"
            } else {
                HFatalError.fatalError()
            }
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        }

        let switchCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, _, item) in
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

        dataSource = UICollectionViewDiffableDataSource<SettingSection, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item.valueType {
            case .bool:
                return collectionView.dequeueConfiguredReusableCell(using: switchCellRegistration, for: indexPath, item: item)
            case .empty:
                return collectionView.dequeueConfiguredReusableCell(using: emptyCellRegistration, for: indexPath, item: item)
            case .select:
                return collectionView.dequeueConfiguredReusableCell(using: selectionCellRegistration, for: indexPath, item: item)
            }
        })

        let header = UICollectionView.SupplementaryRegistration<HSideBarTitleSupplementaryView>(elementKind: "header") { (view, _, indexPath) in
            guard let section = SettingSection(rawValue: indexPath.section) else {
                HFatalError.fatalError()
            }
            view.label.text = section.description
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard SettingSection(rawValue: indexPath.section) != nil else {
                HFatalError.fatalError()
            }
            if kind == UICollectionView.elementKindSectionHeader {
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
            snapShot.appendSections([section])
            snapShot.appendItems(section.items)
        }
        return snapShot
    }
}

extension SettingsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let section = SettingSection(rawValue: indexPath.section) else {
            HFatalError.fatalError()
        }
        switch section {
        case .tintColor:
            handleSelectTintColor(indexPath: indexPath)
        case .splitVC:
            handleClickSpliVCOption(indexPath: indexPath)
        }
    }

    private func handleSelectTintColor(indexPath: IndexPath) {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            HFatalError.fatalError()
        }
        switch item.title {
        case SettingSection.ColorOption.changeTintColor.rawValue:
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
        default:
            HFatalError.fatalError("unknow item title clicked: \(item.title)")
        }
    }

    private func handleClickSpliVCOption(indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }
        guard let section = SettingSection(rawValue: indexPath.section),
            let item = dataSource.itemIdentifier(for: indexPath) else {
            HFatalError.fatalError()
        }
        guard section == .splitVC else {
            return nil
        }

        if item.title == SettingSection.SplitVCOption.preferredDisplayMode {

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
