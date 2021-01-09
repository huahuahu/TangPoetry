//
//  CollectionViewDropDelegate.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class CollectionViewDropDelegate: NSObject, UICollectionViewDropDelegate {
    private let collectionView: UICollectionView
    var dataSource: CustomDataSource<Poem>!

    init(collectionView: UICollectionView) {
        collectionViewDropLog("\(#function)")
        self.collectionView = collectionView
        collectionView.isSpringLoaded = true
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        collectionViewDropLog("\(#function)")
        guard let destinationIndexPath = coordinator.destinationIndexPath,
              let dragItem = coordinator.items.first?.dragItem,
              let poem = dragItem.localObject as? Poem
        else {
            return
        }

        //swiftlint:disable multiple_closures_with_trailing_closure
        collectionView.performBatchUpdates({
            var models = dataSource.models
            var sectionData = models[destinationIndexPath.section]
            sectionData.insert(poem, at: destinationIndexPath.row)
            models[destinationIndexPath.section] = sectionData
            dataSource.models = models
            //            collectionView.deleteItems(at: [UICollectionViewDropItem.sou])
            collectionView.insertItems(at: [destinationIndexPath])
        }) { succ in
            collectionViewDropLog("performBatchUpdates \(succ)")
        }

        coordinator.drop(dragItem, toItemAt: destinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        collectionViewDropLog("\(#function)")
        return .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        collectionViewDropLog("\(#function)")
        let params = UIDragPreviewParameters.init()
        params.visiblePath = .init(rect: .init(origin: .zero, size: .init(width: 50, height: 50)))
        return params
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        collectionViewDropLog("\(#function)")
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        collectionViewDropLog("\(#function)")
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        collectionViewDropLog("\(#function)")
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        collectionViewDropLog("\(#function)")
        return true
    }
}

private func collectionViewDropLog(_ str: String) {
    print("collectionViewDropLog: \(str)")
}
