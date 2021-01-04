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
        case collectionView
        case settings
        case navBar
        case sfvc
        case pageVC
        case debug
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

enum HAssert {
    static func assertFailure(_ message: String? = nil) {
        if let message = message {
            assertionFailure(message)
        } else {
            assertionFailure()
        }
    }
}

enum HFatalError {
    static func fatalError(_ message: String? = nil) -> Never {
        if let message = message {
            Swift.fatalError(message)
        } else {
            Swift.fatalError()

        }
    }
}
