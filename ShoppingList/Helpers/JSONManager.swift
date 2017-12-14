//
//  JSONManager.swift
//  AssignmentDec13
//
//  Created by Nirmalya Mahanti on 13/12/17.
//  Copyright © 2017 Nirmalya. All rights reserved.
//

import Foundation
protocol Parsable {
    init?(with dictionary:[String:Any])
}

protocol JSONManager {
    associatedtype Item:Parsable
    var filename: String {get}
    func readFromJsonFile() -> [Item]?
    func parse(_ array:[Any]) -> [Item]
}

extension JSONManager {
    func readFromJsonFile() -> [Item]? {
        do {
            if let file = Bundle.main.url(forResource: filename, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    if let objectArray = object["results"] as? [Any] {
                        return parse(objectArray)
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func parse(_ array:[Any]) -> [Item] {
        var parsedList = [Item]()
        for object in array {
            if let dictObject = object as? [String:Any] {
                if let emp = Item(with: dictObject) {
                    parsedList.append(emp)
                }
            }
        }
        return parsedList
    }
}

struct ShoppingItemJSONManager: JSONManager {
    typealias Item = ShoppingItem
    var filename : String {return  "ShoppingList"}
}

