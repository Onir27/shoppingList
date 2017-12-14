//
//  ShoppingItem.swift
//  ShoppingList
//
//  Created by Nirmalya Mahanti on 14/12/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import Foundation
struct ShoppingItem {
    let name: String
    let imageName: String
    let unitPrice: String
    let quantity: Int
    let description: String
}

extension ShoppingItem: Parsable {
    init?(with dictionary:[String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.imageName = dictionary["imageName"] as? String ?? ""
        self.unitPrice = dictionary["unitPrice"] as? String ?? ""
        self.quantity = dictionary["quantity"] as? Int ?? 0
        self.description = dictionary["description"] as? String ?? ""
    }
}
