//
//  PoemThemeViewController.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/1.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import UIKit

/// 按照体裁分类
class PoemGenreVC: BaseVC {

    let genreView = GenreView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "按照体裁浏览"

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let image: UIImage = UIImage.init(named: "style")!.withRenderingMode(.alwaysOriginal)

        self.tabBarItem = UITabBarItem.init(title: localString("poem_style"), image: image, tag: 2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implement method \(#function)")
    }

    override func loadView() {
        super.loadView()
//        self.view = GenreView()
        view.backgroundColor = .systemBackground
        view.addSubview(genreView)
        setupConstraints()
        genreView.setUp(with: DataProvider.shared.allPoetryEntries)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.window?.windowScene?.userActivity = {
            let userActivity = NSUserActivity.init(activityType: Constants.UserActivity.openTab.rawValue)
            userActivity.title = "open"
            userActivity.userInfo = ["tab": tabBarController?.selectedIndex ?? -1]
            return userActivity
        }()
        print("set windowScene?.userActivity to not nil: \(view.window?.windowScene?.userActivity)")
    }

    func setupConstraints() {
//        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            genreView.topAnchor.constraint(equalTo: view.topAnchor),
            genreView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            genreView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genreView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

    }
}
