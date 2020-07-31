//
//  HSliderListCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/7/31.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

@available(iOS 14, *)
class HSliderListCell: UICollectionViewListCell {
    var slideValue: Double = 0.0
    var item: SettingsVC.Item? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }

    var onSlideValeChange: ((Double) -> Void)?

    let slider = UISlider()
    let listContentView = UIListContentView(configuration: .subtitleCell())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(slider)
        contentView.addSubview(listContentView)
        slider.translatesAutoresizingMaskIntoConstraints = false
        listContentView.translatesAutoresizingMaskIntoConstraints = false
//        listContentView.setContentCompressionResistancePriority(.init(rawValue: <#T##Float#>), for: .horizontal)
        listContentView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            slider.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            slider.leadingAnchor.constraint(equalTo: listContentView.trailingAnchor),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            slider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.slideValue = self.slideValue
        return state
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var configuration = UIListContentConfiguration.subtitleCell()
        configuration.text = item?.title
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        configuration.secondaryText = formatter.string(from: NSNumber(value: slideValue))
        listContentView.configuration = configuration
        slider.value = Float(state.slideValue)
    }

    @objc func sliderValueChange(sender: UISlider) {
        slideValue = Double(sender.value)
        setNeedsUpdateConfiguration()
        onSlideValeChange?(slideValue)
    }
}

@available(iOS 14.0, *)
private extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("com.tiger.sz.tang.slide")
}

@available(iOS 14.0, *)
extension UICellConfigurationState {
    var slideValue: Double {
        set { self[.item] = newValue }
        get { return self[.item] as? Double ?? 0.0 }
    }
}
