//
//  Route.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

struct Route {
    static func goTo(poem: Poem, scene: UIWindowScene) {
        let detailVC = DetailVC.init(poem: poem)
        let tabvc = scene.windows.first?.rootViewController as? UITabBarController
        let navVC = tabvc?.selectedViewController as? UINavigationController
        navVC?.pushViewController(detailVC, animated: true)

    }
}
