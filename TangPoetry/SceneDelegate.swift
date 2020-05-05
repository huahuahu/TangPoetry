//
//  SceneDelegate.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("\(#function)")
        let baseTabVC = BaseTabVC.init(nibName: nil, bundle: nil)
        window?.rootViewController = baseTabVC
        let navigationVC1 = BaseNavigationVC.init(rootViewController: PoetsVC.init(nibName: nil, bundle: nil))
        let navigationVC2 = BaseNavigationVC.init(rootViewController: PoemGenreVC.init(nibName: nil, bundle: nil))
        let writeNavVC = BaseNavigationVC.init(rootViewController: PoetryWriteVC.init(nibName: nil, bundle: nil))
        baseTabVC.viewControllers = [navigationVC1, navigationVC2, writeNavVC]
        navigationVC1.navigationBar.prefersLargeTitles = true
        navigationVC2.navigationBar.prefersLargeTitles = true
        UITabBar.appearance().tintColor = UIColor.init(named: "globalTint")
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            print(userActivity.activityType)
        }

        baseTabVC.selectedIndex = 1
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        print("saving")
        print(scene.userActivity?.activityType)
        return scene.userActivity
    }
}
