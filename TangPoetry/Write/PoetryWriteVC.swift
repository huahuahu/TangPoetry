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

    private var imageViewDropDelegate: UIDropInteractionDelegate!

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

    func setupDragAndDrop() {
        imageViewDropDelegate = ImageViewDropDelegate(imageView: imageView)
        let dropInteraction = UIDropInteraction.init(delegate: imageViewDropDelegate)

//        let dropInteraction = UIDropInteraction.init(delegate: self)
        imageView.addInteraction(dropInteraction)
    }
}

// MARK: - Drag & Drop
//extension PoetryWriteVC: UIDropInteractionDelegate {
class ImageViewDropDelegate: NSObject, UIDropInteractionDelegate {
    let imageView: UIImageView

    init(imageView: UIImageView) {
        dragDropLog("\(#function)")
        self.imageView = imageView
        super.init()
    }

    func updateImages(_ images: [UIImage]) {
        guard !images.isEmpty else {
            return
        }
        if images.count == 1 {
            self.imageView.image = images.first
        } else {
            self.imageView.animationImages = images
            self.imageView.animationDuration = 1
            self.imageView.startAnimating()
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        dragDropLog("\(#function)")
        return session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        dragDropLog("\(#function)")

            // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            guard let images = imageItems as? [UIImage] else {
                return
            }
            self.updateImages(images)
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        dragDropLog("\(#function)")
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        dragDropLog("\(#function)")
        return .init(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        dragDropLog("\(#function)")
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        dragDropLog("\(#function)")
    }

    func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating) {
        animator.addAnimations {
            dragDropLog("\(#function) animator.addAnimations")

            self.imageView.alpha = 0.5
//            self.imageView.contentMode = .scaleAspectFill
        }
        animator.addCompletion { (_) in
            dragDropLog("\(#function) animator.addCompletion")

            self.imageView.alpha = 1
        }
        dragDropLog("\(#function)")
    }

    func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        dragDropLog("\(#function)")
        let label = UILabel()
        label.text = "haah"
        label.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
//        let preview = UITargetedPreview.init(view: label)
        let dragPreview = UITargetedDragPreview.init(view: label, parameters: .init(), target: .init(container: self.imageView, center: .zero))
        return dragPreview
    }

    func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession) {
//        self.imageView.contentMode = .scaleAspectFit
        dragDropLog("\(#function)")
    }
}

extension PoetryWriteVC: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        return []
    }
}

private func dragDropLog(_ str: String) {
    print("drag&drop: \(str)")
}
