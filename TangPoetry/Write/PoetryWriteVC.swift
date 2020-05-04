//
//  PoetryWriteVC.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class PoetryWriteVC: BaseVC {
    let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "安得广厦千万间"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        return label
    }()

    let label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "大庇天下寒士俱欢颜"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        return label
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let image = UIImage.init(systemName: "square.and.pencil")
        self.tabBarItem = .init(title: "写诗", image: image, selectedImage: image)
        self.navigationItem.title = "写诗"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(label1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
    }

    func setupConstraints() {
        let stackView = UIStackView.init(arrangedSubviews: [imageView, label, label1])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.setCustomSpacing(20, after: imageView)
        stackView.setCustomSpacing(20, after: label)
        stackView.spacing = 50
        stackView.layoutMargins = .init(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.75),
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
