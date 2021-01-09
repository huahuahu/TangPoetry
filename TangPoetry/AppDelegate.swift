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
        SpotlightController.shared.startIndex()
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

    // This will not be called on iOS 13
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        sceneLog("\(#function)")
        print("call shortItem")
    }

    // This will not be called on iOS 13
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }

    // This will not be called on iOS 13
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }
}
