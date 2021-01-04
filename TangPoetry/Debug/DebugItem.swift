//
//  DebugItem.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/22.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

struct HDebugItem: Hashable {
    static func == (lhs: HDebugItem, rhs: HDebugItem) -> Bool {
        return lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    let title: String
    let action: ((UIViewController) -> Void)
}

extension HDebugItem {
    static let get = HDebugItem(title: "get") { vc in
        let debugVC = HDebugNetVC()
        vc.present(debugVC, animated: true)
    }
}

enum HDebugSection: String, Hashable, CaseIterable {
    case net

    var debugItems: [HDebugItem] {
        switch self {
        case .net:
            return [.get]
        }
    }
}
