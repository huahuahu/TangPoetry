//
//  PoetryWriteVC.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class PoetryWriteVC: BaseVC {
    let imageView: PasteImageView = {
        let imageView = PasteImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let imageView1: PasteImageView = {
        let imageView = PasteImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.isUserInteractionEnabled = true
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
    // swiftlint:disable weak_delegate
    private var imageViewDropDelegate: UIDropInteractionDelegate!
    private var imageViewDragDelegate: UIDragInteractionDelegate!
    private var imageViewDropDelegate1: UIDropInteractionDelegate!
    private var imageViewDragDelegate1: UIDragInteractionDelegate!

    // swiftlint:enable weak_delegate

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
        setupDragAndDrop()
    }

    func setupConstraints() {
        let innerStackView = UIStackView.init(arrangedSubviews: [imageView, imageView1])
        innerStackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        innerStackView.isLayoutMarginsRelativeArrangement = true
        innerStackView.axis = .horizontal
        innerStackView.distribution = .equalSpacing
        innerStackView.alignment = .center
        innerStackView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView.init(arrangedSubviews: [innerStackView, label, label1])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.setCustomSpacing(20, after: innerStackView)
        stackView.setCustomSpacing(20, after: label)
        stackView.spacing = 50
        stackView.layoutMargins = .init(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            imageView.widthAnchor.constraint(equalTo: innerStackView.widthAnchor, multiplier: 0.45),
            imageView.heightAnchor.constraint(equalTo: innerStackView.heightAnchor, multiplier: 0.9),
            imageView1.widthAnchor.constraint(equalTo: innerStackView.widthAnchor, multiplier: 0.45),
            imageView1.heightAnchor.constraint(equalTo: innerStackView.heightAnchor, multiplier: 0.9),
            innerStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.45),
            innerStackView.widthAnchor.constraint(equalTo: stackView.layoutMarginsGuide.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setupDragAndDrop() {
        imageViewDropDelegate = ImageViewDropDelegate(imageView: imageView)
        let dropInteraction = UIDropInteraction.init(delegate: imageViewDropDelegate)

        //        let dropInteraction = UIDropInteraction.init(delegate: self)
        imageView.addInteraction(dropInteraction)

        imageViewDragDelegate = ImageViewDragDelegate(imageView: imageView)
        let dragInteraction = UIDragInteraction.init(delegate: imageViewDragDelegate)
        imageView.addInteraction(dragInteraction)

        imageViewDropDelegate1 = ImageViewDropDelegate(imageView: imageView1)
        let dropInteraction1 = UIDropInteraction.init(delegate: imageViewDropDelegate1)

        //        let dropInteraction = UIDropInteraction.init(delegate: self)
        imageView1.addInteraction(dropInteraction1)

        imageViewDragDelegate1 = ImageViewDragDelegate(imageView: imageView1)
        let dragInteraction1 = UIDragInteraction.init(delegate: imageViewDragDelegate1)
        imageView1.addInteraction(dragInteraction1)
    }
}

// MARK: - Drag & Drop
//extension PoetryWriteVC: UIDropInteractionDelegate {

extension PoetryWriteVC: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        return []
    }
}
