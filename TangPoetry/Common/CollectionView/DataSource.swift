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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return block(models[indexPath.row], indexPath)
    }

    let models: [T]
    let block: (T, IndexPath) -> UICollectionViewCell

    init(models: [T], modelToCellBlock: @escaping ((T, IndexPath) -> UICollectionViewCell)) {
        self.models = models
        self.block = modelToCellBlock
    }
    
}
