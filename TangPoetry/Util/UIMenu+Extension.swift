//
//  UIMenu+Extension.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

extension UIMenuElement.State {
    var displayName: String {
        switch self {
        case .mixed:
            return "mixed"
        case .on:
            return "on"
        case .off:
            return "off"
        @unknown default:
            fatalError()
        }
    }

}
