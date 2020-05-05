//
//  CollectionViewDragDelegate.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class CollectionViewDragDelegate: NSObject, UICollectionViewDragDelegate {

    private let collectionView: UICollectionView

    var models: [[Poem]]!

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let poem = models[indexPath.section][indexPath.row]
        let item = dragItem(for: poem)
        return [item]
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let current = models[indexPath.section][indexPath.row]
        let hasBeenAdded = session.items.contains(where: { ($0.localObject as? Poem)?.uniqueId == current.uniqueId})
        if hasBeenAdded {
            return []
        } else {
            return [dragItem(for: current)]
        }
    }

    private func dragItem(for poem: Poem) -> UIDragItem {
        let provider = NSItemProvider(object: PoemClass.from(poem: poem))
        let userActivity = poem.userActivity()
        provider.registerObject(userActivity, visibility: .all)

        let item = UIDragItem.init(itemProvider: provider)
        item.localObject = poem
        return item
    }

    // MARK: - Tracking the Drag Session
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        collectionViewDragLog("\(#function)")
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        collectionViewDragLog("\(#function)")
    }

//    // MARK: - Providing a Custom Preview
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        collectionViewDragLog("\(#function)")
//        return nil
//    }
//    // MARK: - Controlling the Drag Session
//    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
//        collectionViewDragLog("\(#function)")
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
//        collectionViewDragLog("\(#function)")
//        return true
//    }
}

private func collectionViewDragLog(_ str: String) {
    print("collectionViewDragLog: \(str)")
}
