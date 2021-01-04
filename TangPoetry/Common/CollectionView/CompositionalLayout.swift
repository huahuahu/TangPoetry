//
//  CompositionalLayout.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/2.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit
//https://medium.com/flawless-app-stories/all-what-you-need-to-know-about-uicollectionviewcompositionallayout-f3b2f590bdbe
class CompositionalFlowLayout {
    static func demoCompositionalFlowLayout() -> UICollectionViewLayout {

        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration.init()
        layoutConfig.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (index, _) -> NSCollectionLayoutSection? in
            print("ddd \(index)")
            if index == 0 {
                let size1 = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.4),
                    heightDimension: .fractionalHeight(1)
                )
                let item1 = NSCollectionLayoutItem(layoutSize: size1)

                let groupsize1 = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(300)
                )

//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize1, subitems: [item1])
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize1, subitem: item1, count: 1)
                group.interItemSpacing = .fixed(10)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 20
                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section

            } else {
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .estimated(44)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let groupsize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(44)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 30
                return section
            }
        }, configuration: layoutConfig)
        print(layout.configuration.scrollDirection.rawValue)
//        layout.configuration.scrollDirection = .
        return layout
    }
}
