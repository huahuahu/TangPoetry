//
//  PoetSortType.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
enum PoetSortType: CaseIterable {
    case poet
    case genre

    var textForDisplay: String {
        switch self {
        case .poet:
            return "诗人"
        case .genre:
            return "体裁"
        }
    }
}
