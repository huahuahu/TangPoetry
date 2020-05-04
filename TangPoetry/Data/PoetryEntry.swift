//
//  PoetryEntry.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/4.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import CoreServices

enum Genre: String, Codable, CaseIterable {
   case wuyanGushi = "五言古诗"
   case qiyanGushi = "七言古诗"
   case wuyanYuefu = "五言乐府"
   case qiyanYuefu = "七言乐府"
   case wuyanJueju = "五言绝句"
   case qiyanJueju = "七言绝句"
   case wuyanLvshi = "五言律诗"
   case qiyanLvshi = "七言律诗"
}

struct PoetryEntry: Codable {
    let uniqueId: Int
    let author: String
    let title: String
    let content: String
    let genre: Genre

    private enum CodingKeys: String, CodingKey {
        case uniqueId = "id", author, title, content = "contents", genre = "type"
    }
}

class PoetryClass: NSObject, Codable {
    private(set) var uniqueId: Int!
    private(set) var author: String!
    private(set) var title: String!
    private(set) var content: String!
    private(set) var genre: Genre!

    static func testPoem() -> PoetryClass {
        let poem = PoetryClass()
        poem.uniqueId = 1000
        poem.author = "testAuthor"
        poem.title = "testTitle"
        poem.content = "testContent"
        poem.genre = .qiyanLvshi
        return poem
    }
}

extension PoetryClass: NSItemProviderReading, NSItemProviderWriting {
    static let poetryType = "com.tiger.PoetryEntry"
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [poetryType, kUTTypeData as NSString as String]
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        // swiftlint:disable force_cast
        switch typeIdentifier {
        case PoetryClass.poetryType:
            return try JSONDecoder().decode(PoetryClass.self, from: data) as! Self
        case kUTTypeData as NSString as String:
            return try JSONDecoder().decode(PoetryClass.self, from: data) as! Self
        default:
            fatalError("not supported typeIdentifier \(typeIdentifier)")
        }
        // swiftlint:enable force_cast
    }

    static var writableTypeIdentifiersForItemProvider: [String] {
        return [poetryType]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        switch typeIdentifier {
        case PoetryClass.poetryType, kUTTypeData as NSString as String:
            let data = try? JSONEncoder().encode(self)
            if data == nil {
                fatalError("encode error in \(#function)")
            }
            completionHandler(data, nil)
        default:
            fatalError("not supported typeIdentifier \(typeIdentifier) in \(#function)")
        }
        return nil
    }

    
}
