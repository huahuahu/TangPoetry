//
//  PoetryEntryCell.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/31.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import UIKit

class PoetryEntryCell: UITableViewCell {

    lazy var titleLable: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.darkText
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.darkGray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateTitle(_ title: String, subTitle: String) {
        titleLable.text = title
        subTitleLabel.text = subTitle
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLable)
        contentView.addSubview(subTitleLabel)
        setConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not inplement \(#function)")
    }

    func setConstraint() {

        let guide = contentView.layoutMarginsGuide
        let titleConstraints = [titleLable.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                                titleLable.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                                titleLable.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1)]
        let subTitleConstraints = [subTitleLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
                                   subTitleLabel.trailingAnchor.constraint(equalTo: titleLable.trailingAnchor),
                                   subTitleLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: titleLable.lastBaselineAnchor, multiplier: 1.5),
                                   guide.bottomAnchor.constraint(equalToSystemSpacingBelow: subTitleLabel.lastBaselineAnchor, multiplier: 1)]

        NSLayoutConstraint.activate(titleConstraints + subTitleConstraints)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLable.text = nil
        subTitleLabel.text = nil
    }

}
