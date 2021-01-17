//
//  SplitVCDisplayMode+Extension.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/31.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

extension UISplitViewController.DisplayMode: Identifiable, CustomStringConvertible {
    var displayName: String {
        switch self {
        case .automatic:
            return "automatic"
        case .secondaryOnly:
            return "secondaryOnly"
        case .oneBesideSecondary:
            return "oneBesideSecondary"
        case .oneOverSecondary:
            return "oneOverSecondary"
        case .twoBesideSecondary:
            return "twoBesideSecondary"
        case .twoOverSecondary:
            return "twoOverSecondary"
        case .twoDisplaceSecondary:
            return "twoDisplaceSecondary"
        @unknown default:
            fatalError("unhandled displaymode \(self)")
        }
    }

    public var id: String { displayName }
    public var description: String { displayName }

    static var allModes: [UISplitViewController.DisplayMode] =
        [
            .automatic,
            .secondaryOnly,
            .oneBesideSecondary,
            .oneOverSecondary,
            .twoBesideSecondary,
            .twoOverSecondary,
            .twoDisplaceSecondary]

}

@available(iOS 14.0, *)
extension UISplitViewController.SplitBehavior: CustomStringConvertible, Identifiable {
    public var id: String {
        return description
    }

    public var description: String {
        displayName
    }

    var displayName: String {
        switch self {
        case .automatic:
            return "automatic"
        case .tile:
            return "tile"
        case .overlay:
            return "overlay"
        case .displace:
            return "displace"
        @unknown default:
            fatalError("unhandled UISplitViewController.SplitBehavior \(self)")
        }
    }

    static var all: [UISplitViewController.SplitBehavior] = [
        .automatic,
        .tile,
        .overlay,
        .displace
    ]
}
