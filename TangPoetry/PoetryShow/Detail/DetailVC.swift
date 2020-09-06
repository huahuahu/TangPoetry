//
//  DetailVC.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//
// Poem Detail VC

import UIKit
import SafariServices

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
        contentScrollView.contentInsetAdjustmentBehavior = .always
        return contentScrollView
    }()

    init(poem: Poem) {
        self.poem = poem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configNavItem() {
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = .init(systemItem: .action, primaryAction: .init(handler: { (action) in
                print("action")
            }), menu: UIMenu(title: "Menu", image: UIImage(systemName: "triangle"), identifier: nil, options: .init(), children: createMenuItem()))
        } else {
            // Fallback on earlier versions
        }
        configNavItem()
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
            // Use frameLayoutGuide to constraint frame
            contentScrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //  Don't scroll horizontally
            contentScrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.widthAnchor),
            contentTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentScrollView.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentScrollView.readableContentGuide.trailingAnchor),
            // Use contentLayoutGuide to determine content size
            stackView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor, constant: Constants.spaceBeforeTitle),
            stackView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor, constant: -Constants.spaceAfterContent)
        ])

        if #available(iOS 14.0, *) {
            authorButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self, let url = self.poem.author.baikeURL else { return }
                let sfvc = SFSafariViewController(url: url)
                self.present(sfvc, animated: true, completion: nil)
            }), for: .primaryActionTriggered)
        } else {
            // Fallback on earlier versions
        }
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

    private func createMenuItem() -> [UIMenuElement] {
        let first = UIAction(title: "share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off) { _ in
            print("share")
            let activityVC = UIActivityViewController(activityItems: ["hahah"], applicationActivities: [])
            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                print("\(activityType), \(completed), error \(activityError)")
            }
            self.present(activityVC, animated: true, completion: nil)
        }
        return [first]
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
