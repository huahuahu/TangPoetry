//
//  DataSource.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import UIKit

class CustomDataSource<T: Any>: NSObject, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return block(models[indexPath.section][indexPath.row], indexPath)
    }

    var models: [[T]]
    let block: (T, IndexPath) -> UICollectionViewCell

    init(models: [[T]], modelToCellBlock: @escaping ((T, IndexPath) -> UICollectionViewCell)) {
        self.models = models
        self.block = modelToCellBlock
    }
    
}
