//
//  PoetryData.swift
//  TangPoetry
//
//  Created by huahuahu on 2018/7/28.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import Foundation
import UIKit

struct PoetryEntry: Decodable {
    let id: Int
    let author: String
    let title: String
    let content: String
    let genre: Genre

    private enum CodingKeys : String, CodingKey {
        case id, author, title, content = "contents", genre = "type"
    }
}

enum Genre: String, Decodable, CaseIterable {
   case wuyanGushi = "五言古诗"
   case qiyanGushi = "七言古诗"
   case wuyanYuefu = "五言乐府"
   case qiyanYuefu = "七言乐府"
   case wuyanJueju = "五言绝句"
   case qiyanJueju = "七言绝句"
   case wuyanLvshi = "五言律诗"
   case qiyanLvshi = "七言律诗"
}


class DataProvider: NSObject {
    
    static var shared: DataProvider {
        return DataProvider.init()
    }

    public private(set) var allPoetryEntries: [PoetryEntry]

    override init() {
        let dataAsset = NSDataAsset.init(name: "allTitles")
        guard let data = dataAsset?.data else { fatalError() }
        //swiftlint:disable force_try
        allPoetryEntries = try! JSONDecoder().decode([PoetryEntry].self, from: data)

        super.init()
    }

    var poetryCount: Int {
        return allPoetryEntries.count
    }
    
    func searchFor(_ str: String?) -> [PoetryEntry] {
        if nil == str || str!.isEmpty  {
            return []
        }
        
        return allPoetryEntries.filter({ (poetry) -> Bool in
            poetry.author.contains(str!)
        })
        
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
