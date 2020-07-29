//
//  Logs.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation

enum HLog {
    enum Scenario: String {
        case dragDrop
        case scene
    }

    static func log(scene: Scenario, str: String) {
        print("\(scene): \(str)")
    }
}

func dragDropLog(_ str: String) {
    print("drag&drop: \(str)")
}

func sceneLog(_ str: String) {
    print("log")
    print("scene log: \(str)")
}

