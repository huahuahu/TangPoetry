//
//  SwiftUISettingsVC.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/6.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI
import UIKit

class SwiftUISettingVC: UIHostingController<SwiftUISettings> {
    override init(rootView: SwiftUISettings) {
        super.init(rootView: rootView)
        configTabBarItem()
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
    }

    private func configNav() {
        navigationItem.title = "Settings"
    }

    private func configTabBarItem() {
        tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gear"), tag: 0)
    }

}
