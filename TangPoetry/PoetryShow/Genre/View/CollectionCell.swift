//
//  CollectionCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "CollectionCell.reuseIdentifier"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            authorLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            contentLabel.topAnchor.constraint(equalToSystemSpacingBelow: authorLabel.bottomAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: contentLabel.bottomAnchor, multiplier: 2),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            authorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setup(with poetry: PoetryEntry) {
        titleLabel.text = poetry.title
        authorLabel.text = poetry.author
        contentLabel.text = poetry.content
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
        contentLabel.text = nil
    }

    //    https://stackoverflow.com/a/51231881/2739854
    // Autolayout collectionview cell
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        print("\(#function)")
        // option 1
//        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        print(layoutAttributes)
//        layoutIfNeeded()
//        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        // option 2
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        print(targetSize)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        //option 3
//        print(layoutAttributes.frame)
//        contentLabel.preferredMaxLayoutWidth = layoutAttributes.frame.width
//        layoutAttributes.frame.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        return layoutAttributes
    }
}
