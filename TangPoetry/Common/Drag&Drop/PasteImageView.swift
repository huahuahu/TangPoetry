//
//  PasteImgeView.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class PasteImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        //        let config = UIPasteConfiguration.init(forAccepting: UIImage.self)
        //        self.pasteConfiguration = config
        //        let springLoadedInteraction = UISpringLoadedInteraction.init { (_, context) in
        //            dragDropLog("springLoadedInteraction \(context.state)")
        //
        //            switch context.state {
        //            case .activated:
        //                self.backgroundColor = .systemBlue
        //            case .inactive:
        //                self.backgroundColor = .red
        //            default:
        //                dragDropLog("\(context.state)")
        //            }
        //        }
        //        self.addInteraction(springLoadedInteraction)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
        dragDropLog("\(#function)")
        return itemProviders.contains {
            $0.canLoadObject(ofClass: UIImage.self)
        }
    }

    override func paste(itemProviders: [NSItemProvider]) {
        let group = DispatchGroup.init()
        var images = [UIImage]()
        dragDropLog("\(#function)")

        itemProviders.forEach { (item) in
            group.enter()
            item.loadObject(ofClass: UIImage.self) { (res, error) in
                guard error == nil, let image = res as? UIImage else {
                    dragDropLog("\(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    images.append(image)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            if images.isEmpty {
                dragDropLog("\(#function): no result")
            } else if images.count == 1 {
                dragDropLog("\(#function): 1 image")
                self.image = images[0]
            } else {
                dragDropLog("\(#function): \(images.count) images")
                self.animationDuration = 1
                self.animationImages = images
                self.startAnimating()
            }
        }
    }
}
