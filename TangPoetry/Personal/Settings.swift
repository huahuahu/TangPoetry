//
//  Settings.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

class Settings {
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
        }
        enum VC {
            static let defaultModalPresentationStyle = "h-vc-defaultModalPresentationStyle"
        }
    }
}

enum SettingSection: Int, CaseIterable, CustomStringConvertible {
    case tintColor
    case splitVC
    case vc

    var supportContextualMenu: Bool {
        switch self {
        case .tintColor: return false
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
        }
    }

    enum OptionType {
        case bool
        case select
        case empty
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

        var description: String {
            switch self {
            case .preferredDisplayMode:
                return "preferredDisplayMode"
            }
        }

        var item: SettingsVC.Item {
            switch self {
            case .preferredDisplayMode:
                return .init(title: description, valueType: .select, secondaryText: Settings.shared.splitVCPreferredDisplayMode.displayName)
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
        }
    }
}
