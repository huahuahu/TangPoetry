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
        sceneLog("\(#function)")
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
            handleUseActivity(userActivity, for: scene)
        }
        baseTabVC.selectedIndex = 1
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        sceneLog("\(#function)")
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }

    private func handleUseActivity(_ activity: NSUserActivity, for scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("scene is not window scene")
        }
        if activity.activityType == Constants.UserActivity.detail.rawValue {
            if let data = activity.userInfo?[Constants.Keys.userActivity] as? Data,
                let poem = try? JSONDecoder().decode(Poem.self, from: data) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Route.goTo(poem: poem, scene: windowScene)
                    scene.activationConditions = {
                        let condition = UISceneActivationConditions()
                        condition.prefersToActivateForTargetContentIdentifierPredicate = .init(format: "self == 'openDetail1'")
                        return condition
                    }()
                    scene.session.userInfo = ["hh": 1]
                }
            }
        }
    }
}
