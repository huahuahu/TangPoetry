//
//  AppDelegate.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/6/30.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupShortcut()
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        sceneLog("\(#function)")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupShortcut() {
//        var shortcutItems: [UIApplicationShortcutItem] = {
//            let items = [UIApplicationShortcutItem]()
//            let item = UIApplicationShortcutItem.init(type: "test", localizedTitle: "openDetail")
//            item.targetContentIdentifier = "openDetail"
//            return items
//        }()
//        UIApplication.shared.shortcutItems = shortcutItems
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        sceneLog("\(#function)")
        print("call shortItem")
    }
}
