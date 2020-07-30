//
//  HSideBarTitleSupplementaryView.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class HSideBarTitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func config() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.topAnchor.constraint(equalTo: self.readableContentGuide.topAnchor, constant: 5),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: self.readableContentGuide.leadingAnchor, constant: 5)
        ])
    }

}
