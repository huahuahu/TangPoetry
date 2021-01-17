//
//  UIViewControllerSettings+Extension.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/31.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

extension UIModalPresentationStyle: Identifiable, CustomStringConvertible {
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

    public var id: String {
        displayName
    }

    public var description: String { displayName }

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

extension UIScrollView.ContentInsetAdjustmentBehavior {
    var displayName: String {
        switch self {
        case .automatic:
            return "automatic"
        case .never:
            return "never"
        case .always:
            return "always"
        case .scrollableAxes:
            return "scrollableAxes"
        @unknown default:
            fatalError()
        }
    }
}
