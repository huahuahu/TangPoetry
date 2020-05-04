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

    private func dragItem(for image: UIImage) -> UIDragItem {
        let item = UIDragItem.init(itemProvider: .init(object: image))
        item.localObject = image
        return item
    }
}
