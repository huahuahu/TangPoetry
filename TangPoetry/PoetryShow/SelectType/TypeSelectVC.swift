//
//  TypeSelectVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/5/10.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class TypeSelectVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.view.backgroundColor = .yellow
        }, completion: { _ in

        })
        self.transitionCoordinator?.notifyWhenInteractionChanges { _ in
            self.view.backgroundColor = .red
        }
    }
}
