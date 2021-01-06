//
//  PoetryData.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/28.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DataProvider: NSObject {
    
    static var shared = DataProvider.init()

    public private(set) var allPoetryEntries: [Poem]
    public private(set) var authors: [String]
    public private(set) var authorPoemsMap: [String: [Poem]]
    private override init() {
        let dataAsset = NSDataAsset.init(name: "allTitles")
        guard let data = dataAsset?.data else { fatalError() }
        //swiftlint:disable force_try
        allPoetryEntries = try! JSONDecoder().decode([Poem].self, from: data)
        authors = Set(allPoetryEntries.map { $0.author}).sorted {
            $0.compareUsingChs($1) == .orderedAscending
        }

        var rawPoetMap = [String: [Poem]]()
        for poem in allPoetryEntries {
            let poet = poem.author
            if rawPoetMap[poet] == nil {
                rawPoetMap[poet] = [poem]
            } else {
                var rawPoems = rawPoetMap[poet]
                rawPoems?.append(poem)
                rawPoetMap[poet] = rawPoems
            }
        }
        authorPoemsMap = rawPoetMap.mapValues {
            $0.sorted {
                $0.title.compareUsingChs($1.title) == .orderedAscending
            }
        }
        super.init()
        fetchDataFromFirebase()
    }

    var poetryCount: Int {
        return allPoetryEntries.count
    }

    func searchFor(_ str: String?) -> [Poem] {
        if nil == str || str!.isEmpty {
            return []
        }
        
        return allPoetryEntries.filter({ (poetry) -> Bool in
            poetry.author.contains(str!)
        })
    }

    public func poemsOfGenre(_ genre: Genre) -> [Poem] {
        return allPoetryEntries.filter({ $0.genre == genre}).sorted {
            $0.title.compareUsingChs($1.title) == .orderedAscending
        }
    }

    func fetchDataFromFirebase() {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let docRef = db.collection("Poems")
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                HLog.log(scene: .firebase, str: "get Poems fail \(error)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let poem = document.data()
                    HLog.log(scene: .firebase, str: "\(poem)")
                }
            }
        }

    }
}

//extension DataProvider: URLSessionDelegate {
//
//    func startRequest() -> Void {
//        let session = URLSession.shared
//        let url = URL.init(string: "https://api.jisuapi.com/tangshi/chapter?appkey=66d51ec18795c8ce")!
//
//        let task = session.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("error is \(error)")
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                (200...299).contains(httpResponse.statusCode) else {
//                    print("server error is \(response)")
//                    return
//            }
//            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
//                let data = data,
//                let string = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//                    let filePath = NSHomeDirectory() + "/titles.json"
//                    let url = URL.init(fileURLWithPath: filePath)
//                    try? data.write(to: url)
//                    print("got str \(string)")
//                }
//            }
//
//        }
//        task.resume()
//
//    }
//
//
//}
