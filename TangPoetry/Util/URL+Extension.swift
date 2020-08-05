//
//  URL+Extension.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation

extension URL {
    init(staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            fatalError("Invalid static URL string: \(staticString)")
        }
        self = url
    }
}
