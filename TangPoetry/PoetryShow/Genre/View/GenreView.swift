//
//  GenreView.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class GenreView: UIView {
    let collectionView: UICollectionView
    let collectionViewLayout: UICollectionViewLayout = CompositionalFlowLayout.demoCompositionalFlowLayout()
    var dataSource: UICollectionViewDataSource!

    init() {
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .red
        addSubview(collectionView)
        setupConstraints()
        collectionView.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(with poems: [PoetryEntry]) {
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        let models = [
            Array(poems.prefix(upTo: 5)),
            Array(poems.suffix(100))
        ]
        dataSource = CustomDataSource.init(models: models, modelToCellBlock: { (poem, indexPath) -> UICollectionViewCell in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier, for: indexPath) as? CollectionCell
            cell?.setup(with: poem)
            return cell!
        })
        collectionView.dataSource = dataSource
//        collectionView.reloadData()
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

    }
}
