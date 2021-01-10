//
//  Settings.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class Settings: ObservableObject {
    private init() {}
    static let shared = Settings()
    private let userDefaults = UserDefaults.standard

    var tintColor: UIColor? {
        get {
            if let colorData = userDefaults.data(forKey: Key.TintColor.tintColor) {
                do {
                    let color = try JSONDecoder().decode(HColor.self, from: colorData)
                    return color.color
                } catch {
                    HAssert.assertFailure("get tint color: \(error)")

                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            do {
                if let color = newValue {
                    let data = try JSONEncoder().encode(HColor(color: color))
                    userDefaults.set(data, forKey: Key.TintColor.tintColor)
                } else {
                    userDefaults.set(nil, forKey: Key.TintColor.tintColor)
                }
            } catch {
                HAssert.assertFailure("set tint color: \(error)")
            }
        }
    }

    var colorPickerSupportAlpha: Bool {
        get {
            userDefaults.bool(forKey: Key.TintColor.supportAlpha)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.TintColor.supportAlpha)
        }
    }

    var splitVCPreferredDisplayMode: UISplitViewController.DisplayMode {
        get {
            return UISplitViewController.DisplayMode(rawValue: userDefaults.integer(forKey: Key.SplitVC.preferredDisplayMode)) ?? UISplitViewController.DisplayMode.automatic
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: Key.SplitVC.preferredDisplayMode)
        }
    }

    @available(iOS 14.0, *)
    var splitVCSplitBehavior: UISplitViewController.SplitBehavior {
        get {
            return UISplitViewController.SplitBehavior(rawValue: userDefaults.integer(forKey: Key.SplitVC.splitBehavior)) ?? UISplitViewController.SplitBehavior.automatic
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: Key.SplitVC.splitBehavior)
        }
    }

    var splitVCShowSecondaryOnlyButton: Bool {
        get {
            return userDefaults.bool(forKey: Key.SplitVC.showSecondaryOnlyButton)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.SplitVC.showSecondaryOnlyButton)
        }
    }

    var splitVCPresentsWithGesture: Bool {
        get {
            return userDefaults.bool(forKey: Key.SplitVC.presentsWithGesture)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.SplitVC.presentsWithGesture)
        }
    }

    var splitVCPreferredSupplementaryColumnWidthFraction: CGFloat {
        get {
            return CGFloat(userDefaults.double(forKey: Key.SplitVC.preferredSupplementaryColumnWidthFraction))
        }
        set {
            userDefaults.setValue(Double(newValue), forKey: Key.SplitVC.preferredSupplementaryColumnWidthFraction)
        }
    }

    var vcDefaultModalPresentationStyle: UIModalPresentationStyle {
        get {
            return UIModalPresentationStyle(rawValue: userDefaults.integer(forKey: Key.VC.defaultModalPresentationStyle)) ?? UIModalPresentationStyle.automatic
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: Key.VC.defaultModalPresentationStyle)
        }
    }

    enum Key {
        enum TintColor {
            static let tintColor = "h-tintColor-selected"
            static let supportAlpha = "h-tintColor-supportAlpha"
        }

        enum SplitVC {
            static let preferredDisplayMode = "h-SplitVC-preferredDisplayMode"
            static let splitBehavior = "h-SplitVC-splitBehavior"
            static let showSecondaryOnlyButton = "h-SplitVC-showSecondaryOnlyButton"
            static let presentsWithGesture = "h-SplitVC-presentsWithGesture"
            static let preferredSupplementaryColumnWidthFraction = "h-SplitVC-preferredSupplementaryColumnWidthFraction"
        }
        enum VC {
            static let defaultModalPresentationStyle = "h-vc-defaultModalPresentationStyle"
        }
    }
}

enum SettingSection: Int, CaseIterable, CustomStringConvertible, Identifiable {
    var id: String {
        return description
    }

    case tintColor
    case splitVC
    case vc
    case debug

    var supportContextualMenu: Bool {
        switch self {
        case .tintColor, .debug: return false
        case .splitVC, .vc: return true
        }
    }

    var description: String {
        switch self {
        case .tintColor:
            return "Color"
        case .splitVC:
            return "SplitVC"
        case .vc:
            return "UIViewController"
        case .debug:
            return "Debug"
        }
    }

    enum OptionType {
        case bool
        case select
        case empty
        case slider
    }

    enum ColorOption: String, CaseIterable, CustomStringConvertible {
        case changeTintColor
        case supportAlpha

        var description: String {
            switch self {
            case .changeTintColor:
                return "changeTintColor"
            case .supportAlpha:
                return "supportAlpha"
            }
        }

        var item: SettingsVC.Item {
            switch self {
            case .changeTintColor:
                return .init(title: description, valueType: .empty)
            case .supportAlpha:
                return .init(title: description, valueType: .bool)
            }
        }
    }

