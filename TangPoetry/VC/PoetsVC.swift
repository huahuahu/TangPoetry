//
//  PoetsVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/1.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import UIKit

/// 按照诗人分类
class PoetsVC: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implement method \(#function)")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let image: UIImage = UIImage.init(named: "poet")!.withRenderingMode(.alwaysOriginal)

        self.tabBarItem = UITabBarItem.init(title: localString("poet"), image: image, tag: 2)

//        self.tabBarItem.setBadgeTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
//        self.tabBarItem.badgeValue = "dd"

//        self.tabBarItem = UITabBarItem.init(tabBarSystemItem: .recents, tag: 4)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
