//
//  SwiftUISettingsVC.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/6.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI
import UIKit

final class SwiftUISettingVCFactory {
    static func createSettingsVC() -> UIViewController {
        let settingVC = UIHostingController(rootView: SwiftUISettings(settingData: SettingsData()))

        // configNav
        settingVC.navigationItem.title = "Settings"

        // config tabBar
        settingVC.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gear"), tag: 0)
        return settingVC
    }
}
