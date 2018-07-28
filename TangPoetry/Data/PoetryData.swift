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
    let detailid: Int
    let author: String
    let name: String
}

class DataProvider: NSObject {
    
    static var shared: DataProvider {
        return DataProvider.init()
    }

    private let allPoetryEntries: [PoetryEntry]

    override init() {
        let dataAsset = NSDataAsset.init(name: "allTitles")
        guard let data = dataAsset?.data else { fatalError() }
        //swiftlint:disable force_try
        let dataDict = try! JSONSerialization.jsonObject(with: data, options: [])
        // swiftlint:enable force_try
        guard let result = (dataDict as? [String: Any])?["result"] as? [[String: Any]] else {
            fatalError()
        }
        allPoetryEntries = result.compactMap { (dict) -> PoetryEntry? in
            guard let detailid = dict["detailid"] as? String,
                let author = dict["author"] as? String,
                let name = dict["name"] as? String else {
                    return nil
            }
            return PoetryEntry.init(detailid: Int(detailid)!, author: author, name: name)
        }

        super.init()
    }

    var poetryCount: Int {
        return allPoetryEntries.count
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
