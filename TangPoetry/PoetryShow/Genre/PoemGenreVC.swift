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
    //swiftlint:disable weak_delegate
    private var transDelegate: CutsomTransition.TransitioningDelegate?
    //swiftlint:enable weak_delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "按照体裁浏览"

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let image: UIImage = UIImage.init(named: "style")!.withRenderingMode(.alwaysOriginal)

        self.tabBarItem = UITabBarItem.init(title: localString("poem_style"), image: image, tag: 2)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(selectType))
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

extension PoemGenreVC {
    @objc private func selectType() {
        let selectVC = TypeSelectVC()
        selectVC.modalPresentationStyle = .custom
        transDelegate = CutsomTransition.TransitioningDelegate()
        selectVC.transitioningDelegate = transDelegate
        present(selectVC, animated: true) {
            print("presendte")
        }
    }
}
