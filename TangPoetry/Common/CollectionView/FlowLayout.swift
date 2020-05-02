//
//  Layout.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        print("\(#function)")
        print(layoutAttributes)
        layoutAttributes.size = .init(width: collectionView.bounds.width, height: layoutAttributes.bounds.height)
        return layoutAttributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach { layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                print("\(#function)")

                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        }
        return layoutAttributesObjects

    }

    static func testDemo() -> CustomFlowLayout {
        let layout = CustomFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20
        return layout
    }
}
