//
//  PoetsVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/1.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import UIKit

/// 按照诗人分类
class PoetsVC: UITableViewController {
    
    private let cellIdentifier = "PoetsVC.cellIdentifier"
    private let poetries = DataProvider.shared.allPoetryEntries
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implement method \(#function)")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let image: UIImage = UIImage.init(named: "poet")!.withRenderingMode(.alwaysOriginal)
        self.tabBarItem = UITabBarItem.init(title: localString("poet"), image: image, tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        tableView.register(PoetryEntryCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
}

extension PoetsVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PoetryEntryCell
        //swiftlint:enable force_cast
        let poetry = poetries[indexPath.row]
        cell.updateTitle(poetry.name, subTitle: poetry.author)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poetries.count
    }
}