    enum SplitVCOption: CaseIterable, CustomStringConvertible {
        case preferredDisplayMode
        case splitBehavior
        case showSecondaryOnlyButton
        case presentsWithGesture
        case preferredSupplementaryColumnWidthFraction

        var description: String {
            switch self {
            case .preferredDisplayMode:
                return "preferredDisplayMode"
            case .splitBehavior:
                return "splitBehavior"
            case .showSecondaryOnlyButton:
                return "showSecondaryOnlyButton"
            case .presentsWithGesture:
                return "presentsWithGesture"
            case .preferredSupplementaryColumnWidthFraction:
                return "preferredSupplementaryColumnWidthFraction"
            }
        }

        var item: SettingsVC.Item {
            switch self {
            case .preferredDisplayMode:
                return .init(title: description, valueType: .select, secondaryText: Settings.shared.splitVCPreferredDisplayMode.displayName)
            case .splitBehavior:
                if #available(iOS 14.0, *) {
                    return .init(title: description, valueType: .select, secondaryText: Settings.shared.splitVCSplitBehavior.displayName)
                } else {
                    // Fallback on earlier versions
                    HFatalError.fatalError()
                }
            case .showSecondaryOnlyButton:
                if #available(iOS 14.0, *) {
                    return .init(title: description, valueType: .bool)
                } else {
                    // Fallback on earlier versions
                    HFatalError.fatalError()
                }
            case .presentsWithGesture:
                return .init(title: description, valueType: .bool)
            case .preferredSupplementaryColumnWidthFraction:
                return .init(title: description, valueType: .slider)
            }
        }
    }

    enum VCOption: CaseIterable, CustomStringConvertible {
        case modalPresentationStyle

        var description: String {
            switch self {
            case .modalPresentationStyle:
                return "modalPresentationStyle"
            }
        }

        var item: SettingsVC.Item {
            switch self {
            case .modalPresentationStyle:
                return .init(title: description, valueType: .select, secondaryText: Settings.shared.vcDefaultModalPresentationStyle.displayName)
            }
        }
    }

    var items: [SettingsVC.Item] {
        switch self {
        case .tintColor:
            return ColorOption.allCases.map { $0.item }
        case .splitVC:
            return SplitVCOption.allCases.map { $0.item }
        case .vc:
            return VCOption.allCases.map { $0.item }
        case .debug:
            return [SettingsVC.Item(title: "Debug", valueType: .empty)]
        }
    }
}

class SettingsData: ObservableObject {
    var settings: Settings {
        return Settings.shared
    }
    let uuid = UUID()

    @Published var tintColor: Color = Color(Settings.shared.tintColor ?? .systemGreen) {
        didSet {
            settings.tintColor = UIColor(tintColor)
        }
    }

    @Published var colorPickerSupportAlpha: Bool = Settings.shared.colorPickerSupportAlpha {
        didSet {
            print("colorPickerSupportAlpha \(colorPickerSupportAlpha)")
            settings.colorPickerSupportAlpha = colorPickerSupportAlpha
        }
    }

    @Published var splitVCPreferredDisplayMode: UISplitViewController.DisplayMode = Settings.shared.splitVCPreferredDisplayMode {
        didSet {
            settings.splitVCPreferredDisplayMode = splitVCPreferredDisplayMode
        }
    }

    @Published var splitVCSplitBehavior: UISplitViewController.SplitBehavior =  Settings.shared.splitVCSplitBehavior {
        didSet {
            settings.splitVCSplitBehavior = splitVCSplitBehavior
        }
    }

    @Published var splitVCShowSecondaryOnlyButton: Bool =  Settings.shared.splitVCShowSecondaryOnlyButton {
        didSet {
            print("splitVCShowSecondaryOnlyButton \(splitVCShowSecondaryOnlyButton)")
            settings.splitVCShowSecondaryOnlyButton = splitVCShowSecondaryOnlyButton
        }
    }

    @Published var splitVCPresentsWithGesture: Bool =  Settings.shared.splitVCPresentsWithGesture {
        didSet {
            settings.splitVCPresentsWithGesture = splitVCPresentsWithGesture
        }
    }

    @Published var splitVCPreferredSupplementaryColumnWidthFraction: CGFloat =  Settings.shared.splitVCPreferredSupplementaryColumnWidthFraction {
        didSet {
            settings.splitVCPreferredSupplementaryColumnWidthFraction = splitVCPreferredSupplementaryColumnWidthFraction
        }
    }

    @Published var vcDefaultModalPresentationStyle: UIModalPresentationStyle  =  Settings.shared.vcDefaultModalPresentationStyle {
        didSet {
            settings.vcDefaultModalPresentationStyle = vcDefaultModalPresentationStyle
        }
    }

}
