//
//  SceneDelegate.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var settings = Settings.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sceneLog("\(#function)")
        configRootVC()

        window?.tintColor = Settings.shared.tintColor
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            handleUseActivity(userActivity, for: scene)
        }
        //        baseTabVC.selectedIndex = 1
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}

extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        sceneLog("\(#function)")
    }

    func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
        sceneLog("\(#function)")
    }

    override func updateUserActivityState(_ activity: NSUserActivity) {
        sceneLog("\(#function)")
    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {
        sceneLog("\(#function)")
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        sceneLog("\(#function)")
    }

    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        sceneLog("\(#function)")
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        sceneLog("\(#function)")
        return scene.userActivity
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

extension SceneDelegate {
    private func configRootVC() {
        guard #available(iOS 14, *) else {
            fatalError()
        }
        let splitVC = HSplitViewController.init(style: .tripleColumn)
        window?.rootViewController = splitVC
        configureCompact(splitVC)
        splitVC.setViewController(SideBarVC(), for: .primary)
        splitVC.setViewController(HSortVC(), for: .supplementary)
        splitVC.setViewController(DetailVC(poem: DataProvider.shared.allPoetryEntries.first! ), for: .secondary)
        splitVC.preferredDisplayMode = settings.splitVCPreferredDisplayMode
        splitVC.preferredSplitBehavior = settings.splitVCSplitBehavior
        splitVC.showsSecondaryOnlyButton = settings.splitVCShowSecondaryOnlyButton
        splitVC.preferredSupplementaryColumnWidthFraction = settings.splitVCPreferredSupplementaryColumnWidthFraction
    }

    private func configureCompact(_ splitVC: UISplitViewController) {
        guard #available(iOS 14, *) else {
            fatalError()
        }
        let baseTabVC = BaseTabVC.init(nibName: nil, bundle: nil)
        let navigationVC1 = BaseNavigationVC.init(rootViewController: HSortVC())
        let navigationVC2 = BaseNavigationVC.init(rootViewController: PoemGenreVC.init(nibName: nil, bundle: nil))
        let writeNavVC = BaseNavigationVC.init(rootViewController: PoetryWriteVC.init(nibName: nil, bundle: nil))

        let settingNavVC: BaseNavigationVC
        if settings.useSwiftUISettings {
            settingNavVC = BaseNavigationVC(rootViewController: SwiftUISettingVCFactory.createSettingsVC())
        } else {
            settingNavVC = BaseNavigationVC(rootViewController: SettingsVC())
        }
        settingNavVC.navigationBar.prefersLargeTitles = true

        baseTabVC.viewControllers = [navigationVC1, navigationVC2, writeNavVC, settingNavVC]
        navigationVC1.navigationBar.prefersLargeTitles = true
        navigationVC2.navigationBar.prefersLargeTitles = true
        splitVC.setViewController(baseTabVC, for: .compact)

    }
}
