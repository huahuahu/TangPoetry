//
//  String+Extension.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation

extension Locale {
    static let chs = Locale(identifier: "zh_Hans_CN")
}

extension StringProtocol {
    func compareUsingChs<T>(_ aString: T) -> ComparisonResult where T: StringProtocol {
        return compare(aString, options: [.forcedOrdering], range: nil, locale: .chs)
    }
}
