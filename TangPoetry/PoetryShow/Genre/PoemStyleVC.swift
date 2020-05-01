//
//  PoemThemeViewController.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/1.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import UIKit

/// 按照体裁分类
class PoemStyleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let image: UIImage = UIImage.init(named: "style")!.withRenderingMode(.alwaysOriginal)

        self.tabBarItem = UITabBarItem.init(title: localString("poem_style"), image: image, tag: 2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implement method \(#function)")
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
