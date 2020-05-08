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

    let poem: Poem
//    private var userActivity: NSUserActivity!

    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .systemBlue
        textView.textAlignment = .center
        textView.font = .preferredFont(forTextStyle: .largeTitle)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.isEditable = false
        return textView
    }()

    init(poem: Poem) {
        self.poem = poem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "exit", style: .done, target: self, action: #selector(destroyScene))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        setupConstraints()
        textView.text = poem.content

        userActivity = poem.userActivity()
        userActivity?.targetContentIdentifier = "openDetail1"
        userActivity?.isEligibleForHandoff = true
        userActivity?.title = poem.title
        userActivity?.needsSave = true
        userActivity?.isEligibleForSearch = true
        userActivity?.keywords = ["test1"]
        userActivity?.requiredUserInfoKeys = ["key1", "key2"]

    }

    private func setupConstraints() {
        let constraints = [
            textView.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textView.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
            textView.heightAnchor.constraint(equalTo: view.readableContentGuide.heightAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(constraints)
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
