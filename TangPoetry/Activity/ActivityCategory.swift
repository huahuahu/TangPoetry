//
//  ActivityCategory.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/29.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation

enum ActivityCategory: CaseIterable, CustomStringConvertible {
    /// 唐才子传
    case poet
    /// 中国诗词大会
    case CCTV
    case feihualing

    var description: String {
        switch self {
        case .poet:
            return "诗人逸事"
        case .CCTV:
            return "中国诗词大会"
        case .feihualing:
            return "飞花令"
        }
    }

}
