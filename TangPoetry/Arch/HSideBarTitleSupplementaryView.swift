//
//  HSideBarTitleSupplementaryView.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/7/30.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class HSideBarTitleSupplementaryView: UICollectionReusableView {
    let contentView = UIListContentView(configuration: .groupedHeader())

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTitle(_ title: String) {
        var content = UIListContentConfiguration.groupedHeader()
        content.text = title
        contentView.configuration = content
    }

    private func config() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentView.topAnchor.constraint(equalTo: self.readableContentGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor)
        ])
    }
}
