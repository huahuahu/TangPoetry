//
//  WriteType.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation

enum WriteType: CaseIterable, CustomStringConvertible {
    case picture
    case history

    var description: String {
        switch self {
        case .picture:
            return "看图读诗"
        case .history:
            return "历史事件"
        }
    }

}
