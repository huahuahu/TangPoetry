//
//  SpotlightController.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/5.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

struct SpotlightController {
    static let shared = SpotlightController()

    private let poems = DataProvider.shared.allPoetryEntries

    private init() {}

    func startIndex() {
        var items = [CSSearchableItem]()
        for (index, poem) in poems.enumerated() {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = poem.author
            attributeSet.contentDescription = poem.content

            let item = CSSearchableItem(uniqueIdentifier: "\(index)", domainIdentifier: "com.tiger.shenzhen.poem", attributeSet: attributeSet)
            items.append(item)
        }

        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }
}
