//
//  PoeeSummaryCell.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//
// Custom cell data flow
// 1. cell.updatePoem
// 2. cell.setNeedsUpdateConfiguration
// 3. get cell.configurationState
// 4. cell.updateConfiguration
// 5. update updateConfiguration for given state
// 5. set cell.contentConfiguration
// 6. call contentConfiguration.makeContentView
// 7. create contentView using contentConfiguration
// 8. apply contentConfiguration to content view

import UIKit

@available(iOS 14.0, *)
private extension UIConfigurationStateCustomKey {
    static let poem = UIConfigurationStateCustomKey("com.tiger.suzhen.tang.poem")
}
@available(iOS 14.0, *)
class HPoemSummaryCell: UICollectionViewCell {
    fileprivate enum Constants {
        static let selectedBackgroundColor = UIColor.secondarySystemFill
    }

    private var poem: Poem?

    func updatePoem(_ newPoem: Poem?) {
        guard newPoem != poem else {
            return
        }
        poem = newPoem
        setNeedsUpdateConfiguration()
    }

    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state[.poem] = poem
        return state
    }
}

// MARK: Cell that show title, poet and first content

@available(iOS 14.0, *)
class HPoemSummaryPoetContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.accessibilityIdentifier = "titleLabel"
        return label
    }()
    private let poetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.accessibilityIdentifier = "poetLabel"
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.accessibilityIdentifier = "contentLabel"
        return label
    }()

    private var appliedConfiguration: HPoemSummaryPoetContentConfiguration!

    init(configuration: HPoemSummaryPoetContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? HPoemSummaryPoetContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    private func setupInternalViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, poetLabel, contentLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        self.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.insetsLayoutMarginsFromSafeArea = false
        //        stackView.setCustomSpacing(20, after: poetLabel)
        //        stackView.setCustomSpacing(10, after: titleLabel)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
    }

    private func apply(configuration: HPoemSummaryPoetContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        titleLabel.text = appliedConfiguration.title
        poetLabel.text = appliedConfiguration.poet
        contentLabel.text = appliedConfiguration.content
    }
}

@available(iOS 14.0, *)
struct HPoemSummaryPoetContentConfiguration: UIContentConfiguration, Equatable {
    var title: String?
    var poet: String?
    var content: String?

    func makeContentView() -> UIView & UIContentView {
        return HPoemSummaryPoetContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else { return self }
        var updatedConfig = self
        updatedConfig.title = state.poem?.title
        updatedConfig.poet = state.poem?.author
        updatedConfig.content = state.poem?.contentSummary
        return updatedConfig
    }
}

@available(iOS 14.0, *)
extension UICellConfigurationState {
    var poem: Poem? {
        set {
            self[.poem] = newValue
        }
        get {
            return self[.poem] as? Poem
        }
    }
}

@available(iOS 14.0, *)
class HPoemSummaryPoetCell: HPoemSummaryCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = HPoemSummaryPoetContentConfiguration().updated(for: state)
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        if state.isSelected {
            backgroundConfig.backgroundColor = Constants.selectedBackgroundColor
        }
        backgroundConfiguration = backgroundConfig
    }
}

// MARK: Cell that show title, genre and first content

@available(iOS 14.0, *)
class HPoemSummaryGenreContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.accessibilityIdentifier = "titleLabel"
        return label
    }()
    private let genreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.setTitleColor(.systemBlue, for: .normal)
        button.accessibilityIdentifier = "genreButton"
        return button
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.accessibilityIdentifier = "contentLabel"
        return label
    }()

    var genreButtonClickBlock: ((UIButton) -> Void)?

    private var appliedConfiguration: HPoemSummaryGenreContentConfiguration!

    init(configuration: HPoemSummaryGenreContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? HPoemSummaryGenreContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    private func setupInternalViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, genreButton, contentLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        self.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.insetsLayoutMarginsFromSafeArea = false
        //        stackView.setCustomSpacing(20, after: poetLabel)
        //        stackView.setCustomSpacing(10, after: titleLabel)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])

        genreButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.genreButtonClickBlock?(self.genreButton)
        }), for: .touchUpInside)
    }

    private func apply(configuration: HPoemSummaryGenreContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        titleLabel.text = appliedConfiguration.title
        genreButton.setTitle(appliedConfiguration.genre, for: .normal)
        contentLabel.text = appliedConfiguration.content
    }

}

@available(iOS 14.0, *)
struct HPoemSummaryGenreContentConfiguration: UIContentConfiguration, Equatable {
    var title: String?
    var genre: String?
    var content: String?

    func makeContentView() -> UIView & UIContentView {
        return HPoemSummaryGenreContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else { return self }
        var updatedConfig = self
        updatedConfig.title = state.poem?.title
        updatedConfig.genre = state.poem?.genre.displayName
        updatedConfig.content = state.poem?.contentSummary
        return updatedConfig
    }
}

@available(iOS 14.0, *)
class HPoemSummaryGenreCell: HPoemSummaryCell {
    var clickGenreBlock: ((Poem?) -> Void)?
    override func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = HPoemSummaryGenreContentConfiguration().updated(for: state)
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        if state.isSelected {
            backgroundConfig.backgroundColor = Constants.selectedBackgroundColor
        }
        backgroundConfiguration = backgroundConfig
        configButton()
    }

    private func configButton() {
        (contentView as? HPoemSummaryGenreContentView)?.genreButtonClickBlock = { [weak self] _ in
            self?.clickGenreBlock?(self?.configurationState.poem)
        }
    }
}
