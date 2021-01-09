//
//  ImageDragDelegate.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class ImageViewDragDelegate: NSObject, UIDragInteractionDelegate {

    let imageView: UIImageView

    init(imageView: UIImageView) {
        dragDropLog("\(#function)")
        self.imageView = imageView
        super.init()
    }

    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {        dragDropLog("\(#function)")
        if let images = imageView.animationImages {
            return images.map { dragItem(for: $0) }
        } else if let image = imageView.image {
            return [image].map { dragItem(for: $0)}
        } else {
            return []
        }
    }

    func dragInteraction(_ interaction: UIDragInteraction, itemsForAddingTo session: UIDragSession, withTouchAt point: CGPoint) -> [UIDragItem] {

        dragDropLog("\(#function)")
        guard session.canLoadObjects(ofClass: UIImage.self) else {
            return []
        }
        let hasSameImage = session.items.contains {
            $0.localObject as AnyObject? === self.imageView.image
        }

        if hasSameImage {
            return []
        }

        if let images = imageView.animationImages {
            return images.map { dragItem(for: $0) }
        } else if let image = imageView.image {
            return [image].map { dragItem(for: $0)}
        } else {
            return []
        }
    }

    func dragInteraction(_ interaction: UIDragInteraction, sessionForAddingItems sessions: [UIDragSession], withTouchAt point: CGPoint) -> UIDragSession? {
        dragDropLog("\(#function)")
        return nil
    }

    // MARK: - Animating the Drag Behaviors
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        dragDropLog("\(#function)")
        animator.addAnimations {
            self.imageView.backgroundColor = .yellow
        }
        animator.addCompletion { position in
            if position == .end {
                // The lift ended normally, and a drag is now happening
                self.imageView.backgroundColor = .brown
            } else if position == .start {
                // The lift was cancelled and the animation returned to the start
                self.imageView.backgroundColor = .red
            }
        }
    }

    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        dragDropLog("\(#function)")
        animator.addAnimations {
            self.imageView.backgroundColor = .blue
        }
        animator.addCompletion { (_) in
            self.imageView.backgroundColor = .red
        }

    }

    // MARK: - Monitoring Drag Progress
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        dragDropLog("\(#function)")
        self.imageView.alpha = 0.7
    }

    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willAdd items: [UIDragItem], for addingInteraction: UIDragInteraction) {
        dragDropLog("\(#function)")
        //        self.imageView.alpha = 1

    }

    func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
        dragDropLog("\(#function)")
        let location = session.location(in: imageView)
        dragDropLog("\(#function): location is \(location)")
    }

    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        dragDropLog("\(#function) \(operation.rawValue)")
    }

    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        dragDropLog("\(#function) \(operation.rawValue)")
        if operation == .move {
            self.imageView.animationImages = nil
            self.imageView.stopAnimating()
            self.imageView.image = nil
        }
        self.imageView.alpha = 1
    }

    func dragInteraction(_ interaction: UIDragInteraction, sessionDidTransferItems session: UIDragSession) {
        dragDropLog("\(#function)")
    }

    // MARK: - Previews

    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let image = self.imageView.image else {
            return nil
        }
        dragDropLog("\(#function)")

        let previewImageView = UIImageView.init(image: image)
        previewImageView.backgroundColor = .systemBlue
        let ratio = previewImageView.bounds.height / previewImageView.bounds.width
        let width = self.imageView.bounds.width
        let height = self.imageView.bounds.height * ratio
        previewImageView.bounds = .init(origin: .zero, size: .init(width: width, height: height))
        let dragPoint = session.location(in: self.imageView)
        let target = UIDragPreviewTarget(container: self.imageView, center: dragPoint, transform: .init(rotationAngle: 3.14))
        let param = UIPreviewParameters.init()
        param.visiblePath = .init(roundedRect: .init(origin: .init(x: 100, y: 100), size: .init(width: 100, height: 100)), cornerRadius: 50)
        return UITargetedDragPreview.init(view: previewImageView, parameters: param, target: target)
    }

    func dragInteraction(_ interaction: UIDragInteraction, previewForCancelling item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        let label = UILabel.init()
        label.text = "cancelling"
        label.sizeToFit()
        let size = self.imageView.bounds
        let dragPreView = UITargetedDragPreview.init(view: label, parameters: .init(), target: .init(container: self.imageView, center: .init(x: size.width/2, y: size.height/2), transform: .init(scaleX: 2, y: 1)))
        dragDropLog("\(#function)")
        return dragPreView
    }

    func dragInteraction(_ interaction: UIDragInteraction, prefersFullSizePreviewsFor session: UIDragSession) -> Bool {
        return false
    }

    // MARK: - Restricting the Drag Behavior
    func dragInteraction(_ interaction: UIDragInteraction, sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }

    func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true
    }

    // MARK: - Help Methods
    private func dragItem(for image: UIImage) -> UIDragItem {
        let item = UIDragItem.init(itemProvider: .init(object: image))
        item.localObject = image
        item.previewProvider = {
            let label = UILabel.init(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
            label.text = "dragging"
            return UIDragPreview.init(view: label)
        }
        return item
    }
}
