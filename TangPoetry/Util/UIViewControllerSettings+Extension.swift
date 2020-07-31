//
//  UIViewControllerSettings+Extension.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/31.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

extension UIModalPresentationStyle {
    var displayName: String {
        switch self {
        case .automatic:
            return "automatic"
        case .fullScreen:
            return "fullScreen"
        case .pageSheet:
            return "pageSheet"
        case .formSheet:
            return "formSheet"
        case .currentContext:
            return "currentContext"
        case .custom:
            return "custom"
        case .overFullScreen:
            return "overFullScreen"
        case .overCurrentContext:
            return "overCurrentContext"
        case .popover:
            return "popover"
        case .none:
            return "none"
        @unknown default:
            HFatalError.fatalError("unhandled UIModalPresentationStyle \(self)")
        }
    }

    static var allStyles: [UIModalPresentationStyle] = [
        .automatic,
        .fullScreen,
        .pageSheet,
        .formSheet,
        .currentContext,
        .overFullScreen,
        .overCurrentContext,
        .popover,
        .none
    ]
}
