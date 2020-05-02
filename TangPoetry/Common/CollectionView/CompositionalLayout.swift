//
//  CompositionalLayout.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/2.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class CompositionalFlowLayout {
    static func demoCompositionalFlowLayout() -> UICollectionViewLayout {

        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration.init()
        layoutConfig.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (index, environment) -> NSCollectionLayoutSection? in
            print("ddd \(index)")
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let groupsize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            )
            if index == 0 {
                let size1 = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3),
                    heightDimension: .fractionalHeight(1)
                )
                let item1 = NSCollectionLayoutItem(layoutSize: size1)
                let groupsize1 = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.3)
                )

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize1, subitem: item1, count: 1)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuous
                return section

            } else {
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                return section
            }
        }, configuration: layoutConfig)
        print(layout.configuration.scrollDirection.rawValue)
//        layout.configuration.scrollDirection = .
        return layout
    }
}
