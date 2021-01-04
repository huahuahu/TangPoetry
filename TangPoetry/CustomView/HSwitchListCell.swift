//
//  HSwitchListCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

@available(iOS 14, *)
class HSwitchListCell: UICollectionViewListCell {
    let switchControl = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        switchControl.isOn = false
        switchControl.removeTarget(nil, action: nil, for: .allEvents)
    }
}
