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

    enum Key {
        enum TintColor {
            static let tintColor = "h-tintColor-selected"
            static let supportAlpha = "h-tintColor-supportAlpha"
        }
    }
}

enum SettingSection: Int, CaseIterable, CustomStringConvertible {
//    case splitVC
    case tintColor

    var description: String {
        switch self {
        case .tintColor:
            return "color"
//        case .splitVC:
//            return "splitVC"
        }
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
     }

    var items: [SettingsVC.Item] {
        switch self {
        case .tintColor:
            return ColorOption.allCases.map { SettingsVC.Item(title: $0.description)}
        }
    }

}

