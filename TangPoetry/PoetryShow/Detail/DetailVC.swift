//
//  DetailVC.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//
// Poem Detail VC

import UIKit

class DetailVC: BaseVC {
    private enum Constants {
        static let titleFont = UIFont.preferredFont(forTextStyle: .title2)
        static let titleTextColor = UIColor.black

        static let authorFont = UIFont.preferredFont(forTextStyle: .headline)
        static let authorTextColor = UIColor.systemBlue

        static let contentFont = UIFont.preferredFont(forTextStyle: .body)
        static let contentTextColor = UIColor.black

        static let backgroundColor = UIColor.systemBackground

        static let spaceBeforeTitle: CGFloat = 20
        static let spaceAfterTitle: CGFloat = 20
        static let spaceAfterAuthor: CGFloat = 10
        static let spaceAfterContent: CGFloat = 10
    }
    let poem: Poem
//    private var userActivity: NSUserActivity!

    let titleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "titleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.titleFont
        label.textColor = Constants.titleTextColor
        return label
    }()

    let authorButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "authorButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Constants.authorTextColor, for: .normal)
        button.titleLabel?.font = Constants.authorFont
        return button
    }()

    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.accessibilityIdentifier = "contentTextView"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = Constants.contentTextColor
        textView.textAlignment = .center
        textView.font = Constants.contentFont
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()

    let contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView()
        contentScrollView.accessibilityIdentifier = "contentScrollView"
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.backgroundColor = Constants.backgroundColor
        return contentScrollView
    }()

    init(poem: Poem) {
        self.poem = poem
        super.init(nibName: nil, bundle: nil)
        configNavItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configNavItem() {
//        navigationItem.title = poem.title
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "exit", style: .done, target: self, action: #selector(destroyScene))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateView(poem)
        configureActivity()
    }

    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorButton, contentTextView])
        stackView.setCustomSpacing(Constants.spaceAfterTitle, after: titleLabel)
        stackView.setCustomSpacing(Constants.spaceAfterAuthor, after: authorButton)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = "stackview"
        contentScrollView.addSubview(stackView)
        view.addSubview(contentScrollView)
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentScrollView.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentScrollView.readableContentGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: Constants.spaceBeforeTitle),
            stackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -Constants.spaceAfterContent)
        ])
    }

    private func updateView(_ poem: Poem) {
        titleLabel.text = poem.title
        authorButton.setTitle(poem.author, for: .normal)
        contentTextView.text = poem.content
    }

    @objc private func destroyScene() {
        guard let session = view.window?.windowScene?.session else {
            fatalError("no scene connected to \(#file)")
        }
        let option = UIWindowSceneDestructionRequestOptions()
//        option.windowDismissalAnimation = .standard
        UIApplication.shared.requestSceneSessionDestruction(session, options: option) { (error) in
            sceneLog("requestSceneSessionDestruction \(error)")
        }
    }
}

extension DetailVC {
    override func updateUserActivityState(_ activity: NSUserActivity) {
        var userInfo = [String: Any]()
//        userInfo["test"] = "test"
        userInfo["phoneNumber"] = "+86 185 6565 8170"

        activity.addUserInfoEntries(from: userInfo)
        activity.contentAttributeSet?.supportsNavigation = true
        activity.contentAttributeSet?.supportsPhoneCall = true
        activity.contentAttributeSet?.phoneNumbers = ["+86 185 6565 8170"]
//        activity.contentAttributeSet?.thumbnailData = #imageLiteral(resourceName: "pizza").pngData()

    }
}

// MARK: UIActivity

extension DetailVC {
    private func configureActivity() {
        userActivity = poem.userActivity()
        userActivity?.targetContentIdentifier = "openDetail1"
        userActivity?.isEligibleForHandoff = true
        userActivity?.title = poem.title
        userActivity?.needsSave = true
        userActivity?.isEligibleForSearch = true
        userActivity?.keywords = [poem.title]
        userActivity?.requiredUserInfoKeys = ["key1", "key2"]
    }
}
