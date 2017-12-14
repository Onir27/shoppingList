//
//  ShoppingListViewCell.swift
//  ShoppingList
//
//  Created by Nirmalya Mahanti on 14/12/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import UIKit

class ShoppingListViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemUnitPrice: UILabel!
    
    func setupWithItemData(_ item: ShoppingItem){
        itemImage.image = UIImage(named: item.imageName)
        name.text = item.name
        itemDescription.text = item.description
        itemQuantity.text = "Quantity: \(item.quantity)"
        itemUnitPrice.text = "Price: \(item.unitPrice)"
    }
    
}
