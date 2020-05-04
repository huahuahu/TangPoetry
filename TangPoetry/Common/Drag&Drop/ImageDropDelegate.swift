//
//  ImageDropDelegate.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

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
        if session.allowsMoveOperation {
            let proposal = UIDropProposal.init(operation: .move)
//            proposal.isPrecise = true
            proposal.prefersFullSizePreview = true
            return proposal
        } else {
            return .init(operation: .copy)
        }
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
        label.text = "dropped"
        label.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        let size = self.imageView.bounds.size
//        let preview = UITargetedPreview.init(view: label)
        let target = UIDragPreviewTarget.init(container: self.imageView, center: .init(x: size.width/2, y: size.height/2), transform: .init(rotationAngle: 3.14))
//        return defaultPreview.retargetedPreview(with: target)
        let dragPreview = UITargetedDragPreview.init(view: label, parameters: .init(), target: target)
        return dragPreview
    }

    func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession) {
//        self.imageView.contentMode = .scaleAspectFit
        dragDropLog("\(#function)")
    }
}
