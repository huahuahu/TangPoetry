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
        let secondaryText: String?
        let valueType: SettingSection.OptionType
        let identifier = UUID()

        init(title: String, valueType: SettingSection.OptionType, secondaryText: String? = nil) {
            self.title = title
            self.valueType = valueType
            self.secondaryText = secondaryText
        }
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

    @available(iOS 14.0, *)
    private func createSlideCellRegistration() -> UICollectionView.CellRegistration<HSliderListCell, Item> {
        return .init { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }
            HLog.log(scene: .collectionView, str: "createSlideCellRegistration")
            if item.title == SettingSection.SplitVCOption.preferredSupplementaryColumnWidthFraction.description {
                cell.slideValue = Double(self.settings.splitVCPreferredSupplementaryColumnWidthFraction)
                cell.onSlideValeChange = {
                    self.settings.splitVCPreferredSupplementaryColumnWidthFraction = CGFloat($0)
                }
            }
            cell.item = item
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        }
    }
    private func configDataSource() {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }

        let emptyCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, _, item) in
            HLog.log(scene: .collectionView, str: "emptyCellRegistration")

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
            HLog.log(scene: .collectionView, str: "selectionCellRegistration")
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = item.title
            if let secondaryText = item.secondaryText {
                contentConfiguration.secondaryText = secondaryText
            } else {
                HFatalError.fatalError()
            }
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        }

        let switchCellRegistration = UICollectionView.CellRegistration<HSwitchListCell, Item> { [weak self] (cell, _, item) in
            guard let self = self else { return }
            HLog.log(scene: .collectionView, str: "switchCellRegistration")

            var contentConfiguration = UICollectionViewListCell().defaultContentConfiguration()
            contentConfiguration.text = item.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            cell.accessories = [.customView(configuration: .init(customView: cell.switchControl, placement: .trailing()))]
            cell.switchControl.onTintColor = self.settings.tintColor
            if item.title == SettingSection.ColorOption.supportAlpha.description {
                cell.switchControl.addTarget(self, action: #selector(self.onColorPickerSwitchChange(sender:)), for: .valueChanged)
                cell.switchControl.isOn = self.settings.colorPickerSupportAlpha
            } else if item.title == SettingSection.SplitVCOption.showSecondaryOnlyButton.description {
                cell.switchControl.addTarget(self, action: #selector(self.onSplitVCShowSecondaryButtonSwitchChange(sender:)), for: .valueChanged)
                cell.switchControl.isOn = self.settings.splitVCShowSecondaryOnlyButton
            } else if item.title == SettingSection.SplitVCOption.presentsWithGesture.description {
                cell.switchControl.addTarget(self, action: #selector(self.onSplitVCPresentsWithGesture(sender:)), for: .valueChanged)
                cell.switchControl.isOn = self.settings.splitVCPresentsWithGesture
            } else {
                HFatalError.fatalError()
            }
        }

        dataSource = UICollectionViewDiffableDataSource<SettingSection, Item>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            switch item.valueType {
            case .bool:
                return collectionView.dequeueConfiguredReusableCell(using: switchCellRegistration, for: indexPath, item: item)
            case .empty:
                return collectionView.dequeueConfiguredReusableCell(using: emptyCellRegistration, for: indexPath, item: item)
            case .select:
                return collectionView.dequeueConfiguredReusableCell(using: selectionCellRegistration, for: indexPath, item: item)
            case .slider:
                return collectionView.dequeueConfiguredReusableCell(using: self.createSlideCellRegistration(), for: indexPath, item: item)

            }
        })

        let header = UICollectionView.SupplementaryRegistration<HSideBarTitleSupplementaryView>(elementKind: "header") { (cell, _, indexPath) in
            guard let section = SettingSection(rawValue: indexPath.section) else {
                HFatalError.fatalError()
            }
            HLog.log(scene: .collectionView, str: "headercell")

//            var contentConfiguration = UIListContentConfiguration.groupedHeader()
//            contentConfiguration.text = section.description
//            cell.contentConfiguration = contentConfiguration
//            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedHeaderFooter()
            cell.label.text = section.description
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
        case .vc:
            handleClickVCOption(indexPath: indexPath)
        }
    }

    private func handleSelectTintColor(indexPath: IndexPath) {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            HFatalError.fatalError()
        }
        guard SettingSection.ColorOption.allCases.map({ $0.description }).contains(item.title) else {
            HFatalError.fatalError()
        }
        switch item.title {
        case SettingSection.ColorOption.changeTintColor.rawValue:
            let picker = UIColorPickerViewController()
            if let currentTintColor = settings.tintColor {
                picker.selectedColor = currentTintColor
            }
            picker.supportsAlpha = settings.colorPickerSupportAlpha
            picker.modalPresentationStyle = settings.vcDefaultModalPresentationStyle
            picker.delegate = self
            present(picker, animated: true) {
                HLog.log(scene: .settings, str: "color vc presented")
            }
        default:
            ()
        }
    }

    private func handleClickSpliVCOption(indexPath: IndexPath) {

    }

    private func handleClickVCOption(indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard #available(iOS 14, *) else {
            HFatalError.fatalError()
        }
        guard let section = SettingSection(rawValue: indexPath.section),
            let item = dataSource.itemIdentifier(for: indexPath) else {
            HFatalError.fatalError()
        }
        guard section.supportContextualMenu else {
            return nil
        }

        if item.title == SettingSection.SplitVCOption.preferredDisplayMode.description {
            let actionProvider: UIContextMenuActionProvider = { [weak self] _ in
                guard let self = self else { return nil }
                let modes: [UISplitViewController.DisplayMode] = [
                    .automatic,
                    .secondaryOnly,
                    .oneBesideSecondary,
                    .oneOverSecondary,
                    .twoBesideSecondary,
                    .twoOverSecondary,
                    .twoDisplaceSecondary
                ]
                let actions = modes.map { mode in
                    UIAction(title: mode.displayName) { [weak self] (action) in
                        guard let self = self else { return }
                        self.settings.splitVCPreferredDisplayMode = mode
                        self.dataSource.apply(self.getCurrentSnapShot())
                    }
                }
                return UIMenu(title: "Change preferredDisplayMode", children: actions)
            }

            return UIContextMenuConfiguration(identifier: "unique-ID" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
        } else if item.title == SettingSection.VCOption.modalPresentationStyle.description {
            let actionProvider: UIContextMenuActionProvider = { [weak self] _ in
                guard let self = self else { return nil }
                let actions = UIModalPresentationStyle.allStyles.map { style in
                    UIAction(title: style.displayName) { [weak self] (action) in
                        guard let self = self else { return }
                        self.settings.vcDefaultModalPresentationStyle = style
                        self.dataSource.apply(self.getCurrentSnapShot())
                    }
                }
                return UIMenu(title: "Change DefaultModalPresentationStyle", children: actions)
            }

            return UIContextMenuConfiguration(identifier: "unique-ID" as NSCopying, previewProvider: nil, actionProvider: actionProvider)

        } else if item.title == SettingSection.SplitVCOption.splitBehavior.description {
            let actionProvider: UIContextMenuActionProvider = { [weak self] _ in
                guard let self = self  else {
                    return nil
                }

                let actions = UISplitViewController.SplitBehavior.all.map { behavior in
                    UIAction(title: behavior.displayName) { [weak self] _ in
                        guard let self = self else { return }
                        self.settings.splitVCSplitBehavior = behavior
                        self.dataSource.apply(self.getCurrentSnapShot())
                    }
                }
                return UIMenu(title: "Change Split Behavior", children: actions)
            }
            return UIContextMenuConfiguration(identifier: "SettingSection.SplitVCOption.splitBehavior" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
        } else {
            return nil
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

    @objc private func onSplitVCShowSecondaryButtonSwitchChange(sender: UISwitch) {
        settings.splitVCShowSecondaryOnlyButton = sender.isOn
        dataSource.apply(getCurrentSnapShot())
    }
    @objc private func onSplitVCPresentsWithGesture(sender: UISwitch) {
        settings.splitVCPresentsWithGesture = sender.isOn
        dataSource.apply(getCurrentSnapShot())
    }

}
